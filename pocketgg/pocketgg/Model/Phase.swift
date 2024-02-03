/// A round of the event. Preview of Phase data
///
/// Eg: R1 Pools, R2 Pools, Top 64, Top 8, etc. Used by **EventView**
struct Phase: Identifiable, Hashable {
  let id: Int
  let name: String?
  let state: String?
  
  let numPhaseGroups: Int?
  let numEntrants: Int?
  let bracketType: String?
}

struct PhaseDetails {
  // On-demand data for PhaseGroupListVC
  // Query 3 - PhaseGroupsById
  var phaseGroups: [PhaseGroup]?
}
