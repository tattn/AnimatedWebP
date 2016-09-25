//
//  WebPFrame.swift
//  AnimatedWebP
//
//  Created by Tatsuya Tanaka on 2016/09/22.
//  Copyright © 2016年 tattn. All rights reserved.
//

import UIKit

public class WebPFrame {
    let index: Int
    let duration: Double
    let width: Int
    let height: Int
    let hasAlpha: Bool
    let blend: Bool
    let offsetX: Int
    let offsetY: Int

    var image: CGImage? = nil

    init(index: Int,
         duration: Double,
         width: Int,
         height: Int,
         hasAlpha: Bool,
         blend: Bool,
         offsetX: Int,
         offsetY: Int,
         image: CGImage? = nil) {
        self.index    = index
        self.duration = duration
        self.width    = width
        self.height   = height
        self.hasAlpha = hasAlpha
        self.blend    = blend
        self.offsetX  = offsetX
        self.offsetY  = offsetY
        self.image    = image
    }
}
