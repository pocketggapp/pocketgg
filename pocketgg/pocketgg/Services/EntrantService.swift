import StartggAPI

final class EntrantService {
  static func getEventWinner(_ event: TournamentDetailsQuery.Data.Tournament.Event?) -> Entrant? {
    guard let event else { return nil }
    
    if let participants = event.standings?.nodes?[safe: 0]??.entrant?.participants, participants.count == 1 {
      let teamName = getTeamName(
        combined: event.standings?.nodes?[safe: 0]??.entrant?.name,
        entrantName: participants[0]?.gamerTag
      )
      return Entrant(
        id: nil,
        name: participants[0]?.gamerTag,
        teamName: teamName
      )
    }
    
    return Entrant(
      id: nil,
      name: event.standings?.nodes?[safe: 0]??.entrant?.name,
      teamName: nil
    )
  }
  
  static func getEntrantAndStanding(_ standing: EventDetailsQuery.Data.Event.Standings.Node?) -> Standing? {
      guard let standing else { return nil }
      
      if let participants = standing.entrant?.participants, participants.count == 1 {
        let entrantName = standing.entrant?.participants?[0]?.gamerTag
        let teamName = getTeamName(combined: standing.entrant?.name, entrantName: entrantName)
        let entrant = Entrant(id: nil, name: entrantName, teamName: teamName)
        return Standing(entrant: entrant, placement: standing.placement)
      }
      
      return Standing(
        entrant: Entrant(
          id: nil,
          name: standing.entrant?.name,
          teamName: nil
        ),
        placement: standing.placement
      )
    }
  
  // MARK: Private Helpers
    
    private static func getTeamName(combined: String?, entrantName: String?) -> String? {
      guard let combined , let entrantName else { return nil }

      // entrantName is the name of the entrant (e.g. Mang0)
      // If the entrant doesn't have a team, then combined will be the same as gamerTag
      // If they do have a team, then combined will be the team name + " | " + gamerTag (e.g. C9 | Mang0)
      // So check if combined includes " | ", and if it does, then extract the team name
      if let range = combined.range(of: " | " + entrantName) {
        return String(combined[..<range.lowerBound])
      }
      return nil
    }
}
