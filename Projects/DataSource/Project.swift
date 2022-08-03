//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by Woody on 2022/08/03.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.make(
  name: "DataSource",
  targets: [
    .staticLibrary(
        name: "DataSource",
        dependencies: []
    ),
    .unitTests(name: "DataSource")
  ]
)
