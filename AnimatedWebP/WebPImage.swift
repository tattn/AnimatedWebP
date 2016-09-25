//
//  WebPImage.swift
//  AnimatedWebP
//
//  Created by Tatsuya Tanaka on 2016/09/22.
//  Copyright © 2016年 tattn. All rights reserved.
//

import UIKit

public class WebPImage {

    private let originalData: Data // strong reference
    private var frames: [WebPFrame] = []
    
    public let loopCount: Int

    private let decoder: WebPDecoder

    public init(webP data: Data) {
        originalData  = data
        decoder       = WebPDecoder(webP: data)

        if let result = decoder.decode() {
            frames    = result.frames
            loopCount = result.loopCount
        } else {
            loopCount = 0
        }
    }

    public var maxFrameCount: Int {
        return frames.count
    }

    public func frame(at index: Int) -> WebPFrame {
        let frame = frames[index]
        if frame.image == nil {
            frame.image = createImage(at: index)
        }
        return frame
    }

    private func createImage(at index: Int) -> CGImage? {
        let frame = frames[index]
        return decoder.decodeImage(index: index,
                                   width: frame.width,
                                   height: frame.height)
    }


}
