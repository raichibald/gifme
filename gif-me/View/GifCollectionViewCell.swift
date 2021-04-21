//
//  GifCell.swift
//  gif-me
//
//  Created by Raitis Saripo on 20/04/2021.
//

import UIKit
import Kingfisher

class GifCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var gifImageView: UIImageView!
    
    func loadGif(with gif: Gif) {
        if let gifURL = gif.images?.preview_gif?.url {
            gifImageView.kf.setImage(with: URL(string: gifURL))
        }
    }
    
    
}
