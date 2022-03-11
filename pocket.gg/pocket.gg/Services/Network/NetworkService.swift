//
//  NetworkService.swift
//  pocket.gg
//
//  Created by Gabriel Siu on 2020-02-02.
//  Copyright © 2020 Gabriel Siu. All rights reserved.
//

import Foundation

final class NetworkService {
    static func getCurrentUserID(complete: @escaping (_ userID: Int?) -> Void) {
        ApolloService.shared.client.fetch(query: CurrentUserIdQuery(), cachePolicy: .fetchIgnoringCacheCompletely, queue: .global(qos: .utility)) { result in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    debugPrint(k.Error.apolloFetch, error as Any)
                    DispatchQueue.main.async { complete(nil) }
                    return
                case .success(let graphQLResult):
                    guard let userID = graphQLResult.data?.currentUser?.id else {
                        DispatchQueue.main.async { complete(nil) }
                        return
                    }
                    complete(Int(userID))
                }
            }
        }
    }
}
