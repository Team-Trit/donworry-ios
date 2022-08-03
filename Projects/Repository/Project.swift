//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by Woody on 2022/08/03.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.make(
  name: "Repository",
  targets: [
    .staticLibrary(name: "Repository", dependencies: []),
    .unitTests(name: "Repository")
  ]
)
