//
//  WebPDecoder.swift
//  AnimatedWebP
//
//  Created by Tatsuya Tanaka on 2016/09/22.
//  Copyright © 2016年 tattn. All rights reserved.
//

import UIKit
import WebP

final class WebPDecoder {

    private let webPDataP: UnsafePointer<UInt8>
    private var webPData: WebPData
    private let demuxer: OpaquePointer?

    init(webP data: Data) {
        webPDataP = data.withUnsafeBytes { (ptr: UnsafePointer<UInt8>) -> UnsafePointer<UInt8> in
            return ptr
        }

        webPData = WebPData(bytes: webPDataP, size: data.count)
        demuxer  = WebPDemux(&webPData)
    }

    deinit {
        WebPDemuxDelete(demuxer)
    }

    func decode() -> (frames: [WebPFrame], loopCount: Int)? {

        var frames: [WebPFrame] = []

        let frameCount = Int(WebPDemuxGetI(demuxer, WEBP_FF_FRAME_COUNT))
        let loopCount  = Int(WebPDemuxGetI(demuxer, WEBP_FF_LOOP_COUNT))
        let width      = Int(WebPDemuxGetI(demuxer, WEBP_FF_CANVAS_WIDTH))
        let height     = Int(WebPDemuxGetI(demuxer, WEBP_FF_CANVAS_HEIGHT))

        guard frameCount > 0 && width > 0 && height > 0 else {
            return nil
        }

        var iter = WebPIterator()
        if WebPDemuxGetFrame(demuxer, 1, &iter) != 0 {
            defer {
                WebPDemuxReleaseIterator(&iter)
            }

            repeat {
                let frame = WebPFrame(index: frames.count,
                                      duration: Double(iter.duration) / 1000,
                                      width: Int(iter.width),
                                      height: Int(iter.height),
                                      hasAlpha: iter.has_alpha != 0,
                                      blend: iter.blend_method == WEBP_MUX_BLEND,
                                      offsetX: Int(iter.x_offset),
                                      offsetY: Int(iter.y_offset))

                frames.append(frame)
            } while (WebPDemuxNextFrame(&iter) != 0)
        }

        return (frames, loopCount)
    }

    func decodeImage(index: Int,
                     width: Int,
                     height: Int) -> CGImage? {

        var iter = WebPIterator()
        if WebPDemuxGetFrame(demuxer, index + 1, &iter) == 0 { return nil }
        defer {
            WebPDemuxReleaseIterator(&iter)
        }

        var config   = WebPDecoderConfig()
        let data     = iter.fragment.bytes
        let dataSize = iter.fragment.size

        if WebPInitDecoderConfig(&config) == 0 ||
            WebPGetFeatures(data, dataSize, &config.input) != VP8_STATUS_OK {
            return nil
        }

        let components: size_t = config.input.has_alpha != 0 ? 4 : 3
        let bitsPerComponent   = 8
        let bitsPerPixel       = bitsPerComponent * components
        let bytesPerRow        = width * components


        config.output.colorspace = config.input.has_alpha != 0 ? MODE_rgbA : MODE_RGB
        config.options.use_threads = 1

        let decodeStatus = WebPDecode(data, dataSize, &config)
        if decodeStatus != VP8_STATUS_OK && decodeStatus != VP8_STATUS_NOT_ENOUGH_DATA {
            return nil
        }

        let provider = CGDataProvider(dataInfo: nil,
                                      data: config.output.u.RGBA.rgba,
                                      size: config.output.u.RGBA.size,
                                      releaseData: { (info: UnsafeMutableRawPointer?, data: UnsafeRawPointer, size: Int) -> Void in
                                        free(UnsafeMutableRawPointer(mutating: data))
        })
        guard let wrappedProvider = provider else {
            return nil
        }

        let bitmapInfo: CGBitmapInfo = config.input.has_alpha != 0 ?
            [CGBitmapInfo.byteOrder32Big, CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)] : CGBitmapInfo(rawValue: CGImageAlphaInfo.none.rawValue)

        return CGImage(width: width,
                       height: height,
                       bitsPerComponent: bitsPerComponent,
                       bitsPerPixel: bitsPerPixel,
                       bytesPerRow: bytesPerRow,
                       space: CGColorSpaceCreateDeviceRGB(),
                       bitmapInfo: bitmapInfo,
                       provider: wrappedProvider,
                       decode: nil,
                       shouldInterpolate: false,
                       intent: .defaultIntent)
    }
}
