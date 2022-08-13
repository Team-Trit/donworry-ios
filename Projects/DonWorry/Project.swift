import ProjectDescription
import ProjectDescriptionHelpers


let project = Project.make(
  name: "App",
  targets: [
    Target.appTarget(
        name: "DonWorry",
        dependencies: [
            .project(target: "DesignSystem", path: "../DesignSystem"),
            .project(target: "CoreKit", path: "../Core/CoreKit"),
            .project(target: "Networking", path: "../Networking"),
            .project(target: "BaseArchitecture", path: "../Core/CoreKit"),
            .project(target: "DonWorryExtensions", path: "../Core/CoreKit"),
            .project(target: "DonWorryProtocols", path: "../Core/CoreKit"),
            .project(target: "Models", path: "../Core/CoreKit"),
            .external(name: "SnapKit"),
            .external(name: "Kingfisher"),
            .external(name: "RxSwift"),
            .external(name: "RxCocoa"),
            .external(name: "ReactorKit"),
            .external(name: "FlexLayout")
        ]
    ),
    Target.unitTests(name: "DonWorry"),
  ]
)
