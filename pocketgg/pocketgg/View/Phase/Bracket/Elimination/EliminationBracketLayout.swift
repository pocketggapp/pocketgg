import SwiftUI

struct EliminationBracketLayout: Layout {
  func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
    guard !subviews.isEmpty else { return .zero }
    
    var upperBracketSubviews = [LayoutSubviews.Element]()
    var lowerBracketSubviews = [LayoutSubviews.Element]()
    var otherBracketSubviews = [LayoutSubviews.Element]()
    
    var setViewSize: CGSize = .zero
    var roundLabelHeight: CGFloat = .zero
    
    for subview in subviews {
      if let roundNum = subview[PhaseGroupSetValue.self]?.roundNum {
        if roundNum > 0 {
          upperBracketSubviews.append(subview)
        } else if roundNum < 0 {
          lowerBracketSubviews.append(subview)
        } else {
          otherBracketSubviews.append(subview)
        }
        setViewSize = subview.sizeThatFits(.unspecified)
      }
      else if subview[PhaseGroupRoundLabel.self] != nil {
        roundLabelHeight = subview.sizeThatFits(.unspecified).height
      }
    }
    
    // Height
    let upperBracketMostSets = getDistribution(for: upperBracketSubviews.compactMap { $0[PhaseGroupSetValue.self] }).max() ?? 0
    let lowerBracketMostSets = getDistribution(for: lowerBracketSubviews.compactMap { $0[PhaseGroupSetValue.self] }).max() ?? 0
    let otherBracketMostSets = getDistribution(for: otherBracketSubviews.compactMap { $0[PhaseGroupSetValue.self] }).max() ?? 0
    
    let upperBracketHeight = upperBracketMostSets == 0 ? 0 : CGFloat((upperBracketMostSets * 2) - 1) * setViewSize.height
    let lowerBracketHeight = lowerBracketMostSets == 0 ? 0 : CGFloat((lowerBracketMostSets * 2) - 1) * setViewSize.height
    let otherBracketHeight = otherBracketMostSets == 0 ? 0 : CGFloat((otherBracketMostSets * 2) - 1) * setViewSize.height
    
    let setViewHeights = upperBracketHeight + lowerBracketHeight + otherBracketHeight
    
    let numBracketSections = (upperBracketSubviews.isEmpty ? 0 : 1) +
                             (lowerBracketSubviews.isEmpty ? 0 : 1) +
                             (otherBracketSubviews.isEmpty ? 0 : 1)
    
    let labelHeights: CGFloat = (upperBracketSubviews.isEmpty ? .zero : roundLabelHeight) +
                                (lowerBracketSubviews.isEmpty ? .zero : roundLabelHeight) +
                                (otherBracketSubviews.isEmpty ? .zero : roundLabelHeight)
    
    let bracketSectionSeparatorsHeight = CGFloat(numBracketSections - 1) * setViewSize.height
    
    let height = labelHeights + setViewHeights + bracketSectionSeparatorsHeight + 2 * EliminationBracketLayout.bracketMargin
    
    // Width
    let highestNumRounds = getHighestNumRounds(for: subviews.compactMap { $0[PhaseGroupSetValue.self] })
    let width = CGFloat(highestNumRounds) * setViewSize.width +
                CGFloat(highestNumRounds - 1) * setViewSize.height +
                2 * EliminationBracketLayout.bracketMargin
    
    return CGSize(width: width, height: height)
  }
  
  func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
    guard !subviews.isEmpty else { return }
    
    var upperBracketSubviews = [LayoutSubviews.Element]()
    var lowerBracketSubviews = [LayoutSubviews.Element]()
    var otherBracketSubviews = [LayoutSubviews.Element]()
    
    var upperBracketRoundLabels = [LayoutSubviews.Element]()
    var lowerBracketRoundLabels = [LayoutSubviews.Element]()
    var otherBracketRoundLabels = [LayoutSubviews.Element]()
    
    var setPathViews = [LayoutSubviews.Element]()
    
    for subview in subviews {
      if let roundNum = subview[PhaseGroupSetValue.self]?.roundNum {
        if roundNum > 0 {
          upperBracketSubviews.append(subview)
        } else if roundNum < 0 {
          lowerBracketSubviews.append(subview)
        } else {
          otherBracketSubviews.append(subview)
        }
      }
      else if let roundNum = subview[PhaseGroupRoundLabel.self]?.id {
        if roundNum > 0 {
          upperBracketRoundLabels.append(subview)
        } else if roundNum < 0 {
          lowerBracketRoundLabels.append(subview)
        } else {
          otherBracketRoundLabels.append(subview)
        }
      }
      else {
        setPathViews.append(subview)
      }
    }
    
    let xPosition = bounds.minX + EliminationBracketLayout.bracketMargin
    var yPosition = bounds.minY + EliminationBracketLayout.bracketMargin
    yPosition = layoutSets(
      xOrigin: xPosition,
      yOrigin: yPosition,
      setViews: upperBracketSubviews,
      roundLabels: upperBracketRoundLabels,
      pathViews: setPathViews
    )
    yPosition = layoutSets(
      xOrigin: xPosition,
      yOrigin: yPosition,
      setViews: lowerBracketSubviews,
      roundLabels: lowerBracketRoundLabels,
      pathViews: setPathViews
    )
    _ = layoutSets(
      xOrigin: xPosition,
      yOrigin: yPosition,
      setViews: otherBracketSubviews,
      roundLabels: otherBracketRoundLabels,
      pathViews: setPathViews
    )
  }
}

private extension EliminationBracketLayout {
  struct SetInfo {
    let yPosition: CGFloat
    let id: Int
    let prevRoundIDs: [Int]
  }
  
  static let bracketMargin: CGFloat = 50
  
  func layoutSets(
    xOrigin: CGFloat,
    yOrigin: CGFloat,
    setViews: [LayoutSubviews.Element],
    roundLabels: [LayoutSubviews.Element],
    pathViews: [LayoutSubviews.Element]
  ) -> CGFloat {
    guard !setViews.isEmpty else { return yOrigin }
    
    /// The x position of where the the SetView is going to be added in the BracketView
    var xPosition = xOrigin
    /// The y position of where the the SetView is going to be added in the BracketView
    var yPosition = yOrigin
    /// The round number of the previous set that was computed. Used for detecting if the current set belongs to a new round
    var prevRoundNum: Int?
    
    /// An array describing how many sets belong to each round
    let setDistribution = getDistribution(for: setViews.compactMap { $0[PhaseGroupSetValue.self] })
    
    /// The most number of sets per round out of all the rounds
    guard let max = setDistribution.max() else { return yOrigin }
    /// The roundIndex corresponding to the round with the most number of sets
    guard let maxIndex = setDistribution.firstIndex(of: max) else { return yOrigin }
    /// A bool value describing whether or not the first round has the most number of sets compared to the other rounds
    let firstRoundHasMostSets = max == setDistribution[0]
    /// The y positions and prerequisite IDs of the sets in the round with the most number of sets. Only used when firstRoundHasMostSets is false
    var mostNumSetsRoundInfo = [SetInfo]()
    /// An array that will contain all of the sets before the round with the most number of sets. Only used when firstRoundHasMostSets is false
    var leftoverSets = [LayoutSubviews.Element]()
    
    /// Represents which round a particular set belongs to (Eg. If roundIndex == 0, the set belongs to the leftmost round)
    var roundIndex = 0
    /// The y positions and IDs of all of the sets from the previous round
    var prevRoundInfo = [SetInfo]()
    /// The y positions and IDs of the sets in the current round. Only used when the current round has a different number of sets than the previous round
    var currRoundInfo = [SetInfo]()
    
    /// The yOrigin value for the next bracket section (eg. lower bracket). Updated whenever a SetView is placed
    var nextBracketYPosition: CGFloat = yOrigin
    
    // Iterate through all of the sets
    // If !firstRoundHasMostSets, ignore the sets before the round with the most number of sets
    for setView in setViews {
      guard let set = setView[PhaseGroupSetValue.self] else { continue }
      guard let roundLabel = roundLabels.first(where: { $0[PhaseGroupRoundLabel.self]?.id == set.roundNum }) else { continue }
      
      let setSize = setView.sizeThatFits(.unspecified)
      let roundLabelSize = roundLabel.sizeThatFits(.unspecified)
      let xSetSpacing = setSize.height
      
      // Preparation for if we reach a new round of sets
      if let prevRoundNum = prevRoundNum,
         set.roundNum != prevRoundNum {
        xPosition += setSize.width + xSetSpacing
        roundIndex += 1
      }
      
      // Upon reaching the round with the most number of sets and if !firstRoundHasMostSets, clear all info about the previous sets
      if !firstRoundHasMostSets, roundIndex == maxIndex,
         set.roundNum != prevRoundNum {
        prevRoundNum = nil
        prevRoundInfo.removeAll()
      }
      
      // First Set
      if prevRoundNum == nil {
        roundLabel.place(
          at: CGPoint(x: xPosition + (setSize.width - roundLabelSize.width) / 2, y: yOrigin),
          proposal: .init(roundLabelSize)
        )
        yPosition = yOrigin + roundLabelSize.height
        prevRoundInfo.append(SetInfo(yPosition: yPosition, id: set.id, prevRoundIDs: set.prevRoundIDs))
        
        // Next Round of Sets
      } else if prevRoundNum != set.roundNum {
        if !firstRoundHasMostSets, mostNumSetsRoundInfo.isEmpty {
          mostNumSetsRoundInfo = prevRoundInfo
        } else if !currRoundInfo.isEmpty {
          prevRoundInfo = currRoundInfo
          currRoundInfo.removeAll()
        }
        
        roundLabel.place(
          at: CGPoint(x: xPosition + (setSize.width - roundLabelSize.width) / 2, y: yOrigin),
          proposal: .init(roundLabelSize)
        )
        
        // Consecutive sets in the round with the most number of sets
      } else if (firstRoundHasMostSets && roundIndex == 0) || (!firstRoundHasMostSets && roundIndex == maxIndex) {
        yPosition += (2 * setSize.height)
        prevRoundInfo.append(SetInfo(yPosition: yPosition, id: set.id, prevRoundIDs: set.prevRoundIDs))
      }
      
      // Determine how to layout the sets for sets past the first round
      if (firstRoundHasMostSets && roundIndex > 0) || (!firstRoundHasMostSets && roundIndex > maxIndex) {
        // TODO: Fix the below line from crashing when a bracket has 1 or more "bye" rounds that don't have an identifier
        // ie. https://www.start.gg/tournament/the-big-house-6/event/melee-singles/brackets/76015/241623
        
        // If the current round has a different number of sets than the previous round
        if setDistribution[roundIndex] != setDistribution[roundIndex - 1] {
          // Get the y positions of the prerequisite sets for the current set
          let prevYPositions = prevRoundInfo.filter { set.prevRoundIDs.contains($0.id) }.map { $0.yPosition }
          
          // Calculate the y position for the current set based on those of the prerequisite set(s)
          switch prevYPositions.count {
          case 1:
            yPosition = prevYPositions[0]
            let pathView = pathViews.first { $0[PhaseGroupSetPathID.self] == set.id }
            pathView?.place(
              at: .init(x: xPosition - xSetSpacing, y: prevYPositions[0]),
              proposal: .init(width: xSetSpacing, height: setSize.height)
            )
          case 2:
            yPosition = floor((prevYPositions[0] + prevYPositions[1]) / 2)
            let pathView = pathViews.first { $0[PhaseGroupSetPathID.self] == set.id }
            pathView?.place(
              at: .init(x: xPosition - xSetSpacing, y: min(prevYPositions[0], prevYPositions[1])),
              proposal: .init(width: xSetSpacing, height: abs(prevYPositions[0] - prevYPositions[1]) + setSize.height)
            )
          default:
            #if DEBUG
            print("Bracket Layout Error: Set has invalid number of prerequisite set y positions")
            #endif
            continue
          }
          currRoundInfo.append(SetInfo(yPosition: yPosition, id: set.id, prevRoundIDs: set.prevRoundIDs))
          
          // If the current round has the same number of sets as the previous round
        } else {
          yPosition = prevRoundInfo.removeFirst().yPosition
          prevRoundInfo.append(SetInfo(yPosition: yPosition, id: set.id, prevRoundIDs: set.prevRoundIDs))
          let pathView = pathViews.first { $0[PhaseGroupSetPathID.self] == set.id }
          pathView?.place(
            at: .init(x: xPosition - xSetSpacing, y: yPosition),
            proposal: .init(width: xSetSpacing, height: setSize.height)
          )
        }
      }
      // Lay out the pathViews for the sets in the first round (or second round if the first round has fewer sets)
      else {
        let pathView = pathViews.first { $0[PhaseGroupSetPathID.self] == set.id }
        pathView?.place(
          at: .init(x: xPosition - xSetSpacing, y: yPosition),
          proposal: .init(width: xSetSpacing, height: setSize.height)
        )
      }
      
      // Add the set to the BracketView at the calculated position
      if firstRoundHasMostSets || (!firstRoundHasMostSets && roundIndex >= maxIndex) {
        setView.place(at: .init(x: xPosition, y: yPosition), proposal: .init(setView.sizeThatFits(.unspecified)))
        if yPosition + setSize.height * 2 > nextBracketYPosition {
          nextBracketYPosition = yPosition + setSize.height * 2
        }
      } else {
        leftoverSets.append(setView)
      }
      prevRoundNum = set.roundNum
    }
    
    // If there were any sets before the round with the most number of sets, lay them out
    if !mostNumSetsRoundInfo.isEmpty, !leftoverSets.isEmpty {
      prevRoundNum = nil
      // Lay out the remaining sets from right to left
      leftoverSets.reverse()
      // Reset the x position to the round whose sets will be added first
      // setSize.height represents the xSetSpacing between sets
      let setSize = leftoverSets[0].sizeThatFits(.unspecified)
      xPosition = xOrigin + (CGFloat(maxIndex) - 1) * (setSize.width + setSize.height)
      
      for subview in leftoverSets {
        guard let set = subview[PhaseGroupSetValue.self] else { continue }
        let setHeight = subview.sizeThatFits(.unspecified).height
        let xSetSpacing = setHeight
        
        // Update the x position upon reaching a new round
        if let prevRoundNum = prevRoundNum, prevRoundNum != set.roundNum {
          xPosition -= (subview.sizeThatFits(.unspecified).width + xSetSpacing)
        }
        
        // Get the y position of the set that the current set is a prerequisite for
        let nextYPosition = mostNumSetsRoundInfo
          .filter { $0.prevRoundIDs.contains(set.id) }
          .map { $0.yPosition }
        guard nextYPosition.count == 1 else { continue }
        yPosition = nextYPosition[0]
        
        let pathView = pathViews.first { $0[PhaseGroupSetPathID.self] == set.id }
        pathView?.place(
          at: .init(x: xPosition + xSetSpacing, y: yPosition),
          proposal: .init(width: xSetSpacing, height: setHeight)
        )
        
        subview.place(at: .init(x: xPosition, y: yPosition), proposal: .init(subview.sizeThatFits(.unspecified)))
        if yPosition + setHeight * 2 > nextBracketYPosition {
          nextBracketYPosition = yPosition + setHeight * 2
        }
        
        prevRoundNum = set.roundNum
      }
    }
    
    return nextBracketYPosition
  }
  
  /// Returns an array describing how many sets belong to each round
  func getDistribution(for sets: [PhaseGroupSet]) -> [Int] {
    var setDistribution = [Int]()
    var prevRoundNum: Int?
    
    for set in sets {
      if prevRoundNum == nil {
        prevRoundNum = set.roundNum
        setDistribution = [1]
      } else if let prevRoundNum, set.roundNum == prevRoundNum {
        let endIndex = setDistribution.count - 1
        setDistribution[endIndex] += 1
      } else {
        prevRoundNum = set.roundNum
        setDistribution.append(1)
      }
    }
    
    return setDistribution
  }
  
  /// Returns the highest number of rounds across the entire bracket
  func getHighestNumRounds(for sets: [PhaseGroupSet]) -> Int {
    var numUpperBracketRounds = 0
    var numLowerBracketRounds = 0
    var numOtherBracketRounds = 0
    var roundNums = Set<Int>()
    
    for set in sets {
      if set.roundNum > 0, !roundNums.contains(set.roundNum) {
        numUpperBracketRounds += 1
        roundNums.insert(set.roundNum)
      } else if set.roundNum < 0, !roundNums.contains(set.roundNum) {
        numLowerBracketRounds += 1
        roundNums.insert(set.roundNum)
      } else {
        numOtherBracketRounds = 1
      }
    }
    
    return max(numUpperBracketRounds, numLowerBracketRounds, numOtherBracketRounds)
  }
}

struct PhaseGroupSetValue: LayoutValueKey {
  static let defaultValue: PhaseGroupSet? = nil
}

struct PhaseGroupRoundLabel: LayoutValueKey {
  static let defaultValue: PhaseGroupDetails.RoundLabel? = nil
}

struct PhaseGroupSetPathID: LayoutValueKey {
  static let defaultValue: Int? = nil
}
