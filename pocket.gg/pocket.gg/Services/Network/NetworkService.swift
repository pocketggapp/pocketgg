//
//  NetworkService.swift
//  pocket.gg
//
//  Created by Gabriel Siu on 2020-02-02.
//  Copyright © 2020 Gabriel Siu. All rights reserved.
//

import Foundation

final class NetworkService {
    static func isAuthTokenValid(complete: @escaping (_ valid: Bool) -> Void) {
        ApolloService.shared.client.fetch(query: AuthTokenTestQuery(), cachePolicy: .fetchIgnoringCacheCompletely, queue: .global(qos: .utility)) { result in
            DispatchQueue.main.async {
                switch result {
                case .failure: complete(false)
                case .success: complete(true)
                }
            }
        }
    }
}
