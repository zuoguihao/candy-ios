//
//  UIImage+Ext.swift
//  Candy
//
//  Created by 左聂荣 on 2020/1/10.
//  Copyright © 2020 左聂荣. All rights reserved.
//

import UIKit

extension UIImage {

    /// Create UIImage from color and size.
    ///
    /// - Parameters:
    ///   - color: image fill color.
    ///   - size: image size.
    convenience init(color: UIColor, size: CGSize = CGSize(width: 10, height: 10)) {
        UIGraphicsBeginImageContextWithOptions(size, false, 1)

        defer {
            UIGraphicsEndImageContext()
        }

        color.setFill()
        UIRectFill(CGRect(origin: .zero, size: size))

        guard let aCgImage = UIGraphicsGetImageFromCurrentImageContext()?.cgImage else {
            self.init()
            return
        }

        self.init(cgImage: aCgImage)
    }

    /// 设置图片透明度
    ///
    /// - Parameters:
    ///   - size: 尺寸
    ///   - alpha: 透明度
    func setupAlpha(size: CGSize? = nil, alpha: CGFloat) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size ?? self.size, false, 0.0)

        guard let ctx: CGContext = UIGraphicsGetCurrentContext() else { return self }
        let area = CGRect.init(origin: CGPoint.zero, size: size ?? self.size)

        ctx.ctm.scaledBy(x: 1, y: -1)
        ctx.ctm.translatedBy(x: 0, y: -area.size.height)

        ctx.setBlendMode(CGBlendMode.multiply)

        ctx.setAlpha(alpha)

        ctx.draw(self.cgImage!, in: area)

        let newImage = UIGraphicsGetImageFromCurrentImageContext() ?? self

        UIGraphicsEndImageContext()
        return newImage
    }

    // MARK: Image with Text
    /// Creates a text label image.
    /// - Parameters:
    ///   - text: The text to use in the label.
    ///   - font: The font (default: System font of size 18)
    ///   - color: The text color (default: White)
    ///   - backgroundColor: The background color (default:Gray).
    ///   - size: Image size (default: 10x10)
    ///   - offset: Center offset (default: 0x0)
    convenience init?(
        text: String,
        font: UIFont = UIFont.systemFont(ofSize: 18),
        color: UIColor = UIColor.white,
        backgroundColor: UIColor = UIColor.gray,
        size: CGSize = CGSize(width: 100, height: 100),
        offset: CGPoint = CGPoint(x: 0, y: 0)
    ) {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        label.font = font
        label.text = text
        label.textColor = color
        label.textAlignment = .center
        label.backgroundColor = backgroundColor

        let image = UIImage(fromView: label)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        image?.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))

        self.init(cgImage:(UIGraphicsGetImageFromCurrentImageContext()?.cgImage!)!)
        UIGraphicsEndImageContext()
    }

    // MARK: Image from UIView
    /// Creates an image from a UIView.
    /// - Parameter view: The source view.
    convenience init?(fromView view: UIView) {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, 0)
        //view.drawViewHierarchyInRect(view.bounds, afterScreenUpdates: true)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        self.init(cgImage:(UIGraphicsGetImageFromCurrentImageContext()?.cgImage!)!)
        UIGraphicsEndImageContext()
    }

}
