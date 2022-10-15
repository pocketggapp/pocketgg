//
//  RoundRobinBracketView.swift
//  pocket.gg
//
//  Created by Gabriel Siu on 2020-12-07.
//  Copyright © 2020 Gabriel Siu. All rights reserved.
//

import UIKit

final class RoundRobinBracketView: UIView, BracketView {
  
  let sets: [PhaseGroupSet]?
  var isValid = true
  var invalidationCause: InvalidBracketViewCause?
  
  let entrants: [Entrant]
  let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
  
  // MARK: Initialization
  
  init(sets: [PhaseGroupSet]?, entrants: [Entrant]?) {
    self.sets = sets
    
    guard let entrants = entrants, !entrants.isEmpty else {
      self.entrants = []
      super.init(frame: .zero)
      isValid = false
      invalidationCause = .noEntrants
      return
    }
    
    self.entrants = entrants
    super.init(frame: .zero)
    setupBracketView()
    
    let width = Int(k.Sizes.roundRobinSetWidth) * (entrants.count + 2) + ((entrants.count + 1) * Int(k.Sizes.roundRobinSetMargin))
    let height = Int(k.Sizes.roundRobinSetHeight) * (entrants.count + 1) + (entrants.count * Int(k.Sizes.roundRobinSetMargin))
    frame = CGRect(x: 0, y: 0, width: width, height: height)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: Setup
  
  private func setupBracketView() {
    collectionView.dataSource = self
    collectionView.delegate = self
    collectionView.register(RoundRobinSetCell.self, forCellWithReuseIdentifier: k.Identifiers.roundRobinSetCell)
    collectionView.backgroundColor = .systemBackground
    
    addSubview(collectionView)
    collectionView.setEdgeConstraints(top: topAnchor, bottom: bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor)
  }
}

// MARK: - Collection View Data Source & Delegate

extension RoundRobinBracketView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return Int(pow(Double(entrants.count + 1), 2)) + entrants.count + 1
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let numEntrants = entrants.count
    
    if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: k.Identifiers.roundRobinSetCell, for: indexPath) as? RoundRobinSetCell {
      // Top Corners
      if indexPath.row == 0 || indexPath.row == numEntrants + 1 {
        cell.setupCell(type: .topCorner)
        
      // Top Row of Entrant Names
      } else if (1...numEntrants).contains(indexPath.row) {
        cell.setupCell(type: .entrantName)
        cell.setupEntrantCell(entrants[safe: indexPath.row - 1])
        
      // Left Column of Entrant Names
      } else if indexPath.row % (numEntrants + 2) == 0 {
        cell.setupCell(type: .entrantName)
        let entrantIndex = indexPath.row / (numEntrants + 2) - 1
        cell.setupEntrantCell(entrants[safe: entrantIndex])
        
      // Right Column of Overall Entrant Scores
      } else if (indexPath.row + 1) % (numEntrants + 2) == 0 {
        cell.setupCell(type: .overallEntrantScore)
        cell.setupOverallEntrantScoreCell(getOverallEntrantScoreText(index: indexPath.row))
        
      // Diagonal of Blanks
      } else if indexPath.row % (numEntrants + 3) == 0 {
        cell.setupCell(type: .blank)
          
      // Sets
      } else {
        let offset = indexPath.row % (entrants.count + 2)
        let entrantIndex = (indexPath.row - offset) / (numEntrants + 2) - 1
        // TODO: Handle case of no entrant better
        guard let entrant0 = entrants[safe: entrantIndex],
              let entrant1 = entrants[safe: (indexPath.row % (entrants.count + 2)) - 1] else {
          cell.setupCell(type: .setScore, set: nil)
          cell.setupSetScoreCell(nil)
          return cell
        }
        
        // TODO: Make cleaner
        let set = sets?.first(where: { set -> Bool in
          return set.entrants?.compactMap({ info -> Bool? in
            guard let id = info.entrant?.id else { return nil }
            if let id0 = entrant0.id, id0 == id {
              return true
            } else if let id1 = entrant1.id, id1 == id {
              return true
            }
            return nil
          }).count == 2
        })
        
        cell.setupCell(type: .setScore, set: set)
        cell.setupSetScoreCell(entrant0)
      }
      return cell
    }
    
    return UICollectionViewCell()
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: k.Sizes.roundRobinSetWidth, height: k.Sizes.roundRobinSetHeight)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return .zero
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return k.Sizes.roundRobinSetMargin
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return k.Sizes.roundRobinSetMargin
  }
  
  private func getOverallEntrantScoreText(index: Int) -> String {
    let offset = index % (entrants.count + 2)
    let entrantIndex = (index - offset) / (entrants.count + 2) - 1
    guard let name = entrants[safe: entrantIndex]?.name else { return "" }
    guard let sets = sets else { return "" }
    
    var setsWon = 0
    var setsLost = 0
    var gamesWon = 0
    var gamesLost = 0
    
    for set in sets {
      guard let name0 = set.entrants?[safe: 0]?.entrant?.name else { return "" }
      guard let name1 = set.entrants?[safe: 1]?.entrant?.name else { return "" }
      
      guard let score0 = set.entrants?[safe: 0]?.score else { return "" }
      guard let score1 = set.entrants?[safe: 1]?.score else { return "" }
           
      if name == name0 || name == name1 {
        if let score0Num = Int(score0), let score1Num = Int(score1) {
          if name == name0 {
            setsWon += score0Num > score1Num ? 1 : 0
            setsLost += score0Num < score1Num ? 1 : 0
            gamesWon += score0Num
            gamesLost += score1Num
          } else if name == name1 {
            setsWon += score0Num < score1Num ? 1 : 0
            setsLost += score0Num > score1Num ? 1 : 0
            gamesWon += score1Num
            gamesLost += score0Num
          }
        } else if score0 == "W" || score1 == "W" {
          if name == name0 {
            setsWon += score0 == "W" ? 1 : 0
            setsLost += score1 == "W" ? 1 : 0
          } else if name == name1 {
            setsWon += score1 == "W" ? 1 : 0
            setsLost += score0 == "W" ? 1 : 0
          }
        } else if score0 == "✓" || score1 == "✓" {
          if name == name0 {
            setsWon += score0 == "✓" ? 1 : 0
            setsLost += score1 == "✓" ? 1 : 0
          } else if name == name1 {
            setsWon += score1 == "✓" ? 1 : 0
            setsLost += score0 == "✓" ? 1 : 0
          }
        }
      }
    }
    
    return "\(setsWon) - \(setsLost)\n\(gamesWon) - \(gamesLost)"
  }
}
