//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by Woody on 2022/08/31.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.make(
  name: "DonWorryLocalStorage",
  settings: nil,
  targets: [
    .staticLibrary(
        name: "DonWorryLocalStorage"
    ),
    .unitTests(name: "DonWorryLocalStorage")
  ]
)
