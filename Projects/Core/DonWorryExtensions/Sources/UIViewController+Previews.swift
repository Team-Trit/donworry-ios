//
//  UIViewController+Preview.swift
//  BaseArchitecture
//
//  Created by Woody on 2022/08/04.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit

#if DEBUG
import SwiftUI

public extension UIViewController {

    private struct Preview: UIViewControllerRepresentable {
        let viewController: UIViewController

        func makeUIViewController(context: Context) -> UIViewController {
            return viewController
        }

        func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        }
    }

    func toPreview() -> some View {
        Preview(viewController: self)
    }
}
#endif
