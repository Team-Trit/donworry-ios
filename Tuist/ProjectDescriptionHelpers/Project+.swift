import ProjectDescription

extension Project {

  public static func make(
    name: String,
    settings: Settings?,
    targets: [Target]
  ) -> Project {
    Project(
      name: name,
      organizationName: "Tr-iT",
      options: .options( // 앱 아이콘 넣어야할 경우 삭제 필요한 옵션 
        disableBundleAccessors: true,
        disableSynthesizedResourceAccessors: true
      ),
      settings: settings,
      targets: targets
    )
  }

  public static func framework(
    name: String,
    targets: [Target]
  ) -> Project {
    Project(
      name: name,
      organizationName: "Tr-iT",
      targets: targets
    )
  }
}
