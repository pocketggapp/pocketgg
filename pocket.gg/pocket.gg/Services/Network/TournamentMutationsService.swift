//
//  TournamentMutationsService.swift
//  pocket.gg
//
//  Created by Gabriel Siu on 2021-08-31.
//  Copyright © 2021 Gabriel Siu. All rights reserved.
//

import Foundation

struct NewPhase {
    let name: String
    let numPhaseGroups: Int
    let bracketType: BracketType
}

final class TournamentMutationsService {
    
    // MARK: - Phase
    
    static func getEvents(_ tournamentID: Int, complete: @escaping (_ events: [AdminEvent]?, _ error: Error?) -> Void) {
        ApolloService.shared.client.fetch(query: TournamentEventsQuery(id: "\(tournamentID)"), cachePolicy: .fetchIgnoringCacheCompletely,
                                          queue: .global(qos: .utility)) { (result) in
            switch result {
            case .failure(let error):
                debugPrint(k.Error.apolloFetch, error as Any)
                DispatchQueue.main.async { complete(nil, error) }
                return
                
            case .success(let graphQLResult):
                guard let tournamentEvents = graphQLResult.data?.tournament?.events else {
                    DispatchQueue.main.async { complete(nil, nil) }
                    return
                }
                
                var events = [AdminEvent]()
                events = tournamentEvents.map {
                    AdminEvent(id: Int($0?.id ?? "nil"),
                               name: $0?.name,
                               state: $0?.state?.rawValue,
                               videogameName: $0?.videogame?.name,
                               videogameImage: $0?.videogame?.images?.compactMap { return ($0?.url, $0?.ratio) }.first)
                }
                
                DispatchQueue.main.async { complete(events, nil) }
            }
        }
    }
    
    static func getPhases(_ eventID: Int, complete: @escaping (_ phases: [AdminPhase]?, _ error: Error?) -> Void) {
        ApolloService.shared.client.fetch(query: EventPhasesQuery(id: "\(eventID)"), cachePolicy: .fetchIgnoringCacheCompletely,
                                          queue: .global(qos: .utility)) { (result) in
            switch result {
            case .failure(let error):
                debugPrint(k.Error.apolloFetch, error as Any)
                DispatchQueue.main.async { complete(nil, error) }
                return
                
            case .success(let graphQLResult):
                guard let eventPhases = graphQLResult.data?.event?.phases else {
                    DispatchQueue.main.async { complete(nil, nil) }
                    return
                }
                
                var phases = [AdminPhase]()
                phases = eventPhases.map {
                    AdminPhase(id: Int($0?.id ?? "nil"), name: $0?.name, bracketType: $0?.bracketType?.rawValue, numGroups: $0?.groupCount)
                }
                
                DispatchQueue.main.async { complete(phases, nil) }
            }
        }
    }
    
    static func createPhase(eventID: Int?, newPhase: NewPhase, complete: @escaping (_ newPhaseID: Int?, _ error: Error?) -> Void) {
        // TODO: MAKE ALL NETWORK CALLS ALSO TAKE ID AS OPTIONAL
        guard let eventID = eventID else {
            complete(nil, nil)
            return
        }
        
        let payload = PhaseUpsertInput(name: newPhase.name, groupCount: newPhase.numPhaseGroups, bracketType: newPhase.bracketType)
        ApolloService.shared.client.perform(mutation: CreatePhaseMutation(eventID: "\(eventID)", payload: payload),
                                            queue: .global(qos: .utility)) { result in
            switch result {
            case .failure(let error):
                debugPrint(k.Error.apolloFetch, error as Any)
                DispatchQueue.main.async { complete(nil, error) }
                return
                
            case .success(let graphQLResult):
                guard let id = Int(graphQLResult.data?.upsertPhase?.id ?? "nil") else {
                    DispatchQueue.main.async { complete(nil, nil) }
                    return
                }
                
                DispatchQueue.main.async { complete(id, nil) }
            }
        }
    }
    
    static func updatePhase(phaseID: Int, newPhase: NewPhase, complete: @escaping (_ success: Bool, _ error: Error?) -> Void) {
        let payload = PhaseUpsertInput(name: newPhase.name, groupCount: newPhase.numPhaseGroups, bracketType: newPhase.bracketType)
        ApolloService.shared.client.perform(mutation: UpdatePhaseMutation(phaseID: "\(phaseID)", payload: payload),
                                            queue: .global(qos: .utility)) { result in
            switch result {
            case .failure(let error):
                debugPrint(k.Error.apolloFetch, error as Any)
                DispatchQueue.main.async { complete(false, error) }
                return
                
            case .success(let graphQLResult):
                guard let result = graphQLResult.data?.upsertPhase?.id else {
                    DispatchQueue.main.async { complete(false, nil) }
                    return
                }
                
                DispatchQueue.main.async { complete(true, nil) }
            }
        }
    }
    
    static func deletePhase(_ phaseID: Int, complete: @escaping (_ success: Bool, _ error: Error?) -> Void) {
        ApolloService.shared.client.perform(mutation: DeletePhaseMutation(phaseID: "\(phaseID)"),
                                            queue: .global(qos: .utility)) { result in
            switch result {
            case .failure(let error):
                debugPrint(k.Error.apolloFetch, error as Any)
                DispatchQueue.main.async { complete(false, error) }
                return
                
            case .success(let graphQLResult):
                guard let result = graphQLResult.data?.deletePhase else {
                    DispatchQueue.main.async { complete(false, nil) }
                    return
                }
                
                DispatchQueue.main.async { complete(result, nil) }
            }
        }
    }
    
    static func swapPhaseSeeds(phaseID: Int, seed1ID: Int, seed2ID: Int, complete: @escaping (_ success: Bool, _ error: Error?) -> Void) {
        ApolloService.shared.client.perform(mutation: SwapSeedsMutation(phaseID: "\(phaseID)", seed1ID: "\(seed1ID)", seed2ID: "\(seed2ID)"),
                                            queue: .global(qos: .utility)) { result in
            switch result {
            case .failure(let error):
                debugPrint(k.Error.apolloFetch, error as Any)
                DispatchQueue.main.async { complete(false, error) }
                return
                
            case .success(let graphQLResult):
                guard let result = graphQLResult.data?.swapSeeds else {
                    DispatchQueue.main.async { complete(false, nil) }
                    return
                }
                
                DispatchQueue.main.async { complete(true, nil) }
            }
        }
    }
    
    // MARK: - Unused
    
    static func deleteStation(_ stationID: Int, complete: @escaping (_ success: Bool, _ error: Error?) -> Void) {
        ApolloService.shared.client.perform(mutation: DeleteStationMutation(stationID: "\(stationID)"),
                                            queue: .global(qos: .utility)) { result in
            switch result {
            case .failure(let error):
                debugPrint(k.Error.apolloFetch, error as Any)
                DispatchQueue.main.async { complete(false, error) }
                return
                
            case .success(let graphQLResult):
                guard let result = graphQLResult.data?.deleteStation else {
                    DispatchQueue.main.async { complete(false, nil) }
                    return
                }
                
                DispatchQueue.main.async { complete(result, nil) }
            }
        }
    }
}
