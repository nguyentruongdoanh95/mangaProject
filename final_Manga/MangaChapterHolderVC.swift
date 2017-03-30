//
//  MangaChapterHolderVC.swift
//  final_Manga
//
//  Created by Godfather on 12/12/16.
//  Copyright © 2016 Godfather. All rights reserved.
//

import UIKit
import Kingfisher

class MangaChapterHolderVC: UIViewController {
    
    // Khai báo biến
    var data: ShortChapterDetail!
    var pageView: ChapterPageViewController!  
    ////
    let _progessView: UIProgressView = {
        let pV = UIProgressView(progressViewStyle: .default)
        pV.translatesAutoresizingMaskIntoConstraints = false
        pV.progress = 0
        pV.tintColor = .green
        return pV
    }()
    
    let _containerView: UIView = {
        let cV = UIView()
        cV.translatesAutoresizingMaskIntoConstraints = false
        cV.backgroundColor = .clear
        return cV
    }()
    // Autolayout
    
    func setup_progessView() {
        view.addSubview(_progessView)
        _progessView.topAnchor.constraint(equalTo: view.topAnchor, constant: 64).isActive = true
        _progessView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        _progessView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
    }
    
    func setup_containerView() {
        view.addSubview(_containerView)
        _containerView.topAnchor.constraint(equalTo: _progessView.bottomAnchor, constant: 0).isActive = true
        _containerView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        _containerView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        _containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
    }
    // Next Screen
    class func newVC(data: ShortChapterDetail) -> MangaChapterHolderVC {
        let vc = MangaChapterHolderVC()
        vc.data = data
        return vc
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        print(data)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setup_progessView()
        setup_containerView()
        //
        self.pageView = ChapterPageViewController.newVC(data: data) // OOP
        self._containerView.addSubview(pageView.view)
        self.pageView.customDelegate = self
        pageView.view.frame = self._containerView.bounds
        pageView.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        pageView.didMove(toParentViewController: self)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Giải phóng bộ nhớ. Dùng library Kingfisher
    deinit {
        ImageCache.default.clearMemoryCache()
    }
   
}

// Adopted đến protocol ??
extension MangaChapterHolderVC: ChapterPageViewControllerDelegate {
    func updateTitle(pageView: ChapterPageViewController, title: String) {
        self.title = title // Gán title cho back button navigation
    }
    func finishLoadingChapterPage(pageView: ChapterPageViewController, current: Int, total: Int) {
        self._progessView.progress = Float((current + 1) / (total)) // Hiển thị tiến trình load dữ liệu về (số trang)
    }
}







