//
//  TournamentInfoService.swift
//  pocket.gg
//
//  Created by Gabriel Siu on 2021-08-30.
//  Copyright © 2021 Gabriel Siu. All rights reserved.
//

import Foundation

struct GetTournamentsByVideogamesInfo {
    let perPage: Int
    let pageNum: Int
    let gameIDs: [Int]
    let featured: Bool
    let upcoming: Bool
    let countryCode: String
    let addrState: String
}

final class TournamentInfoService {
    
    static func getFeaturedTournaments(perPage: Int, pageNum: Int, gameIDs: [Int], complete: @escaping (_ tournaments: [Tournament]?) -> Void) {
        ApolloService.shared.client.fetch(query: FeaturedTournamentsQuery(perPage: perPage,
                                                                          pageNum: pageNum,
                                                                          videogameIds: gameIDs.map { String($0) }),
                                          cachePolicy: .fetchIgnoringCacheCompletely,
                                          queue: .global(qos: .utility)) { result in
            switch result {
            case .failure(let error):
                debugPrint(k.Error.apolloFetch, error as Any)
                DispatchQueue.main.async { complete(nil) }
                return
                
            case .success(let graphQLResult):
                var tournaments = [Tournament]()
                if let nodes = graphQLResult.data?.tournaments?.nodes {
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
    
    static func getTournamentsByVideogames(_ info: GetTournamentsByVideogamesInfo, complete: @escaping (_ tournaments: [Tournament]?) -> Void) {
        ApolloService.shared.client.fetch(query: TournamentsByVideogamesQuery(perPage: info.perPage,
                                                                              pageNum: info.pageNum,
                                                                              videogameIds: info.gameIDs.map { String($0) },
                                                                              featured: info.featured,
                                                                              upcoming: info.upcoming,
                                                                              countryCode: info.countryCode,
                                                                              addrState: info.addrState),
                                          cachePolicy: .fetchIgnoringCacheCompletely,
                                          queue: .global(qos: .utility)) { result in
            switch result {
            case .failure(let error):
                debugPrint(k.Error.apolloFetch, error as Any)
                DispatchQueue.main.async { complete(nil) }
                return
                
            case .success(let graphQLResult):
                var tournaments = [Tournament]()
                if let nodes = graphQLResult.data?.tournaments?.nodes {
                    tournaments = nodes.map {
                        let start = DateFormatter.shared.dateFromTimestamp($0?.startAt)
                        let end = DateFormatter.shared.dateFromTimestamp($0?.endAt)
                        let date = start == end ? start : "\(start) - \(end)"
                        
                        // TODO: Refactor this and all similar logic to use "type" property instead to distinguish between profile and banner images
                        let logo = $0?.images?.reduce(("", 10), { (smallestImage, image) -> (String, Double) in
                            guard let url = image?.url else { return smallestImage }
                            guard let ratio = image?.ratio else { return smallestImage }
                            if ratio < smallestImage.1 { return (url, ratio) }
                            return smallestImage
                        })
                        
                        let header = $0?.images?.reduce(("", 1), { (widestImage, image) -> (String, Double) in
                            guard let url = image?.url else { return widestImage }
                            guard let ratio = image?.ratio else { return widestImage }
                            if ratio > widestImage.1 { return (url, ratio) }
                            return widestImage
                        })
                        
                        return Tournament(id: Int($0?.id ?? "nil"),
                                          name: $0?.name,
                                          date: date,
                                          logoUrl: logo?.0,
                                          isOnline: $0?.isOnline,
                                          location: Location(address: $0?.venueAddress),
                                          headerImage: header)
                    }
                }
                DispatchQueue.main.async { complete(tournaments) }
            }
        }
    }
    
    static func searchForTournaments(_ search: String?, gameIDs: [Int], featured: Bool, sortBy: String, perPage: Int, page: Int, complete: @escaping (_ tournaments: [Tournament]?) -> Void) {
        ApolloService.shared.client.fetch(query: SearchForTournamentsQuery(search: search,
                                                                           videogameIds: gameIDs.map { String($0) },
                                                                           featured: featured,
                                                                           sortBy: sortBy,
                                                                           perPage: perPage,
                                                                           page: page),
                                          cachePolicy: .fetchIgnoringCacheCompletely,
                                          queue: .global(qos: .utility)) { (result) in
            switch result {
            case .failure(let error):
                debugPrint(k.Error.apolloFetch, error as Any)
                DispatchQueue.main.async { complete(nil) }
                return
                
            case .success(let graphQLResult):
                var tournaments = [Tournament]()
                if let nodes = graphQLResult.data?.tournaments?.nodes {
                    tournaments = nodes.map {
                        let start = DateFormatter.shared.dateFromTimestamp($0?.startAt)
                        let end = DateFormatter.shared.dateFromTimestamp($0?.endAt)
                        let date = start == end ? start : "\(start) - \(end)"
                        
                        let logo = $0?.images?.reduce(("", 10), { (smallestImage, image) -> (String, Double) in
                            guard let url = image?.url else { return smallestImage }
                            guard let ratio = image?.ratio else { return smallestImage }
                            if ratio < smallestImage.1 { return (url, ratio) }
                            return smallestImage
                        })
                        
                        let header = $0?.images?.reduce(("", 1), { (widestImage, image) -> (String, Double) in
                            guard let url = image?.url else { return widestImage }
                            guard let ratio = image?.ratio else { return widestImage }
                            if ratio > widestImage.1 { return (url, ratio) }
                            return widestImage
                        })
                        
                        return Tournament(id: Int($0?.id ?? "nil"),
                                          name: $0?.name,
                                          date: date,
                                          logoUrl: logo?.0,
                                          isOnline: $0?.isOnline,
                                          location: Location(address: $0?.venueAddress),
                                          headerImage: header)
                    }
                }
                DispatchQueue.main.async { complete(tournaments) }
            }
        }
    }
    
    static func getTournamentBySlug(_ slug: String, complete: @escaping (_ tournament: Tournament?, _ error: Error?) -> Void) {
        ApolloService.shared.client.fetch(query: TournamentBySlugQuery(slug: slug),
                                          cachePolicy: .fetchIgnoringCacheCompletely,
                                          queue: .global(qos: .utility)) { (result) in
            switch result {
            case .failure(let error):
                debugPrint(k.Error.apolloFetch, error as Any)
                DispatchQueue.main.async { complete(nil, error) }
                return
                
            case .success(let graphQLResult):
                guard let tournament = graphQLResult.data?.tournament else {
                    DispatchQueue.main.async { complete(nil, nil) }
                    return
                }
                
                let start = DateFormatter.shared.dateFromTimestamp(tournament.startAt)
                let end = DateFormatter.shared.dateFromTimestamp(tournament.endAt)
                let date = start == end ? start : "\(start) - \(end)"
                
                let logoURL = tournament.images?.first(where: { $0?.type ?? "" == "profile" })??.url
                let header = tournament.images?.reduce(("", 1), { (widestImage, image) -> (String, Double) in
                    guard let url = image?.url else { return widestImage }
                    guard let ratio = image?.ratio else { return widestImage }
                    if ratio > widestImage.1 { return (url, ratio) }
                    return widestImage
                })
                
                DispatchQueue.main.async {
                    complete(Tournament(id: Int(tournament.id ?? "nil"),
                                        name: tournament.name,
                                        date: date,
                                        logoUrl: logoURL,
                                        isOnline: tournament.isOnline,
                                        location: Location(address: tournament.venueAddress),
                                        headerImage: header), nil)
                }
            }
        }
    }
}
