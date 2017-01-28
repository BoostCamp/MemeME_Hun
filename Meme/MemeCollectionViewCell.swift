//
//  MemeCollectionViewCell.swift
//  Meme
//
//  Created by 박종훈 on 2017. 1. 28..
//  Copyright © 2017년 박종훈. All rights reserved.
//

import UIKit

class MemeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    @IBOutlet weak var checkImageView: UIImageView!
    var origianlImage: UIImage = UIImage()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        checkImageView.isHidden = true
    }

    func setSelected() {
        origianlImage = imageView.image!
        imageView.image = maskImage(origianlImage)
        checkImageView.isHidden = false
    }
    
    func setDeSelected () -> Void {
        imageView.image = origianlImage
        checkImageView.isHidden = true
    }
    
    func maskImage(_ image: UIImage) -> UIImage{
        let rect = CGRect.init(x: 0, y: 0, width: image.size.width, height: image.size.height)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, image.scale)
        let c : CGContext = UIGraphicsGetCurrentContext()!
        image.draw(in: rect)
        c.setFillColor(UIColor.black.withAlphaComponent(0.5).cgColor)
        c.setBlendMode(CGBlendMode.sourceAtop)
        c.fill(rect)
        return UIGraphicsGetImageFromCurrentImageContext()!
    }
}
