//
//  DWBaseButton.swift
//  DesignSystem
//
//  Created by Chanhee Jeong on 2022/09/19.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit

public final class DWBaseButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)

        configure()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        super.point(inside: point, with: event)

        let touchArea = bounds.insetBy(dx: -30, dy: -30)
        return touchArea.contains(point)
    }

    func configure() {}
    func bind() {}
}
