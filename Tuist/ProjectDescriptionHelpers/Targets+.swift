import ProjectDescription

extension Target {

  public static func appTarget(
    name: String,
    dependencies: [TargetDependency] = []
  ) -> Target {
    Target(
      name: name,
      platform: .iOS,
      product: .app,
      bundleId: "com.Tr-iT.\(name)",
      deploymentTarget: .iOS(targetVersion: "13.0", devices: [.iphone]),
      infoPlist: .file(path: "Resources/\(name)-Info.plist"),
      sources: ["Sources/**"],
      resources: ["Resources/**"],
      dependencies: dependencies
    )
  }

  public static func staticLibrary(
    name: String,
    dependencies: [TargetDependency] = []
  ) -> Target {
    Target(
      name: name,
      platform: .iOS,
      product: .staticLibrary,
      bundleId: "com.Tr-iT.\(name)",
      deploymentTarget: .iOS(targetVersion: "13.0", devices: .iphone),
      infoPlist: .default,
      sources: ["Sources/**"],
      dependencies: dependencies
    )
  }

  public static func unitTests(
    name: String
  ) -> Target {
    Target(
      name: "\(name)Tests",
      platform: .iOS,
      product: .unitTests,
      bundleId: "com.Tr-iT.\(name)Tests",
      deploymentTarget: .iOS(targetVersion: "13.0", devices: [.iphone]),
      infoPlist: .default,
      sources: ["Tests/**"],
      dependencies: [.target(name: name)]
    )
  }
  
  public static func frameworkTarget(
    name: String,
    dependencies: [TargetDependency] = []
  ) -> Target {
    Target(
      name: name,
      platform: .iOS,
      product: .framework,
      bundleId: "com.Tr-iT.\(name)",
      deploymentTarget: .iOS(targetVersion: "13.0", devices: .iphone),
      infoPlist: .default,
      sources: ["Sources/**"],
      resources: ["Resources/**"],
      dependencies: dependencies
    )
  }
}
