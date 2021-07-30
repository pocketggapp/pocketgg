//
//  ImageCacheService.swift
//  pocket.gg
//
//  Created by Gabriel Siu on 2020-02-15.
//  Copyright © 2020 Gabriel Siu. All rights reserved.
//

import UIKit

enum Cache {
    case regular
    case viewAllTournaments
    case tournamentSearchResults
    case profileTournaments
    case tournamentsByTO
}

final class ImageCacheService {
    private static let cache = NSCache<NSString, UIImage>()
    private static let viewAllTournamentsCache = NSCache<NSString, UIImage>()
    private static let tournamentSearchResultsCache = NSCache<NSString, UIImage>()
    private static let profileTournamentsCache = NSCache<NSString, UIImage>()
    private static let tournamentsByTOCache = NSCache<NSString, UIImage>()
    
    static func getCachedImage(with key: String, cache: Cache = .regular) -> UIImage? {
        switch cache {
        case .regular: return self.cache.object(forKey: key as NSString)
        case .viewAllTournaments: return viewAllTournamentsCache.object(forKey: key as NSString)
        case .tournamentsByTO: return tournamentsByTOCache.object(forKey: key as NSString)
        case .tournamentSearchResults: return tournamentSearchResultsCache.object(forKey: key as NSString)
        case .profileTournaments: return profileTournamentsCache.object(forKey: key as NSString)
        }
    }
    
    static func saveImageToCache(image: UIImage, with key: String, cache: Cache = .regular) {
        switch cache {
        case .regular: self.cache.setObject(image, forKey: key as NSString)
        case .viewAllTournaments: viewAllTournamentsCache.setObject(image, forKey: key as NSString)
        case .tournamentsByTO: tournamentsByTOCache.setObject(image, forKey: key as NSString)
        case .tournamentSearchResults: tournamentSearchResultsCache.setObject(image, forKey: key as NSString)
        case .profileTournaments: profileTournamentsCache.setObject(image, forKey: key as NSString)
        }
    }
    
    static func clearCache(_ cache: Cache = .regular) {
        switch cache {
        case .regular: self.cache.removeAllObjects()
        case .viewAllTournaments: viewAllTournamentsCache.removeAllObjects()
        case .tournamentsByTO: tournamentsByTOCache.removeAllObjects()
        case .tournamentSearchResults: tournamentSearchResultsCache.removeAllObjects()
        case .profileTournaments: profileTournamentsCache.removeAllObjects()
        }
    }
}
