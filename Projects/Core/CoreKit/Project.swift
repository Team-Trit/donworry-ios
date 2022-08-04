//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by Woody on 2022/08/03.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.make(
  name: "CoreKit",
  targets: [
    .staticLibrary(name: "CoreKit"),
    .unitTests(name: "CoreKit"),
    .staticLibraryTarget(name: "Models")
  ]
)
