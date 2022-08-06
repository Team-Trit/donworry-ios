import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.framework(
  name: "DesignSystem",
  targets: [
    Target.frameworkTarget(name: "DesignSystem"),
    Target.unitTests(name: "DesignSystem")
  ]
)
