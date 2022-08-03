import ProjectDescription
import ProjectDescriptionHelpers


let project = Project.make(
  name: "DonWorryApp",
  targets: [
    Target.appTarget(
        name: "DonWorryApp",
        dependencies: [
            .project(target: "DesignSystem", path: "../DesignSystem"),
            .project(target: "CoreKit", path: "../Core/CoreKit"),
            .project(target: "DataSource", path: "../DataSource")
        ]
    ),
    Target.unitTests(name: "DonWorryApp")
  ]
)
