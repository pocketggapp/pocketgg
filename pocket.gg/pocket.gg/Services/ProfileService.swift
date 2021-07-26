//
//  ProfileService.swift
//  pocket.gg
//
//  Created by Gabriel Siu on 2021-07-25.
//  Copyright © 2021 Gabriel Siu. All rights reserved.
//

import UIKit
import Apollo

final class ProfileService {
    
    static func getProfile(perPage: Int, complete: @escaping (_ profile: [String: Any?]?) -> Void) {
        ApolloService.shared.client.fetch(query: CurrentUserQuery(perPage: perPage),
                                          cachePolicy: .fetchIgnoringCacheCompletely,
                                          queue: .global(qos: .utility)) { (result) in
            switch result {
            case .failure(let error):
                debugPrint(k.Error.apolloFetch, error as Any)
                DispatchQueue.main.async { complete(nil) }
                return
                
            case .success(let graphQLResult):
                var tournaments = [Tournament]()
                if let nodes = graphQLResult.data?.currentUser?.tournaments?.nodes {
                    tournaments = nodes.map {
                        let start = DateFormatter.shared.dateFromTimestamp($0?.startAt)
                        let end = DateFormatter.shared.dateFromTimestamp($0?.endAt)
                        let date = start == end ? start : "\(start) - \(end)"
                        
                        let logoURL = $0?.images?.first(where: { $0?.type ?? "" == "profile" })??.url
                        let header = $0?.images?.reduce(("", 1), { (widestImage, image) -> (String, Double) in
                            guard let url = image?.url else { return widestImage }
                            guard let ratio = image?.ratio else { return widestImage }
                            if ratio > widestImage.1 { return (url, ratio) }
                            return widestImage
                        })
                        
                        return Tournament(id: Int($0?.id ?? "nil"),
                                          name: $0?.name,
                                          date: date,
                                          logoUrl: logoURL,
                                          isOnline: $0?.isOnline,
                                          location: Location(address: $0?.venueAddress),
                                          headerImage: header)
                    }
                }
                
                DispatchQueue.main.async {
                    complete(["name": graphQLResult.data?.currentUser?.player?.gamerTag,
                              "bio": graphQLResult.data?.currentUser?.bio,
                              "teamName": graphQLResult.data?.currentUser?.player?.prefix,
                              "imageURL": graphQLResult.data?.currentUser?.images?.first(where: { $0?.type ?? "" == "profile" })??.url,
                              "tournaments": tournaments])
                }
            }
        }
    }
    
    static func getProfileTournaments(page: Int, perPage: Int, complete: @escaping (_ tournaments: [Tournament]?) -> Void) {
        ApolloService.shared.client.fetch(query: CurrentUserTournamentsQuery(page: page, perPage: perPage),
                                          cachePolicy: .fetchIgnoringCacheCompletely, queue: .global(qos: .utility)) { (result) in
            switch result {
            case .failure(let error):
                debugPrint(k.Error.apolloFetch, error as Any)
                DispatchQueue.main.async { complete(nil) }
                return
                
            case .success(let graphQLResult):
                var tournaments = [Tournament]()
                if let nodes = graphQLResult.data?.currentUser?.tournaments?.nodes {
                    tournaments = nodes.map {
                        let start = DateFormatter.shared.dateFromTimestamp($0?.startAt)
                        let end = DateFormatter.shared.dateFromTimestamp($0?.endAt)
                        let date = start == end ? start : "\(start) - \(end)"
                        
                        let logoURL = $0?.images?.first(where: { $0?.type ?? "" == "profile" })??.url
                        let header = $0?.images?.reduce(("", 1), { (widestImage, image) -> (String, Double) in
                            guard let url = image?.url else { return widestImage }
                            guard let ratio = image?.ratio else { return widestImage }
                            if ratio > widestImage.1 { return (url, ratio) }
                            return widestImage
                        })
                        
                        return Tournament(id: Int($0?.id ?? "nil"),
                                          name: $0?.name,
                                          date: date,
                                          logoUrl: logoURL,
                                          isOnline: $0?.isOnline,
                                          location: Location(address: $0?.venueAddress),
                                          headerImage: header)
                    }
                }
                DispatchQueue.main.async { complete(tournaments) }
            }
        }
    }
}
