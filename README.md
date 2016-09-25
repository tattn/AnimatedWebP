# Animated WebP
Decode an animated WebP in Swift 3

## Installation

### Carthage

```
github "tattn/AnimatedWebP"
```

### CocoaPods

```
pod 'AnimatedWebP'
```

## Examples

### Load from bundle
```swift
let path = Bundle.main.path(forResource: "sample", ofType: "webp")!
let data = try! Data(contentsOf: URL(string: path)!)

// Load a webp image from Data
let webp = WebPImage(webP: data)

// Create an image view for animated webp image
let imageView = AnimatedImageView()
view.addSubView(imageView)

// Set an animated webp image
imageView.webPImage = webp
```

### Load from web

```swift
let url     = URL(string: "http://example.com/image.webp")!
let request = URLRequest(url: url)
let config  = URLSessionConfiguration.default
let session = URLSession(configuration: config, delegate: nil, delegateQueue: OperationQueue.main)

let task = session.dataTask(with: request) { data, _, _ in
    self.imageView?.webPImage = WebPImage(webP: data!)
}
task.resume()
```

## Contributing

1. Fork it!
2. Create your feature branch: `git checkout -b my-new-feature`
3. Commit your changes: `git commit -am 'Add some feature'`
4. Push to the branch: `git push origin my-new-feature`
5. Submit a pull request :D

## License

AnimatedWebP is released under the MIT license. See LICENSE for details.
