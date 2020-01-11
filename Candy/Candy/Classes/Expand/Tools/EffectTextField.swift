//
//  EffectTextField.swift
//  AddressSign
//
//  Created by 左聂荣 on 2019/12/25.
//  Copyright © 2019 左聂荣. All rights reserved.
//

import UIKit

class EffectTextField: UITextField {

    var inactiveColor: UIColor = UIColor.gray {
        didSet {
            borderLayer.backgroundColor = inactiveColor.cgColor
        }
    }

    var activeColor: UIColor = UIColor.red {
        didSet {
            activeBorderLayer.backgroundColor = activeColor.cgColor
        }
    }

    private lazy var borderLayer: CALayer = {
        let borderLayer = CALayer()
        borderLayer.backgroundColor = UIColor.gray.cgColor
        return borderLayer
    }()

    private lazy var activeBorderLayer: CALayer = {
        let activeBorderLayer = CALayer()
        activeBorderLayer.backgroundColor = UIColor.red.cgColor
        return activeBorderLayer
    }()

    private var isActive = false

    override init(frame: CGRect) {
        super.init(frame: frame)

        layer.addSublayer(borderLayer)
        layer.addSublayer(activeBorderLayer)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        borderLayer.frame = CGRect(x: 0, y: bounds.height, width: bounds.width, height: 0.5)
        activeBorderLayer.frame = CGRect(x: 0, y: bounds.height, width: isActive ? bounds.width : 0, height: 1)
    }

    @discardableResult
    override func becomeFirstResponder() -> Bool {
        if !isActive {
            isActive = true
            layoutIfNeeded()
        }
        return super.becomeFirstResponder()
    }

    @discardableResult
    override func resignFirstResponder() -> Bool {
        if isActive {
            isActive = false
            layoutIfNeeded()
        }
        return super.resignFirstResponder()
    }
}
