//
//  AdaptivePresentationControllerDelegateProxy.swift
//  DonWorry
//
//  Created by Woody on 2022/09/16.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit

public protocol AdaptivePresentationControllerDelegate: AnyObject {
    func presentationControllerDidDismiss()
}

public final class AdaptivePresentationControllerDelegateProxy: NSObject, UIAdaptivePresentationControllerDelegate {

    public weak var delegate: AdaptivePresentationControllerDelegate?

    public func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        delegate?.presentationControllerDidDismiss()
    }
}

