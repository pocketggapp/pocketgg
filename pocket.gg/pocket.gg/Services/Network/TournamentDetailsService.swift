//
//  TournamentDetailsService.swift
//  pocket.gg
//
//  Created by Gabriel Siu on 2021-08-30.
//  Copyright © 2021 Gabriel Siu. All rights reserved.
//

import Foundation

final class TournamentDetailsService {
    
    static func getTournamentDetails(_ id: Int, complete: @escaping (_ tournament: [String: Any?]?) -> Void) {
        ApolloService.shared.client.fetch(query: TournamentDetailsQuery(id: "\(id)"),
                                          cachePolicy: .fetchIgnoringCacheCompletely,
                                          queue: .global(qos: .utility)) { (result) in
            switch result {
            case .failure(let error):
                debugPrint(k.Error.apolloFetch, error as Any)
                DispatchQueue.main.async { complete(nil) }
                return
                
            case .success(let graphQLResult):
                guard let tournament = graphQLResult.data?.tournament else {
                    DispatchQueue.main.async { complete(nil) }
                    return
                }
                
                var events = [Event]()
                if let tournamentEvents = tournament.events {
                    events = tournamentEvents.map {
                        Event(id: Int($0?.id ?? "nil"),
                              name: $0?.name,
                              state: $0?.state?.rawValue,
                              winner: EntrantService.getEventWinner($0),
                              startDate: $0?.startAt,
                              eventType: $0?.type,
                              videogameName: $0?.videogame?.name,
                              videogameImage: $0?.videogame?.images?.compactMap { return ($0?.url, $0?.ratio) }.first)
                    }
                }
                
                var streams = [Stream]()
                if let tournamentStreams = tournament.streams {
                    streams = tournamentStreams.map {
                        Stream(name: $0?.streamName,
                               logoUrl: $0?.streamLogo,
                               sourceUrl: $0?.streamSource?.rawValue)
                    }
                }
                
                DispatchQueue.main.async {
                    complete(["venueName": tournament.venueName,
                              "longitude": tournament.lng,
                              "latitude": tournament.lat,
                              "events": events,
                              "streams": streams,
                              "registration": (tournament.isRegistrationOpen, tournament.registrationClosesAt),
                              "contact": (tournament.primaryContact, tournament.primaryContactType),
                              "slug": tournament.slug,
                              "ownerID": Int(tournament.owner?.id ?? "nil"),
                              "ownerName": tournament.owner?.player?.gamerTag,
                              "ownerPrefix": tournament.owner?.player?.prefix,
                              "isAdmin": tournament.admins != nil])
                }
            }
        }
    }
    
    static func getEvent(_ id: Int, complete: @escaping (_ event: [String: Any?]?) -> Void) {
        ApolloService.shared.client.fetch(query: EventQuery(id: "\(id)"),
                                          cachePolicy: .fetchIgnoringCacheCompletely,
                                          queue: .global(qos: .utility)) { (result) in
            switch result {
            case .failure(let error):
                debugPrint(k.Error.apolloFetch, error as Any)
                DispatchQueue.main.async { complete(nil) }
                return
                
            case .success(let graphQLResult):
                var phases = [Phase]()
                if let eventPhases = graphQLResult.data?.event?.phases {
                    phases = eventPhases.map {
                        return Phase(id: Int($0?.id ?? "nil"),
                                     name: $0?.name,
                                     state: $0?.state?.rawValue,
                                     numPhaseGroups: $0?.groupCount,
                                     numEntrants: $0?.numSeeds,
                                     bracketType: $0?.bracketType?.rawValue)
                    }
                }
                
                var topStandings = [Standing]()
                if let nodes = graphQLResult.data?.event?.standings?.nodes {
                    topStandings = nodes.compactMap { EntrantService.getEntrantAndStanding($0) }
                }
                
                DispatchQueue.main.async {
                    complete(["phases": phases,
                              "topStandings": topStandings])
                }
            }
        }
    }
    
    static func getEventStandings(_ id: Int, page: Int, complete: @escaping (_ standings: [Standing]?) -> Void) {
        ApolloService.shared.client.fetch(query: EventStandingsQuery(id: "\(id)", page: page),
                                          cachePolicy: .fetchIgnoringCacheCompletely,
                                          queue: .global(qos: .utility)) { (result) in
            switch result {
            case .failure(let error):
                debugPrint(k.Error.apolloFetch, error as Any)
                DispatchQueue.main.async { complete(nil) }
                return
            
            case .success(let graphQLResult):
                var standings = [Standing]()
                if let nodes = graphQLResult.data?.event?.standings?.nodes {
                    standings = nodes.compactMap { EntrantService.getEntrantAndStanding2($0) }
                }
                DispatchQueue.main.async { complete(standings) }
            }
        }
    }
    
    static func getPhaseGroups(_ id: Int, numPhaseGroups: Int, complete: @escaping (_ phaseGroups: [PhaseGroup]?) -> Void) {
        ApolloService.shared.client.fetch(query: PhaseGroupsQuery(id: "\(id)", perPage: numPhaseGroups),
                                          cachePolicy: .fetchIgnoringCacheCompletely,
                                          queue: .global(qos: .utility)) { (result) in
            switch result {
            case .failure(let error):
                debugPrint(k.Error.apolloFetch, error as Any)
                DispatchQueue.main.async { complete(nil) }
                return
            
            case .success(let graphQLResult):
                var phaseGroups = [PhaseGroup]()
                if let nodes = graphQLResult.data?.phase?.phaseGroups?.nodes {
                    phaseGroups = nodes.map {
                        return PhaseGroup(id: Int($0?.id ?? "nil"),
                                          name: $0?.displayIdentifier,
                                          state: ActivityState.allCases[($0?.state ?? 5) - 1].rawValue)
                    }
                }
                DispatchQueue.main.async { complete(phaseGroups) }
            }
        }
    }
    
    static func getPhaseGroup(_ id: Int, complete: @escaping (_ phaseGroup: [String: Any?]?) -> Void) {
        ApolloService.shared.client.fetch(query: PhaseGroupQuery(id: "\(id)"),
                                          cachePolicy: .fetchIgnoringCacheCompletely,
                                          queue: .global(qos: .utility)) { (result) in
            switch result {
            case .failure(let error):
                debugPrint(k.Error.apolloFetch, error as Any)
                DispatchQueue.main.async { complete(nil) }
                return
            
            case .success(let graphQLResult):
                var progressionsOut = [Int]()
                if let nodes = graphQLResult.data?.phaseGroup?.progressionsOut {
                    progressionsOut = nodes.compactMap { $0?.originPlacement }
                }
                
                var standings = [Standing]()
                if let nodes = graphQLResult.data?.phaseGroup?.standings?.nodes {
                    standings = nodes.compactMap { EntrantService.getEntrantAndStanding3($0) }
                }
                
                var sets = [PhaseGroupSet]()
                if let nodes = graphQLResult.data?.phaseGroup?.sets?.nodes {
                    sets = nodes.compactMap {
                        guard let id = Int($0?.id ?? "nil") else { return nil }
                        var phaseGroupSet = PhaseGroupSet(id: id,
                                                          state: ActivityState.allCases[($0?.state ?? 5) - 1].rawValue,
                                                          roundNum: $0?.round ?? 0,
                                                          identifier: $0?.identifier ?? "",
                                                          fullRoundText: $0?.fullRoundText,
                                                          prevRoundIDs: $0?.slots?.compactMap {
                                                            guard let prevRoundID = $0?.prereqId else { return nil }
                                                            return Int(prevRoundID)
                                                          },
                                                          entrants: nil)
                        phaseGroupSet.entrants = EntrantService.getEntrantsForSet(displayScore: $0?.displayScore,
                                                                                  winnerID: $0?.winnerId,
                                                                                  slots: $0?.slots)
                        return phaseGroupSet
                    }
                }
                
                DispatchQueue.main.async {
                    complete(["bracketType": graphQLResult.data?.phaseGroup?.bracketType?.rawValue,
                              "progressionsOut": progressionsOut,
                              "standings": standings,
                              "sets": sets])
                }
            }
        }
    }
    
    static func getPhaseGroupSetGames(_ id: Int, complete: @escaping (_ games: [PhaseGroupSetGame]?) -> Void) {
        ApolloService.shared.client.fetch(query: PhaseGroupSetGamesQuery(id: "\(id)"),
                                          cachePolicy: .fetchIgnoringCacheCompletely,
                                          queue: .global(qos: .utility)) { (result) in
            switch result {
            case .failure(let error):
                debugPrint(k.Error.apolloFetch, error as Any)
                DispatchQueue.main.async { complete(nil) }
                return
            
            case .success(let graphQLResult):
                var games = [PhaseGroupSetGame]()
                if let nodes = graphQLResult.data?.set?.games {
                    games = nodes.map { PhaseGroupSetGame(winnerID: $0?.winnerId, stageName: $0?.stage?.name) }
                }
                DispatchQueue.main.async { complete(games) }
            }
        }
    }
    
    // MARK: - Remaining Standings & Sets
    
    static func getPhaseGroupStandings(_ id: Int, page: Int, complete: @escaping (_ standings: [Standing]?) -> Void) {
        ApolloService.shared.client.fetch(query: PhaseGroupStandingsPageQuery(id: "\(id)", page: page),
                                          cachePolicy: .fetchIgnoringCacheCompletely,
                                          queue: .global(qos: .utility)) { (result) in
            switch result {
            case .failure(let error):
                debugPrint(k.Error.apolloFetch, error as Any)
                DispatchQueue.main.async { complete(nil) }
                return
                
            case .success(let graphQLResult):
                var standings = [Standing]()
                if let nodes = graphQLResult.data?.phaseGroup?.standings?.nodes {
                    standings = nodes.compactMap { EntrantService.getEntrantAndStanding4($0) }
                }
                DispatchQueue.main.async { complete(standings) }
            }
        }
    }
    
    static func getPhaseGroupSets(_ id: Int, page: Int, complete: @escaping (_ sets: [PhaseGroupSet]?) -> Void) {
        ApolloService.shared.client.fetch(query: PhaseGroupSetsPageQuery(id: "\(id)", page: page),
                                          cachePolicy: .fetchIgnoringCacheCompletely,
                                          queue: .global(qos: .utility)) { (result) in
            switch result {
            case .failure(let error):
                debugPrint(k.Error.apolloFetch, error as Any)
                DispatchQueue.main.async { complete(nil) }
                return
            
            case .success(let graphQLResult):
                var sets = [PhaseGroupSet]()
                if let nodes = graphQLResult.data?.phaseGroup?.sets?.nodes {
                    sets = nodes.compactMap {
                        guard let id = Int($0?.id ?? "nil") else { return nil }
                        var phaseGroupSet = PhaseGroupSet(id: id,
                                                          state: ActivityState.allCases[($0?.state ?? 5) - 1].rawValue,
                                                          roundNum: $0?.round ?? 0,
                                                          identifier: $0?.identifier ?? "",
                                                          fullRoundText: $0?.fullRoundText,
                                                          prevRoundIDs: $0?.slots?.compactMap({ (slot) -> Int? in
                                                            guard let prevRoundID = slot?.prereqId else { return nil }
                                                            return Int(prevRoundID)
                                                          }),
                                                          entrants: nil)
                        phaseGroupSet.entrants = EntrantService.getEntrantsForSet2(displayScore: $0?.displayScore,
                                                                                   winnerID: $0?.winnerId,
                                                                                   slots: $0?.slots)
                        return phaseGroupSet
                    }
                }
                DispatchQueue.main.async { complete(sets) }
            }
        }
    }
    
    // MARK: - Tournaments by TO
    
    static func getTournamentsByTO(id: Int, page: Int, perPage: Int, complete: @escaping (_ tournaments: [Tournament]?) -> Void) {
        ApolloService.shared.client.fetch(query: UserTournamentsQuery(id: "\(id)", page: page, perPage: perPage),
                                          cachePolicy: .fetchIgnoringCacheCompletely, queue: .global(qos: .utility)) { result in
            switch result {
            case .failure(let error):
                debugPrint(k.Error.apolloFetch, error as Any)
                DispatchQueue.main.async { complete(nil) }
                return
                
            case .success(let graphQLResult):
                var tournaments = [Tournament]()
                if let nodes = graphQLResult.data?.user?.tournaments?.nodes {
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
