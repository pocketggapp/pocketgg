//
//  SmashGGDeeplinkVC.swift
//  OpenSmashGGURL
//
//  Created by Gabriel Siu on 2021-08-12.
//  Copyright © 2021 Gabriel Siu. All rights reserved.
//

import UIKit
import MobileCoreServices

final class SmashGGDeeplinkVC: UIViewController {
    
    let imageView = UIImageView(image: UIImage(named: "tournament-red"))
    let titleLabel = UILabel()
    let messageLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        setupViews()
        
        if let extensionItem = extensionContext?.inputItems.first as? NSExtensionItem,
           let itemProvider = extensionItem.attachments?.first, itemProvider.hasItemConformingToTypeIdentifier("public.url") {

            itemProvider.loadItem(forTypeIdentifier: kUTTypeURL as String, options: nil) { [weak self] result, error in
                guard error == nil, let url = result as? URL else {
                    self?.showErrorMessage("Unable to retrieve a URL")
                    return
                }
                
                if let slug = self?.validateSmashGGURL(url) {
                    if let pocketggURL = URL(string: "pocketgg://" + slug) {
                        self?.openURL(pocketggURL)
                        self?.extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
                    }
                }
            }
        } else {
            showErrorMessage("Unable to retrieve a public URL")
        }
    }
    
    private func validateSmashGGURL(_ url: URL) -> String? {
        if let range = url.absoluteString.range(of: "smash.gg") {
            let trimmedURL = url.absoluteString[url.absoluteString.index(range.upperBound, offsetBy: 1)...]
            if let backslashIndex = trimmedURL.firstIndex(of: "/") {
                let urlType = trimmedURL[..<backslashIndex]
                switch urlType {
                case "tournament":
                    let slug: Substring
                    if let secondBackslashIndex = trimmedURL[trimmedURL.index(after: backslashIndex)...].firstIndex(of: "/") {
                        slug = trimmedURL[..<secondBackslashIndex]
                    } else {
                        slug = trimmedURL
                    }
                    return String(slug)
                case "league":
                    showErrorMessage("Leagues are currently not supported in pocket.gg")
                default:
                    showErrorMessage("This type of smash.gg page (\(urlType)) is currently not supported in pocket.gg")
                }
            } else {
                showErrorMessage("Not a smash.gg tournament page")
            }
        } else {
            showErrorMessage("Not a valid smash.gg page")
        }
        return nil
    }

    private func setupViews() {
        view.backgroundColor = .systemBackground
        
        imageView.contentMode = .scaleAspectFit
        
        titleLabel.text = "Opening link in pocket.gg..."
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.boldSystemFont(ofSize: titleLabel.font.pointSize)
        titleLabel.numberOfLines = 0
        
        messageLabel.text = ""
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        
        view.addSubview(imageView)
        view.addSubview(titleLabel)
        view.addSubview(messageLabel)
        
        titleLabel.setAxisConstraints(yAnchor: view.centerYAnchor)
        titleLabel.setEdgeConstraints(top: imageView.bottomAnchor,
                                      bottom: messageLabel.topAnchor,
                                      leading: messageLabel.leadingAnchor,
                                      trailing: messageLabel.trailingAnchor,
                                      padding: UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0))
        messageLabel.setEdgeConstraints(top: titleLabel.bottomAnchor,
                                        leading: view.leadingAnchor,
                                        trailing: view.trailingAnchor,
                                        padding: UIEdgeInsets(top: 16, left: 16, bottom: 0, right: 16))
        
        imageView.setAxisConstraints(xAnchor: view.centerXAnchor)
        imageView.setEdgeConstraints(bottom: titleLabel.topAnchor,
                                     padding: UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0))
        imageView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        imageView.topAnchor.constraint(greaterThanOrEqualTo: view.topAnchor, constant: 16).isActive = true
    }
    
    private func showErrorMessage(_ message: String) {
        titleLabel.text = "Unable to open link in pocket.gg"
        messageLabel.text = message
    }
    
    // MARK: - Actions
    
    @objc private func dismissVC() {
        extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
    }
}

// MARK: - Extensions

extension UIViewController {
    @objc func openURL(_ url: URL) {
        var responder: UIResponder? = self
        while responder != nil {
            if let application = responder as? UIApplication {
                application.perform(#selector(openURL(_:)), with: url)
            }
            responder = responder?.next
        }
    }
}

extension UIView {
    func setEdgeConstraints(top: NSLayoutYAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, leading: NSLayoutXAxisAnchor? = nil, trailing: NSLayoutXAxisAnchor? = nil, padding: UIEdgeInsets = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: padding.top).isActive = true
        }
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom).isActive = true
        }
        if let leading = leading {
            leadingAnchor.constraint(equalTo: leading, constant: padding.left).isActive = true
        }
        if let trailing = trailing {
            trailingAnchor.constraint(equalTo: trailing, constant: -padding.right).isActive = true
        }
    }
    
    func setAxisConstraints(xAnchor: NSLayoutXAxisAnchor? = nil, yAnchor: NSLayoutYAxisAnchor? = nil) {
        translatesAutoresizingMaskIntoConstraints = false
        if let xAnchor = xAnchor {
            centerXAnchor.constraint(equalTo: xAnchor).isActive = true
        }
        if let yAnchor = yAnchor {
            centerYAnchor.constraint(equalTo: yAnchor).isActive = true
        }
    }
}
