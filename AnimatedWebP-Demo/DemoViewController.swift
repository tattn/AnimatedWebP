//
//  DemoViewController.swift
//  AnimatedWebP-Demo
//
//  Created by Tatsuya Tanaka on 2016/09/22.
//  Copyright © 2016年 tattn. All rights reserved.
//

import UIKit
import AnimatedWebP

final class DemoCell: UICollectionViewCell {
    @IBOutlet private weak var imageView: AnimatedImageView!

    private var task: URLSessionTask?

    class ImageRequest {
        var image: WebPImage?
        var observers: [DemoCell] = []
    }
    static private let imageCache = NSCache<NSString, ImageRequest>()

    override func awakeFromNib() {
        super.awakeFromNib()

        let url = "http://res.cloudinary.com/demo/image/upload/fl_awebp/bored_animation.webp"

        if let imageRequest = type(of: self).imageCache.object(forKey: url as NSString) {
            if let image = imageRequest.image {
                self.imageView?.webPImage = image
            } else {
                imageRequest.observers.append(self)
            }

        } else {
            let request = URLRequest(url: URL(string: url)!)
            let config  = URLSessionConfiguration.default
            let session = URLSession(configuration: config, delegate: nil, delegateQueue: OperationQueue.main)

            type(of: self).imageCache.setObject(ImageRequest(), forKey: url as NSString)

            task = session.dataTask(with: request) { data, response, error in

                // ================================================
                // set an animated webp
                let webp                  = WebPImage(webP: data!)
                self.imageView?.webPImage = webp
                // ================================================

                if let imageRequest = type(of: self).imageCache.object(forKey: url as NSString) {
                    imageRequest.observers.forEach { cell in
                        cell.imageView?.webPImage = webp
                    }
                    imageRequest.observers = []
                    imageRequest.image     = webp
                }
            }
            task?.resume()
        }
    }

}

class DemoViewController: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.allowsSelection = false
    }
}

// MARK:- UITableViewDataSource
extension DemoViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DemoCell",
                                                            for: indexPath) as? DemoCell else {
                                                                return UICollectionViewCell()
        }

        return cell
    }
}

