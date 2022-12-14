//
//  ImageContentView.swift
//  MyPetD
//
//  Created by heyji on 2022/10/17.
//

import UIKit

class ImageContentView: UIView, UIContentView {
    struct Configuration: UIContentConfiguration {
        var image: String? = ""
        var onChange: (String) -> Void = { _ in }
        
        func makeContentView() -> UIView & UIContentView {
            return ImageContentView(self)
        }
    }
    
    var imageView = UIImageView()
    var imageButton = UIButton()
    var configuration: UIContentConfiguration {
        didSet {
            configure(configuration: configuration)
        }
    }
    
    override var intrinsicContentSize: CGSize {
        CGSize(width: 0, height: 200)
    }
    
    init(_ configuration: UIContentConfiguration) {
        self.configuration = configuration
        super.init(frame: .zero)
        addPinnedSubview(imageView, height: 200, insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        addPinnedSubview(imageButton, height: 200, insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .white
        imageView.layer.borderColor = UIColor.shadyLadyColor.cgColor
        imageView.layer.borderWidth = 0.8
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        imageButton.setImage(UIImage(systemName: "camera"), for: .normal)
        imageButton.contentMode = .scaleAspectFill
        imageButton.layer.cornerRadius = 10
        imageButton.tintColor = .ebonyClayColor
        imageButton.isUserInteractionEnabled = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(configuration: UIContentConfiguration) {
        guard let configuration = configuration as? ImageContentView.Configuration else { return }
        guard let imageUrl = configuration.image else { return }

        if let imageData = NSData(contentsOfFile: imageUrl) {
            imageView.image = UIImage(data: imageData as Data)
        } else {
            imageView.setImageURL(imageUrl)
        }
        configuration.onChange(imageUrl)
    }
}

extension UICollectionViewListCell {
    func imageConfiguration() -> ImageContentView.Configuration {
        ImageContentView.Configuration()
    }
}
