//
//  ChapterPageViewController.swift
//  final_Manga
//
//  Created by Godfather on 12/12/16.
//  Copyright © 2016 Godfather. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher

protocol ChapterPageViewControllerDelegate: class {
    func updateTitle(pageView: ChapterPageViewController, title: String)
    
    func finishLoadingChapterPage(pageView: ChapterPageViewController, current: Int, total: Int)
}

class ChapterPageViewController: UIPageViewController {
    
    // Khai báo biến
    weak var customDelegate:    ChapterPageViewControllerDelegate?
    var shortChapter:           ShortChapterDetail?
    var isFirstLoading = true
    var chapterImageList:       Array<ChapterImage> = []
    var imgPrefetcher:          ImagePrefetcher?
    var shadowBarImg:           UIImage?
    var barBackgroundColor:     UIColor?
    var backgroundBarImg:       UIImage?
    ////
    class func newVC(data: ShortChapterDetail) -> ChapterPageViewController{
        let vc = ChapterPageViewController()
        vc.shortChapter = data
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let shortChapter = shortChapter else { return }
        if isFirstLoading {
            self.startLoading()
            Alamofire.request("\(apiHost)chapter/\(shortChapter.chapterId)").responseJSON(completionHandler: { (response) in
                if let data = response.result.value as? JSONData {
                    if let images = data["images"] as? [[Any]], images.count > 0 {
                        for item in images {
                            if let chapterImage = ChapterImage(arr: item){
                                self.chapterImageList.append(chapterImage)
                            }
                        }
                        if self.chapterImageList.count > 0 {
                            self.preloadImgs(form: 0, limit: 3)
                        }
                        self.updateTitle(currentIndex: 1)
                        if self.chapterImageList.count == 0 {
                            self.stopLoading()
                            return
                        }
                        self.chapterImageList = self.chapterImageList.reversed()
                        self.dataSource = self
                        self.delegate   = self
                        self.setFirstPage()
                    }
                }
                self.stopLoading()
            })
            isFirstLoading = false
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        backgroundBarImg = self.navigationController?.navigationBar.backgroundImage(for: .default)
        shadowBarImg = self.navigationController?.navigationBar.shadowImage
        barBackgroundColor = self.navigationController?.navigationBar.backgroundColor
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.backgroundColor = UIColor.init(white: 0.3, alpha: 0.4)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.navigationBar.setBackgroundImage(backgroundBarImg, for: .default)
        self.navigationController?.navigationBar.shadowImage = shadowBarImg
        self.navigationController?.navigationBar.backgroundColor = barBackgroundColor
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setFirstPage() {
        let beforeVC = ChapterViewController()
        beforeVC.index = 0
        
        let chapterImg = chapterImageList[beforeVC.index]
        beforeVC.chapterImage = chapterImg
        self.setViewControllers([beforeVC], direction: .forward, animated: false, completion: nil)
    }
    
    
    
    func createNewChapterView(currentVC: UIViewController, isNextPage: Bool) -> UIViewController? {
        let currentVC = currentVC as! ChapterViewController
        let index = currentVC.index
        let newVC = ChapterViewController()
        
        if isNextPage {
            if index == self.chapterImageList.count - 1 {return nil}
            newVC.index = index + 1
        } else {
            if index == 0 {return nil}
            newVC.index = index - 1
        }
        
        let chapterImg = chapterImageList[newVC.index]
        newVC.chapterImage = chapterImg
        
        return newVC
    }
    
    func updateTitle(currentIndex: Int) {
        customDelegate?.updateTitle(pageView: self, title: "\(currentIndex)/\(chapterImageList.count)")
    }
    
    
    // Preload image for UI
    func preloadImgs(form index: Int, limit: Int) {
        if index >= chapterImageList.count { return }
        // Nếu start index + to index > số phần tử của mảng thì lấy cái cuối index cuối làm to index
        let toIndex = (index + limit) >= chapterImageList.count ? (chapterImageList.count - 1) : (index + limit)
        let subUrl = chapterImageList[index...toIndex]
        // Chuyển hóa mỗi phần tử trong subUrls thành ImageResource
        let imgURLs = subUrl.map({(item) -> ImageResource in
            return ImageResource(downloadURL: URL(string: item.imgLink) ?? URL(string: "")!)
        })
        self.imgPrefetcher = nil
        self.imgPrefetcher = ImagePrefetcher(resources: imgURLs, options: nil, progressBlock: { (skipedURLs, failedURLs, completedURLs) in
            //
        }, completionHandler: { [weak self] (skipedURLs, failedURLs, completedURLs) in
            guard let `self` = self else { return }
            self.customDelegate?.finishLoadingChapterPage(pageView: self, current: toIndex, total: (self.chapterImageList.count))
             // Đệ quy gọi tăng from index
            self.preloadImgs(form: toIndex + 1, limit: limit)
        })
        self.imgPrefetcher?.start()
    }
    
}



extension ChapterPageViewController : UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return createNewChapterView(currentVC: viewController, isNextPage: false)
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return createNewChapterView(currentVC: viewController, isNextPage: true)
    }
}

extension ChapterPageViewController : UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            guard let currentVC = pageViewController.viewControllers?.first as? ChapterViewController else {
                return
            }
            self.updateTitle(currentIndex: currentVC.index + 1)
        }
    }
}

