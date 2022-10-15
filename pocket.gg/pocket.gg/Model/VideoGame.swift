//
//  VideoGame.swift
//  pocket.gg
//
//  Created by Gabriel Siu on 2020-02-26.
//  Copyright © 2020 Gabriel Siu. All rights reserved.
//

import GRDB

struct VideoGame: Hashable, Codable, FetchableRecord, MutablePersistableRecord {
  let id: Int
  let name: String
}
