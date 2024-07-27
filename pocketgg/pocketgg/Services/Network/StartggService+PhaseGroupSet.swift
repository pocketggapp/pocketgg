import StartggAPI

extension StartggService {
  func getPhaseGroupSetDetails(id: Int) async throws -> PhaseGroupSetDetails? {
    return try await withCheckedThrowingContinuation { continuation in
      apollo.fetch(
        query: PhaseGroupSetDetailsQuery(id: "\(id)"),
        cachePolicy: .fetchIgnoringCacheCompletely,
        queue: .global(qos: .userInitiated)
      ) { result in
        switch result {
        case .success(let graphQLResult):
          guard let setData = graphQLResult.data?.set else {
            continuation.resume(returning: nil)
            return
          }
          
          // TODO: See if it's possible to get the score without using displayScore;
          // When a set is active and the score is updated, displayScore is still null
          let entrants = EntrantService.getEntrantsForSet3(
            displayScore: setData.displayScore,
            winnerID: setData.winnerId,
            slots: setData.slots
          )
          let outcome = PhaseGroupSetService.getSetOutcome(
            score0: entrants?[safe: 0]?.score,
            score1: entrants?[safe: 1]?.score
          )
          let phaseGroupSet = PhaseGroupSet(
            id: id,
            state: ActivityState.allCases[(setData.state ?? 5) - 1].rawValue.localizedCapitalized,
            roundNum: setData.round ?? 0,
            identifier: setData.identifier ?? "",
            outcome: outcome,
            fullRoundText: setData.fullRoundText,
            prevRoundIDs: setData.slots?.compactMap {
              guard let prevRoundID = $0?.prereqId else { return nil }
              return Int(prevRoundID)
            } ?? [],
            entrants: entrants
          )
          
          let games: [PhaseGroupSetGame] = setData.games?.compactMap {
            guard let id = Int($0?.id ?? "nil") else { return nil }
            return PhaseGroupSetGame(
              id: id,
              gameNum: $0?.orderNum,
              winnerID: $0?.winnerId,
              stageName: $0?.stage?.name
            )
          } ?? []
          
          let stationNum: Int? = setData.station?.number
          
          var stream: Stream?
          if let phaseGroupSetStream = setData.stream {
            stream = Stream(
              name: phaseGroupSetStream.streamName,
              logoUrl: phaseGroupSetStream.streamLogo,
              source: phaseGroupSetStream.streamSource?.rawValue,
              streamID: phaseGroupSetStream.streamId
            )
          }
          
          continuation.resume(returning: PhaseGroupSetDetails(
            phaseGroupSet: phaseGroupSet,
            games: games,
            stationNum: stationNum,
            stream: stream)
          )
        case .failure(let error):
          continuation.resume(throwing: error)
        }
      }
    }
  }
}
