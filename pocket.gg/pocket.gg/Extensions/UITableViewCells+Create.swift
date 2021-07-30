//
//  UITableViewCells+Create.swift
//  pocket.gg
//
//  Created by Gabriel Siu on 2020-03-22.
//  Copyright © 2020 Gabriel Siu. All rights reserved.
//

import UIKit

extension UITableViewCell {
    
    func setupActive(textColor: UIColor, text: String?, detailText: String? = nil) -> UITableViewCell {
        textLabel?.textColor = textColor
        accessoryType = .disclosureIndicator
        textLabel?.text = text
        detailTextLabel?.text = detailText
        return self
    }
    
    func setupDisabled(_ text: String?) -> UITableViewCell {
        isUserInteractionEnabled = false
        textLabel?.text = text
        textLabel?.numberOfLines = 0
        return self
    }
}
