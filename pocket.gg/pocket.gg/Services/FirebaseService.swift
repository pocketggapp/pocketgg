//
//  FirebaseService.swift
//  pocket.gg
//
//  Created by Gabriel Siu on 2021-07-09.
//  Copyright © 2021 Gabriel Siu. All rights reserved.
//

import FirebaseCrashlytics

class FirebaseService {
    static var reportedPhaseGroupIDs = Set<Int>()
    
    static func reportPhaseGroup(_ id: Int?) {
        guard let id = id else { return }
        guard !reportedPhaseGroupIDs.contains(id) else { return }
        reportedPhaseGroupIDs.insert(id)
        Crashlytics.crashlytics().record(error: NSError(domain: "bracketLayoutError", code: -1001, userInfo: ["phaseGroupID": id]))
    }
}
