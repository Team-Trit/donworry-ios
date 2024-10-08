import ProjectDescription
import ProjectDescriptionHelpers

private let otherLinkerFlagSetting = Settings.settings(
    base: ["OTHER_LDFLAGS" : "$(OTHER_LDFLAGS) -ObjC"],
    configurations: [
        .debug(name: .debug),
        .release(name: .release)
    ],
    defaultSettings: .recommended
)

let project = Project.make(
  name: "App",
  settings: otherLinkerFlagSetting,
  targets: [
    Target.appTarget(
        name: "DonWorry",
        dependencies: [
            .project(target: "DesignSystem", path: "../DesignSystem"),
            .project(target: "CoreKit", path: "../Core/CoreKit"),
            .project(target: "DonWorryNetworking", path: "../DonWorryNetworking"),
            .project(target: "DonWorryLocalStorage", path: "../DonWorryLocalStorage"),
            .project(target: "BaseArchitecture", path: "../Core/CoreKit"),
            .project(target: "DonWorryExtensions", path: "../Core/CoreKit"),
            .project(target: "DonWorryProtocols", path: "../Core/CoreKit"),
            .project(target: "Models", path: "../Core/CoreKit"),
            .external(name: "RxDataSources"),
            .external(name: "SnapKit"),
            .external(name: "Kingfisher"),
            .external(name: "RxSwift"),
            .external(name: "RxCocoa"),
            .external(name: "ReactorKit"),
            .external(name: "FlexLayout"),
            .external(name: "RxKakaoSDK"),
            .external(name: "FirebaseDynamicLinks"),
            .external(name: "FirebaseMessaging"),
            .external(name: "FirebaseAnalytics"),
            .external(name: "SkeletonView"),
        ]
    ),
    Target.unitTests(name: "DonWorry"),
  ]
)
