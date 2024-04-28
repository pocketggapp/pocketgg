struct Profile {
  let id: Int
  let name: String?
  let teamName: String?
  let bio: String?
  let profileImageURL: String?
  let bannerImageURL: String?
  let bannerImageRatio: Double?
  let tournaments: [Tournament]
}
