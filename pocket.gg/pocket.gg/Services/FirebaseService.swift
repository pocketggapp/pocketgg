//
//  FirebaseService.swift
//  pocket.gg
//
//  Created by Gabriel Siu on 2021-07-09.
//  Copyright © 2021 Gabriel Siu. All rights reserved.
//

import FirebaseCrashlytics

struct TournamentIDs {
    var tournamentID: Int?
    var eventID: Int?
    var phaseID: Int?
    var phaseGroupID: Int?
    var singularPhaseGroupID: Int?
}

class FirebaseService {
    static var reportedPhaseGroupIDs = Set<Int>()
    
    static func reportPhaseGroup(_ IDs: TournamentIDs) {
        let id = IDs.phaseID == nil ? IDs.singularPhaseGroupID : IDs.phaseGroupID
        guard let id = id, !reportedPhaseGroupIDs.contains(id) else { return }
        reportedPhaseGroupIDs.insert(id)
        let userInfo = ["tournamentID": IDs.tournamentID ?? -1,
                        "eventID": IDs.eventID ?? -1,
                        "phaseID": IDs.phaseID ?? -1,
                        "phaseGroupID": IDs.phaseGroupID ?? -1,
                        "singularPhaseGroupID": IDs.singularPhaseGroupID ?? -1]
        Crashlytics.crashlytics().record(error: NSError(domain: "bracketLayoutError", code: -1001, userInfo: userInfo))
    }
}
