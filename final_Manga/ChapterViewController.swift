//
//  ChapterViewController.swift
//  final_Manga
//
//  Created by Godfather on 12/12/16.
//  Copyright © 2016 Godfather. All rights reserved.
//

import UIKit
import Kingfisher

class ChapterViewController: UIViewController {
    
    // Khai báo biến
    var chapterImageView: UIImageView!
    var index:Int = 0
    var chapterImage:ChapterImage!
    var isFirstLoad = true
    var containerHeight:CGFloat {
        return _scrollView.bounds.size.height
    }
    ////
    let _viewBackground: UIView = {
        let bg = UIView()
       // bg.backgroundColor = .clear
        return bg
    }()
    
    let _scrollView: UIScrollView = {
        let sc = UIScrollView()
        //sc.backgroundColor = .clear
        return sc
    }()
    
    //// Autolayout
    
    func setup_viewBackground() {
        view.addSubview(_viewBackground)
        view.addConstraintWithVSF(format: "H:|[v0]|", views: _viewBackground)
        view.addConstraintWithVSF(format: "V:|[v0]|", views: _viewBackground)
    }
    
    func setup_scrollView() {
        _viewBackground.addSubview(_scrollView)
        _viewBackground.addConstraintWithVSF(format: "H:|[v0]|", views: _scrollView)
        _viewBackground.addConstraintWithVSF(format: "V:|[v0]|", views: _scrollView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _scrollView.delegate = self
        
        let sizeImageScaleFollowScreenWidth = CGSize(width: screenWidth, height: getNewHeight())
        chapterImageView = createImageView(size: sizeImageScaleFollowScreenWidth)
        
        guard let imgURL = URL(string: chapterImage.imgLink) else {return}
        _scrollView.addSubview(chapterImageView)
        ImageCache.default.retrieveImage(forKey: chapterImage.imgLink, options: nil) { [weak self]
            image, cacheType in
            if let image = image {
                
                self?.chapterImageView.image = image
                
            } else {
                
                self?.chapterImageView.kf.indicatorType = .activity
                
                self?.chapterImageView.kf.setImage(with: imgURL, placeholder: nil, options: [.transition(.fade(0.25))], completionHandler: { (img, error, type, url) in
                    if img != nil {
                        self?.chapterImageView.kf.indicator?.stopAnimatingView()
                        self?.stopLoading()
                    }
                    
                })
                
                
            }
            self?.setScrollViewSizeMatchWithImageAfterScaleFollowScreenSize()
        }
        
        _scrollView.minimumZoomScale = 1.0
        _scrollView.maximumZoomScale = 10.0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setup_viewBackground()
        setup_scrollView()
        if !isFirstLoad {
            return
        }
        isFirstLoad = false
        
        self.setScrollViewSizeMatchWithImageAfterScaleFollowScreenSize()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func setScrollViewSizeMatchWithImageAfterScaleFollowScreenSize() {
        
        
        _scrollView.contentSize = CGSize(width: screenWidth, height: getNewHeight())
        
        if getNewHeight() < containerHeight {
            self.chapterImageView.contentMode = .scaleAspectFit
        }
        
        self.chapterImageView.frame.size = self._scrollView.contentSize
    }
    
    
    func createImageView(size: CGSize) -> UIImageView {
        let point = CGPoint.zero
        let imageView = UIImageView(frame: CGRect(origin: point, size: size))
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }
    
    func getNewHeight() -> CGFloat {
        return CGFloat(chapterImage.height) * screenWidth / CGFloat(chapterImage.width)
    }
}



extension ChapterViewController : UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        
        return self.chapterImageView
    }
}







