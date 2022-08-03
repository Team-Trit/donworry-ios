import ProjectDescription
import ProjectDescriptionHelpers


let project = Project.make(
  name: "DonWorryApp",
  targets: [
    Target.appTarget(name: "DonWorryApp"),
    Target.unitTests(name: "DonWorryApp")
  ]
)
