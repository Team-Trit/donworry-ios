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
  settings: nil,
  targets: [
    .staticLibrary(
      name: "CoreKit",
      dependencies: []
    ),
    .unitTests(name: "CoreKit"),
    .staticLibraryTarget(name: "Models"),
    .staticLibraryTarget(
      name: "BaseArchitecture",
      dependencies: [
        .external(name: "RxSwift"),
        .external(name: "RxCocoa")
      ]
    ),
    .staticLibraryTarget(
      name: "DonWorryExtensions",
      dependencies: [
        .external(name: "RxSwift"),
        .external(name: "RxCocoa")
      ]
    ),
    .staticLibraryTarget(
      name: "DonWorryProtocols"
    )
  ]
)
