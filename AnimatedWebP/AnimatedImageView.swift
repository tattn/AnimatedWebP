//
//  AnimatedImageView.swift
//  AnimatedWebP
//
//  Created by Tatsuya Tanaka on 2016/09/22.
//  Copyright © 2016年 tattn. All rights reserved.
//

import UIKit

open class AnimatedImageView: UIImageView {

    override open var image: UIImage? {
        didSet {
            if image != oldValue {
                setNeedsDisplay()
                layer.setNeedsDisplay()
            }
        }
    }

    override open func startAnimating() {
        if self.isAnimating {
            return
        } else {
            if webPImage == nil { return }
            displayLink.isPaused = false
        }
    }

    override open func stopAnimating() {
        super.stopAnimating()
        if isDisplayLinkInitialized {
            displayLink.isPaused = true
        }
    }

    override open var isAnimating: Bool {
        if isDisplayLinkInitialized {
            return !displayLink.isPaused
        } else {
            return super.isAnimating
        }
    }

    override open func display(_ layer: CALayer) {
        if let currentFrame = webPImage?.frame(at: currentFrameIndex) {
            layer.contents = currentFrame.image
        } else {
            layer.contents = image?.cgImage
        }
    }

    override open func didMoveToWindow() {
        super.didMoveToWindow()
        didMove()
    }

    override open func didMoveToSuperview() {
        super.didMoveToSuperview()
        didMove()
    }

    private func didMove() {
        if autoPlaying && webPImage != nil {
            if let _ = superview, let _ = window {
                startAnimating()
            } else {
                stopAnimating()
            }
        }
    }



    /// for weak reference
    /// Source: http://merowing.info/2015/11/the-beauty-of-imperfection/
    private class TargetProxy {
        private weak var target: AnimatedImageView?

        init(target: AnimatedImageView) {
            self.target = target
        }

        @objc func onScreenUpdate() {
            target?.updateFrame()
        }
    }

    private lazy var displayLink: CADisplayLink = {
        let displayLink = CADisplayLink(target: TargetProxy(target: self), selector: #selector(TargetProxy.onScreenUpdate))
        displayLink.add(to: .main, forMode: self.runLoopMode)
        displayLink.isPaused = true
        self.isDisplayLinkInitialized = true
        return displayLink
    }()

    private var isDisplayLinkInitialized = false



    public var runLoopMode = RunLoopMode.commonModes {
        willSet {
            if runLoopMode == newValue {
                return
            } else {
                stopAnimating()
                displayLink.remove(from: .main, forMode: runLoopMode)
                displayLink.add(to: .main, forMode: newValue)
                startAnimating()
            }
        }
    }

    public var webPImage: WebPImage? {
        didSet {
            didMove()
            layer.setNeedsDisplay()
        }
    }

    public var currentFrameIndex = 0

    public var autoPlaying = true



    deinit {
        if isDisplayLinkInitialized {
            displayLink.invalidate()
        }
    }


    private lazy var updateFrame: () -> Void = {

        var waitTime: Double = 0

        let updateFrame: () -> Void = { [unowned self] in
            guard let webp = self.webPImage else { return }

            let nextIndex = (self.currentFrameIndex + 1) % webp.maxFrameCount
            let frame     = webp.frame(at: nextIndex)

            waitTime += self.displayLink.duration
            guard waitTime >= frame.duration else { return }
            
            waitTime = 0

            self.layer.setNeedsDisplay()

            self.currentFrameIndex = nextIndex
        }

        return updateFrame
    }()

}
