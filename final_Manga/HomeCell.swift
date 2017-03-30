//
//  HomeCell.swift
//  final_Manga
//
//  Created by Godfather on 12/10/16.
//  Copyright © 2016 Godfather. All rights reserved.
//

import UIKit
import Kingfisher
class HomeCell: BaseCellCollection {
    
    
    ///////
    func getForCell(manga: Manga) {
        _nameLabel.text = manga.title // Gán tiêu đề
        _imageView.kf.indicatorType = .activity             // Use library kingfisher
        _imageView.kf.indicator?.startAnimatingView()       // Use library kingfisher
        // Use library kingfisher
        if let imgUrl = URL(string: manga.imgLink) {
            _imageView.kf.setImage(with: imgUrl, placeholder: #imageLiteral(resourceName: "placeholderManga"), options: [.transition(.fade(0.25))], progressBlock: nil, completionHandler: { [weak self](img, error, cacheType, url) in
                guard let `self` = self else { return }
                self._imageView.kf.indicator?.stopAnimatingView()  // Use library kingfisher
            })
        }
    }
    
    
    ///////
    let _imageView: UIImageView = {
        let img = UIImageView()
        img.backgroundColor = UIColor.clear
        return img
    }()
    func setup_imageView() {
        addSubview(_imageView)
        addConstraintWithVSF(format: "H:|[v0]|", views: _imageView)
        addConstraintWithVSF(format: "V:|[v0]|", views: _imageView)
    }
    
    let _viewBackground: UIView = {
        let viewbg = UIView()
        viewbg.backgroundColor = .clear
        return viewbg
    }()
    
    func setup_viewBackground() {
        addSubview(_viewBackground)
        addConstraintWithVSF(format: "H:|[v0]|", views: _viewBackground)
        addConstraintWithVSF(format: "V:[v0(30)]|", views: _viewBackground)
    }
    
    let _nameLabel: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        return lbl
    }()
    
    func setup_nameLabel() {
        _viewBackground.addSubview(_nameLabel)
        addConstraintWithVSF(format: "H:|[v0]|", views: _nameLabel)
        addConstraintWithVSF(format: "V:|[v0]|", views: _nameLabel)
    }
    override func setupInCell() {
        setup_imageView()
        setup_viewBackground()
        setup_nameLabel()
    }
}
