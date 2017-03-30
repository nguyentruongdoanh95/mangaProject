//
//  HomeViewController.swift
//  final_Manga
//
//  Created by Godfather on 12/10/16.
//  Copyright © 2016 Godfather. All rights reserved.
//

import UIKit
import Alamofire

class HomeViewController: UIViewController {
    
    // Khai báo biến
    var mangaList:Array<Manga> = []
    var page = 0
    var refreshing = UIRefreshControl()
    var isLoading = false
    var isFirstLoading = true // Flag cho chương trình load lần đầu tiên
    
    // Tạo collectionView
    lazy var _collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let myColl = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 3
        myColl.translatesAutoresizingMaskIntoConstraints = false // autolayout use code bắt buộc phải có dòng này
        myColl.register(HomeCell.self, forCellWithReuseIdentifier: "HomeCell") // Đăng kí Cell
        myColl.backgroundColor = rgbColor(red: 152, green: 210, blue: 230, alpha: 1)
        myColl.dataSource = self
        myColl.delegate = self
        return myColl
    }()
    // AutoLayout
    func setup_collectionView() {
        view.addSubview(_collectionView)
        let top = NSLayoutConstraint(item: _collectionView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0)
        let bottom = NSLayoutConstraint(item: _collectionView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        let left = NSLayoutConstraint(item: _collectionView, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: 0)
        let right = NSLayoutConstraint(item: _collectionView, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1, constant: 0)
        view.addConstraints([top, bottom, left, right])
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Home"
        setup_collectionView()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil) // change title back button NAV
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Kiểm tra cho chương trình load 1 lần
        if isFirstLoading {
            getDataForAPI()
            isFirstLoading = false
        }
    }
    
    // Hàm lấy dữ liệu API
    func getDataForAPI() {
        self.mangaList.removeAll()              // Xóa mọi phần tử trước khi load data
        self.startLoading()                     // Animation loading
        Alamofire.request("\(apiHost)list/0/?p=\(page)&l=30", method: .get).responseJSON { (response) in
            // [JSONData] == Array<Dictionary<String, Any>>
            if let data = response.result.value as? JSONData {
                if let mangaListData = data["manga"] as? [JSONData], mangaListData.count > 0 {
                    for mangaData in mangaListData {
                        if let manga = Manga(data: mangaData){
                            self.mangaList.append(manga)  // Append phần tử vào mảng
                        }
                    }
                    self._collectionView.reloadData()
                    self.isLoading = false
                    self.stopLoading()          // Anmation loading
                }
            } else {
                self.stopLoading()
                self.noticeError("Error", autoClear: true, autoClearTime: 3)
            }
        }
        
    }
    // LoadMore
    func loadMore() {
        page += 1
        self.startLoading()                     // Animation loading
        Alamofire.request("\(apiHost)list/0/?p=\(page)&l=30", method: .get).responseJSON { (response) in
            self.isLoading = true
            if let data = response.result.value as? JSONData {
                if let mangaListData = data["manga"] as? [JSONData], mangaListData.count > 0 {
                    for mangaData in mangaListData {
                        if let manga = Manga(data: mangaData){
                            self.mangaList.append(manga)  // Append phần tử vào mảng
                        }
                    }
                    print(self.mangaList)
                    self._collectionView.reloadData()
                }
            } else {
                self.page -= 1  // disconnected case
            }
            
            self.isLoading = false
            self.stopLoading()              // Animation loading
        }
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

extension HomeViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mangaList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCell", for: indexPath) as! HomeCell
        cell.getForCell(manga: mangaList[indexPath.item]) // Configure for Cell file
        return cell
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (view.frame.width / 3) - 1, height: 180)
    }
    
    // Chọn Cell sang screen tiếp theo
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailVC =  DetailMangaViewController()
        detailVC.id = mangaList[indexPath.item].id      // Lấy id nào đc chọn trước khi chuyển
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if refreshing.isRefreshing {
            page = 0
            self.getDataForAPI()
            self.refreshing.endRefreshing()
        }
        if isLoading { return }
        
        let offSetY = scrollView.contentOffset.y             // Coordinates khi cuộn chiều y
        let heightOfContent = scrollView.contentSize.height  // Height nội dung
        if heightOfContent - offSetY - scrollView.bounds.size.height <= 1 {
            // Loadmore
            self.loadMore()
        }
    }
}



/// ANIMATION LOADING
extension UIViewController {
    func startLoading() {
        self.pleaseWait()
        self.view.isUserInteractionEnabled = false
    }
    
    func stopLoading() {
        self.clearAllNotice()
        self.view.isUserInteractionEnabled = true
    }
}

extension UIView {
    func startLoading() {
        self.pleaseWait()
        self.isUserInteractionEnabled = false
    }
    
    func stopLoading() {
        self.clearAllNotice()
        self.isUserInteractionEnabled = true
    }
}
