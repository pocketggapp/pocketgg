//
//  VideoGameDatabase.swift
//  pocket.gg
//
//  Created by Gabriel Siu on 2020-03-28.
//  Copyright © 2020 Gabriel Siu. All rights reserved.
//

import GRDB

enum VideoGameDatabaseError: Error {
  case appSupportDirURL
  case dbNotInAppBundle
  case dbNotInitialized
}

struct VideoGameDatabase {
  static func openDatabase(atPath path: String) throws -> DatabaseQueue {
    return try DatabaseQueue(path: path)
  }
  
  static func getVideoGames() throws -> [VideoGame] {
    guard let dbQueue = dbQueue else { throw VideoGameDatabaseError.dbNotInitialized }
    let videoGames: [VideoGame] = try dbQueue.read { db in
      try VideoGame.fetchAll(db)
    }
    return videoGames
  }
  
  static func getVideoGamesForSearch(_ search: String) throws -> [VideoGame] {
    guard let dbQueue = dbQueue else { throw VideoGameDatabaseError.dbNotInitialized }
    let videoGames: [VideoGame] = try dbQueue.read { db in
      try VideoGame.fetchAll(db, sql: "SELECT * FROM videoGame WHERE name LIKE '%\(search)%'")
    }
    return videoGames
  }
}
