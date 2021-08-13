//
//  Constants.swift
//  pocket.gg
//
//  Created by Gabriel Siu on 2020-01-31.
//  Copyright © 2020 Gabriel Siu. All rights reserved.
//

import UIKit

struct Constants {
    
    // MARK: - URLs
    
    struct API {
        static let endpoint = "https://api.smash.gg/gql/alpha"
        static let streams = [
            "TWITCH": "twitch.tv",
            "HITBOX": "smashcast.tv",
            "STREAMME": "stream.me",
            "MIXER": "mixer.com"
        ]
    }
    
    struct URL {
        static let smashggAPI = "https://developer.smash.gg/docs/intro"
        static let apolloiOS = "https://www.apollographql.com/docs/ios/"
        static let grdb = "https://github.com/groue/GRDB.swift"
        static let firebase = "https://github.com/firebase/firebase-ios-sdk"
        static let twitch = "https://www.twitch.tv/"
        
        static let appStore = "https://apps.apple.com/app/id1576064097"
        static let twitter = "https://twitter.com/gabrielsiu_dev"
        static let privacyPolicy = "https://gabrielsiu.com/pocketgg"
    }
    
    // MARK: - UI/Structure Constants
    
    struct Identifiers {
        static let tournamentsRowCell = "tournamentsRowCell"
        static let tournamentCell = "tournamentCell"
        static let tournamentListCell = "tournamentListCell"
        static let tournamentSetCell = "tournamentSetCell"
        static let tournamentSetGameCell = "tournamentSetGameCell"
        static let videoGameCell = "videoGameCell"
        static let tournamentOrganizerCell = "tournamentOrganizerCell"
        static let eventCell = "eventCell"
        static let streamCell = "streamCell"
        static let value1Cell = "value1Cell"
        static let eventStandingCell = "eventStandingCell"
        static let roundRobinSetCell = "roundRobinSetCell"
    }
    
    struct Sizes {
        static let tournamentCellWidth: CGFloat = 125
        static let tournamentCellHeight: CGFloat = 225
        
        static let tournamentListCellHeight: CGFloat = 75
        
        static let logoSize: CGFloat = 100
        static let margin: CGFloat = 16
        static let mapHeight: CGFloat = 300
        
        static let eventImageRatio: CGFloat = 0.75
        
        static let cornerRadius: CGFloat = 5
        
        static let largeFont: CGFloat = UIFont.systemFontSize + 4.0
        
        static let bracketMargin: CGFloat = 50
        static let setWidth: CGFloat = 200
        static let setHeight: CGFloat = 50
        static let xSetSpacing: CGFloat = 50
        static let ySetSpacing: CGFloat = 50
        
        static let roundRobinSetWidth: CGFloat = 100
        static let roundRobinSetHeight: CGFloat = 50
        static let roundRobinSetMargin: CGFloat = 5
    }
    
    // MARK: - User Defaults
    
    struct UserDefaults {
        static let returningUser = "returningUser"
        static let returningUserTitle = "Welcome to pocket.gg!"
        static let returningUserMessage = "To get started, go to Settings → Video Game Selection and select your favourite video games"
        
        static let authToken = "authToken"
        static let authTokenDate = "authTokenDate"
        static let firebaseEnabled = "firebaseEnabled"
        
        static let mainVCSections = "mainVCSections"
        static let pinnedTournaments = "pinnedTournaments"
        static let showPinnedTournaments = "showPinnedTournaments"
        static let featuredTournaments = "featuredTournaments"
        static let upcomingTournaments = "upcomingTournaments"
        static let preferredVideoGames = "preferredVideoGames"
        
        static let tournamentOrganizersFollowed = "tournamentOrganizersFollowed"
        
        static let onlySearchFeatured = "onlySearchFeatured"
        static let showOlderTournamentsFirst = "showOlderTournamentsFirst"
        static let searchUsingEnabledGames = "searchUsingEnabledGames"
        static let recentSearches = "recentSearches"
        
        static let useSpecificCountry = "useSpecificCountry"
        static let useSpecificState = "useSpecificState"
        static let selectedCountry = "selectedCountry"
        static let selectedState = "selectedState"
        static let alternateAppIconUsed = "alternateAppIconUsed"
    }
    
    // MARK: - Notification Center
    
    struct Notification {
        static let tournamentPinToggled = "tournamentPinToggled"
        static let followedTournamentOrganizer = "followedTournamentOrganizer"
        static let settingsChanged = "settingsChanged"
        static let didTapSet = "didTapSet"
    }
    
    // MARK: - Alerts
    
    struct Alert {
        static let videoGameSelection = """
        Unfortunately, due to limitations with the smash.gg API, it is currently not possible to obtain a consistently \
        updated list of video games registered on smash.gg. Thus, if newer video games are released, they may not appear in pocket.gg as \
        search results. If you can't find the video game that you're looking for, use the button below to send a video game update request, and \
        it may be added in a future update.
        """
        static let searchResults = """
        Unfortunately, the search function provided by the smash.gg API treats each individual word in the search term as a separate search term. \
        For example, if you search for "On The Grind", the smash.gg API will return all tournaments whose names contain "On", "The", or "Grind". \
        To mitigate this, try using fewer, more unique terms when searching.
        """
    }
    
    // MARK: - Errors
    
    struct Error {
        static let title = "Error"
        static let invalidAuthToken = "Invalid auth token"
        static let apolloFetch = "Error fetching GraphQL query: "
        static let pinnedTournamentLimit = "You can only have up to 30 pinned tournaments"
    }
    
    // MARK: - Messages
    
    struct Message {
        // MARK: MainVC
        static let errorLoadingTournaments = "Unable to load tournaments"
        static let noTournaments = "No tournaments found for this category"
        static let noPinnedTournaments = "You don't have any pinned tournaments"
        static let noPreferredGames = "You haven't enabled any video games. Select your favorite video games to see tournaments that feature those games."
        
        // MARK: TournamentVC
        static let errorLoadingEvents = "Unable to load events"
        static let noEvents = "No events found"
        static let errorLoadingStreams = "Unable to load streams"
        static let noStreams = "No streams found"
        static let errorLoadingLocation = "Unable to load location"
        static let noLocation = "No location found"
        static let errorLoadingContactInfo = "Unable to load contact info"
        static let noContactInfo = "No contact info found"
        static let errorLoadingRegistrationInfo = "Unable to load registration info"
        
        // MARK: EventVC
        static let errorLoadingBrackets = "Unable to load brackets"
        static let noBrackets = "No brackets found"
        static let errorLoadingStandings = "Unable to load standings"
        static let noStandings = "No standings found"
        
        // MARK: PhaseGroupListVC
        static let errorLoadingPhaseGroups = "Unable to load pools"
        static let noPhaseGroups = "No pools found"
        
        // MARK: PhaseGroupVC
        static let errorLoadingPhaseGroupStandings = "Unable to load standings"
        static let noPhaseGroupStandings = "No standings found"
        static let errorLoadingSets = "Unable to load matches"
        static let noSets = "No matches found"
        
        // MARK: SetVC
        static let errorLoadingGames = "Unable to load games"
        static let noGames = "No games reported"
        
        // MARK: ProfileVC
        static let errorLoadingProfile = "Unable to load profile"
        static let noProfileTournaments = "No tournaments found"
    }
}

typealias k = Constants
