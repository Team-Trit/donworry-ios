//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by Woody on 2022/08/03.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.make(
  name: "DonWorryNetworking",
  targets: [
    .staticLibrary(
        name: "DonWorryNetworking",
        dependencies: [
            .external(name: "Moya"),
            .external(name: "RxMoya")
        ]
    ),
    .unitTests(name: "DonWorryNetworking")
  ]
)
