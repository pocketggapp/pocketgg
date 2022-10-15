//
//  EliminationBracketView.swift
//  pocket.gg
//
//  Created by Gabriel Siu on 2020-09-10.
//  Copyright © 2020 Gabriel Siu. All rights reserved.
//

import UIKit

struct SetInfo {
  let yPosition: CGFloat
  let id: Int?
  let prevRoundIDs: [Int]?
}

final class EliminationBracketView: UIView, BracketView {
  
  var sets: [PhaseGroupSet]?
  var totalSize: CGSize = .zero
  var isValid = true
  var invalidationCause: InvalidBracketViewCause?
  
  // MARK: Initialization
  
  init(sets: [PhaseGroupSet]?) {
    guard let sets = sets, !sets.isEmpty else {
      super.init(frame: .zero)
      invalidateBracketView(with: .noSets)
      return
    }
    
    // First sort the sets by the number of characters in their identifier
    // Then sort the the sets by their identifier's alphabetical order
    self.sets = sets.sorted {
      if $0.identifier.count != $1.identifier.count {
        return $0.identifier.count < $1.identifier.count
      } else {
        return $0.identifier < $1.identifier
      }
    }
    super.init(frame: .zero)
    resolveBracketIssues()
    setupBracketView()
    frame = CGRect(x: 0, y: 0, width: totalSize.width, height: totalSize.height)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: Setup
  
  private func resolveBracketIssues() {
    guard var sets = sets else { return }
    var setsNeedUpdate = false
    
    // In the case of a grand finals reset, the 2nd grand finals may have the same roundNum as the 1st grand finals set
    // Therefore, if a set is detected with identical previous round IDs (meaning that the set is a grand finals reset), increment the roundNum
    for (i, set) in sets.enumerated() {
      guard set.id != nil else {
        invalidateBracketView(with: .bracketNotStarted)
        self.sets = nil
        return
      }
      guard let prevRoundIDs = set.prevRoundIDs, prevRoundIDs.count == 2 else { continue }
      if prevRoundIDs[0] == prevRoundIDs[1] {
        sets[i].roundNum += 1
        setsNeedUpdate = true
      }
    }
    
    if setsNeedUpdate {
      self.sets = sets
    }
  }
  
  private func setupBracketView() {
    guard let sets = sets else { return }
    
    // Winners Bracket
    layoutSets(yOrigin: k.Sizes.bracketMargin, sets: sets.filter { $0.roundNum > 0 })
    // Losers Bracket
    layoutSets(yOrigin: totalSize.height, sets: sets.filter { $0.roundNum < 0 })
    // Other
    layoutSets(yOrigin: totalSize.height, sets: sets.filter { $0.roundNum == 0 })
  }
  
  private func layoutSets(yOrigin: CGFloat, sets: [PhaseGroupSet]) {
    guard !sets.isEmpty else { return }
    
    /// The x position of where the the SetView is going to be added in the BracketView
    var xPosition = k.Sizes.bracketMargin
    /// The y position of where the the SetView is going to be added in the BracketView
    var yPosition = yOrigin
    /// The round number of the previous set that was computed. Used for detecting if the current set belongs to a new round
    var prevRoundNum: Int?
    
    /// An array describing how many sets belong to each round
    let setDistribution = getDistribution(for: sets)
    
    /// The most number of sets per round out of all the rounds
    guard let max = setDistribution.max() else { return }
    /// The roundIndex corresponding to the round with the most number of sets
    guard let maxIndex = setDistribution.firstIndex(of: max) else { return }
    /// A bool value describing whether or not the first round has the most number of sets compared to the other rounds
    let firstRoundHasMostSets = max == setDistribution[0]
    /// The y positions and prerequisite IDs of the sets in the round with the most number of sets. Only used when firstRoundHasMostSets is false
    var mostNumSetsRoundInfo = [SetInfo]()
    /// An array that will contain all of the sets before the round with the most number of sets. Only used when firstRoundHasMostSets is false
    var leftoverSets = [PhaseGroupSet]()
    
    /// Represents which round a particular set belongs to (Eg. If roundIndex == 0, the set belongs to the leftmost round)
    var roundIndex = 0
    /// The y positions and IDs of all of the sets from the previous round
    var prevRoundInfo = [SetInfo]()
    /// The y positions and IDs of the sets in the current round. Only used when the current round has a different number of sets than the previous round
    var currRoundInfo = [SetInfo]()
    
    // Iterate through all of the sets
    // If !firstRoundHasMostSets, ignore the sets before the round with the most number of sets
    for set in sets {
      // Preparation for if we reach a new round of sets
      if let prevRoundNum = prevRoundNum, prevRoundNum != set.roundNum {
        xPosition += k.Sizes.setWidth + k.Sizes.xSetSpacing
        roundIndex += 1
      }
      
      // Upon reaching the round with the most number of sets and if !firstRoundHasMostSets, clear all info about the previous sets
      if !firstRoundHasMostSets, roundIndex == maxIndex, set.roundNum != prevRoundNum {
        prevRoundNum = nil
        prevRoundInfo.removeAll()
      }
      
      // First Set
      if prevRoundNum == nil {
        addRoundLabel(at: CGPoint(x: xPosition, y: yOrigin), text: set.fullRoundText)
        yPosition = yOrigin + k.Sizes.setHeight
        prevRoundInfo.append(SetInfo(yPosition: yPosition, id: set.id, prevRoundIDs: set.prevRoundIDs))
      
      // Next Round of Sets
      } else if prevRoundNum != set.roundNum {
        if !firstRoundHasMostSets, mostNumSetsRoundInfo.isEmpty {
          mostNumSetsRoundInfo = prevRoundInfo
        } else if !currRoundInfo.isEmpty {
          prevRoundInfo = currRoundInfo
          currRoundInfo.removeAll()
        }
        
        addRoundLabel(at: CGPoint(x: xPosition, y: yOrigin), text: set.fullRoundText)
          
      // Consecutive sets in the round with the most number of sets
      } else if (firstRoundHasMostSets && roundIndex == 0) || (!firstRoundHasMostSets && roundIndex == maxIndex) {
        yPosition += k.Sizes.setHeight + k.Sizes.ySetSpacing
        prevRoundInfo.append(SetInfo(yPosition: yPosition, id: set.id, prevRoundIDs: set.prevRoundIDs))
      }
      
      // Determine how to layout the sets for sets past the first round
      if (firstRoundHasMostSets && roundIndex > 0) || (!firstRoundHasMostSets && roundIndex > maxIndex) {
        // If the current round has a different number of sets than the previous round
        if setDistribution[roundIndex] != setDistribution[roundIndex - 1] {
          guard let prevRoundIDs = set.prevRoundIDs else {
            invalidateBracketView(with: .bracketLayoutError)
            return
          }
              
          // Get the y positions of the prerequisite sets for the current set
          let prevYPositions = prevRoundInfo.filter { prevRoundIDs.contains($0.id ?? -1) }.map { $0.yPosition }
          
          // Calculate the y position for the current set based on those of the prerequisite set(s)
          switch prevYPositions.count {
          case 1:
            yPosition = prevYPositions[0]
            addSetPathView(numPrecedingSets: 1, x: xPosition - k.Sizes.xSetSpacing, y: prevYPositions[0], height: k.Sizes.setHeight)
          case 2:
            yPosition = floor((prevYPositions[0] + prevYPositions[1]) / 2)
            addSetPathView(numPrecedingSets: 2,
                           x: xPosition - k.Sizes.xSetSpacing,
                           y: min(prevYPositions[0], prevYPositions[1]),
                           height: abs(prevYPositions[0] - prevYPositions[1]) + k.Sizes.setHeight)
          default:
            invalidateBracketView(with: .bracketLayoutError)
            return
          }
          currRoundInfo.append(SetInfo(yPosition: yPosition, id: set.id, prevRoundIDs: set.prevRoundIDs))
            
        // If the current round has the same number of sets as the previous round
        } else {
          yPosition = prevRoundInfo.removeFirst().yPosition
          prevRoundInfo.append(SetInfo(yPosition: yPosition, id: set.id, prevRoundIDs: set.prevRoundIDs))
          addSetPathView(numPrecedingSets: 1, x: xPosition - k.Sizes.xSetSpacing, y: yPosition, height: k.Sizes.setHeight)
        }
      }
      
      // Update the width and/or height of the entire BracketView if necessary
      updateBracketViewSize(xPosition: xPosition, yPosition: yPosition)
      
      // Add the set to the BracketView at the calculated position
      if firstRoundHasMostSets || (!firstRoundHasMostSets && roundIndex >= maxIndex) {
        addSubview(SetView(set: set, xPos: xPosition, yPos: yPosition))
        let offset = k.Sizes.setHeight / 4
        addSubview(SetIdentifierView(setIdentifier: set.identifier, xPos: xPosition - offset, yPos: yPosition + offset))
      } else {
        leftoverSets.append(set)
      }
      prevRoundNum = set.roundNum
    }
    
    // If there were any sets before the round with the most number of sets, lay them out
    if !mostNumSetsRoundInfo.isEmpty, !leftoverSets.isEmpty {
      prevRoundNum = nil
      // Lay out the remaining sets from right to left
      leftoverSets.reverse()
      // Reset the x position to the round whose sets will be added first
      xPosition = k.Sizes.bracketMargin + (CGFloat(maxIndex) - 1) * (k.Sizes.setWidth + k.Sizes.xSetSpacing)
      
      for set in leftoverSets {
        // Update the x position upon reaching a new round
        if let prevRoundNum = prevRoundNum, prevRoundNum != set.roundNum {
          xPosition -= (k.Sizes.setWidth + k.Sizes.xSetSpacing)
        }
        
        // Get the y position of the set that the current set is a prerequisite for
        let nextYPosition = mostNumSetsRoundInfo.filter {
          guard let prevRoundIDs = $0.prevRoundIDs else { return false }
          return prevRoundIDs.contains(set.id ?? -1)
        }.map { $0.yPosition }
        guard nextYPosition.count == 1 else { continue }
        yPosition = nextYPosition[0]
        
        addSetPathView(numPrecedingSets: 1, x: xPosition + k.Sizes.setWidth, y: yPosition, height: k.Sizes.setHeight)
        addSubview(SetView(set: set, xPos: xPosition, yPos: yPosition))
        let offset = k.Sizes.setHeight / 4
        addSubview(SetIdentifierView(setIdentifier: set.identifier, xPos: xPosition - offset, yPos: yPosition + offset))
        prevRoundNum = set.roundNum
      }
    }
  }
  
  // MARK: Private Helpers
  
  private func getDistribution(for sets: [PhaseGroupSet]) -> [Int] {
    var setDistribution = [Int]()
    var prevRoundNum: Int?
    
    for set in sets {
      if prevRoundNum == nil {
        prevRoundNum = set.roundNum
        setDistribution = [1]
      } else if let prevRoundNum = prevRoundNum, set.roundNum == prevRoundNum {
        let endIndex = setDistribution.count - 1
        setDistribution[endIndex] += 1
      } else {
        prevRoundNum = set.roundNum
        setDistribution.append(1)
      }
    }
    return setDistribution
  }
  
  private func addRoundLabel(at point: CGPoint, text: String?) {
    let roundLabel = UILabel(frame: CGRect(x: point.x, y: point.y, width: k.Sizes.setWidth, height: k.Sizes.setHeight))
    roundLabel.text = text
    roundLabel.textAlignment = .center
    roundLabel.font = UIFont.boldSystemFont(ofSize: roundLabel.font.pointSize)
    addSubview(roundLabel)
  }
  
  private func addSetPathView(numPrecedingSets: Int, x: CGFloat, y: CGFloat, height: CGFloat) {
    let setPathView = SetPathView(numPrecedingSets: numPrecedingSets)
    setPathView.draw(CGRect(x: x, y: y, width: k.Sizes.xSetSpacing, height: height))
    addSubview(setPathView)
  }
  
  private func updateBracketViewSize(xPosition: CGFloat, yPosition: CGFloat) {
    if (xPosition + k.Sizes.setWidth + k.Sizes.xSetSpacing) > totalSize.width {
      totalSize.width = xPosition + k.Sizes.setWidth + k.Sizes.xSetSpacing
    }
    if (yPosition + k.Sizes.setHeight + k.Sizes.xSetSpacing) > totalSize.height {
      totalSize.height = yPosition + k.Sizes.setHeight + k.Sizes.xSetSpacing
    }
  }
  
  private func invalidateBracketView(with cause: InvalidBracketViewCause) {
    isValid = false
    invalidationCause = cause
    subviews.forEach { $0.removeFromSuperview() }
    frame = .zero
  }
}
