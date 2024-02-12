import StartggAPI

/// A round of the event. Preview of Phase data
///
/// Eg: R1 Pools, R2 Pools, Top 64, Top 8, etc. Used by **EventView**
struct Phase: Identifiable, Hashable {
  let id: Int
  let name: String?
  let state: String?
  
  let numPhaseGroups: Int?
  let numEntrants: Int?
  let bracketType: BracketType?
}

// Complete Phase data ('PhaseDetails') is just [PhaseGroup]
