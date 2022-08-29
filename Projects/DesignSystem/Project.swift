import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.framework(
  name: "DesignSystem",
  targets: [
    Target.frameworkTarget(
      name: "DesignSystem",
      dependencies: [
        .external(name: "SnapKit")
      ]
    ),
    Target.unitTests(name: "DesignSystem")
  ]
)
