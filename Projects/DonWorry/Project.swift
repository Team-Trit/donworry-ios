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
            .project(target: "DataSource", path: "../DataSource"),
            .external(name: "SnapKit"),
            .external(name: "Kingfisher"),
            .external(name: "RxSwift"),
            .external(name: "RxCocoa"),
            .external(name: "ReactorKit"),
            .external(name: "FlexLayout"),
            .external(name: "Moya")
        ]
    ),
    Target.unitTests(name: "DonWorry"),
    Target.staticLibrary(
        name: "DonWorry-Login",
        dependencies: [

        ]
    ),
    Target.staticLibrary(
        name: "DonWorry-CheckRoomList",
        dependencies: [
            .external(name: "SnapKit"),
            .external(name: "Kingfisher")
        ]
    ),
  ]
)
