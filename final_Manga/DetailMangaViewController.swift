//
//  DetailMangaViewController.swift
//  final_Manga
//
//  Created by Godfather on 12/10/16.
//  Copyright © 2016 Godfather. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher

class DetailMangaViewController: UIViewController {
    
    // Khai báo biến
    var id: String!
    var mangaDetail: MangaDetail?
    
    //// Khai báo mọi thứ trong view 1
    let _viewOne: UIView = {
        let v1 = UIView()
        v1.translatesAutoresizingMaskIntoConstraints = false
        v1.backgroundColor = rgbColor(red: 58, green: 119, blue: 164, alpha: 0.3)
        return v1
    }()
    
    let _imageView: UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.backgroundColor = .clear
        return img
    }()
    
    let _authorLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Author :"
        lbl.textColor = .gray
        lbl.textAlignment = .center
        lbl.font = UIFont.boldSystemFont(ofSize: 14)
        return lbl
    }()
    
    let _createdLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Created :"
        lbl.textAlignment = .center
        lbl.textColor = .gray
        lbl.font = UIFont.boldSystemFont(ofSize: 14)
        return lbl
    }()
    
    let _chaptersLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Chapters :"
        lbl.textAlignment = .center
        lbl.textColor = .gray
        lbl.font = UIFont.boldSystemFont(ofSize: 14)
        return lbl
    }()
    
    let _categoriesLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Categories :"
        lbl.textAlignment = .center
        lbl.textColor = .gray
        lbl.font = UIFont.boldSystemFont(ofSize: 14)
        return lbl
    }()
    
    /// Content
    let _authorContent: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont.italicSystemFont(ofSize: 14)
        return lbl
    }()
    
    let _createdContent: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont.italicSystemFont(ofSize: 14)
        return lbl
    }()
    
    let _chaptersContent: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont.italicSystemFont(ofSize: 14)
        return lbl
    }()
    
    let _categoriesContent: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont.italicSystemFont(ofSize: 14)
        lbl.numberOfLines = 0
        return lbl
    }()
    
    //// Khai báo mọi thứ trong view 2
    let _viewTwo: UIView = {
        let v2 = UIView()
        v2.translatesAutoresizingMaskIntoConstraints = false
        return v2
    }()
    
    lazy var _btnSegmented: UISegmentedControl = {
        let btnSM = UISegmentedControl(items: ["Description", "Chapter"])
        //btnSM.selectedSegmentIndex = 0
        btnSM.translatesAutoresizingMaskIntoConstraints = false
        btnSM.addTarget(self, action: #selector(changeView), for: .valueChanged)
        return btnSM
    }()
    //// Khai báo mọi thứ trong view 3
    let _viewThree: UIView = {
        let v3 = UIView()
        v3.translatesAutoresizingMaskIntoConstraints = false
        v3.backgroundColor = .clear
        return v3
    }()
    
    let _descriptionView: UITextView = {
        let desView = UITextView(frame: .zero, textContainer: nil)
        return desView
    }()
    
    lazy var _collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let myColl = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.scrollDirection = .vertical
        // layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 0
        myColl.translatesAutoresizingMaskIntoConstraints = false
        myColl.register(DetailCell.self, forCellWithReuseIdentifier: "CellOne")
        myColl.backgroundColor = UIColor.white
        myColl.dataSource = self
        myColl.delegate = self
        return myColl
    }()
    
    ///////////// AutoLayout
    
    func setup_viewOneTwoThree() {
        view.addSubview(_viewOne)
        _viewOne.topAnchor.constraint(equalTo: view.topAnchor, constant: 64).isActive = true
        _viewOne.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        _viewOne.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1).isActive = true
        _viewOne.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/3).isActive = true
        
        view.addSubview(_viewTwo)
        _viewTwo.topAnchor.constraint(equalTo: _viewOne.bottomAnchor, constant: 0).isActive = true
        _viewTwo.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        _viewTwo.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1).isActive = true
        _viewTwo.heightAnchor.constraint(equalTo: _viewOne.heightAnchor, multiplier: 1/4).isActive = true
        
        view.addSubview(_viewThree)
        _viewThree.topAnchor.constraint(equalTo: _viewTwo.bottomAnchor, constant: 0).isActive = true
        _viewThree.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        _viewThree.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1).isActive = true
        _viewThree.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
    }
    
    func setup_imageView() {
        _viewOne.addSubview(_imageView)
        _imageView.topAnchor.constraint(equalTo: _viewOne.topAnchor, constant: 8).isActive = true
        _imageView.leftAnchor.constraint(equalTo: _viewOne.leftAnchor, constant: 8).isActive = true
        _imageView.bottomAnchor.constraint(equalTo: _viewOne.bottomAnchor, constant: -8).isActive = true
        _imageView.widthAnchor.constraint(equalTo: _viewOne.widthAnchor, multiplier: 3/8).isActive = true
    }
    
    func setup_AllLabel(){
        _viewOne.addSubview(_authorLabel)
        _viewOne.addSubview(_createdLabel)
        _viewOne.addSubview(_chaptersLabel)
        _viewOne.addSubview(_categoriesLabel)
        _viewOne.addConstraintWithVSF(format: "V:|-12-[v0(25)]-2-[v1(25)]-2-[v2(25)]-2-[v3(25)]", views: _authorLabel, _createdLabel, _chaptersLabel,_categoriesLabel)
        _authorLabel.leftAnchor.constraint(equalTo: _imageView.rightAnchor, constant: 8).isActive = true
        _createdLabel.leadingAnchor.constraint(equalTo: _authorLabel.leadingAnchor, constant: 0).isActive = true
        _chaptersLabel.leadingAnchor.constraint(equalTo: _authorLabel.leadingAnchor, constant: 0).isActive = true
        _categoriesLabel.leadingAnchor.constraint(equalTo: _authorLabel.leadingAnchor, constant: 0).isActive = true
    }
    
    func setup_AllContent() {
        _viewOne.addSubview(_authorContent)
        _authorContent.centerYAnchor.constraint(equalTo: _authorLabel.centerYAnchor, constant: 0).isActive = true
        _authorContent.leadingAnchor.constraint(equalTo: _authorLabel.trailingAnchor, constant: 4).isActive = true
        _viewOne.trailingAnchor.constraint(greaterThanOrEqualTo: _authorContent.trailingAnchor, constant: 4).isActive = true
        
        _viewOne.addSubview(_createdContent)
        _createdContent.centerYAnchor.constraint(equalTo: _createdLabel.centerYAnchor, constant: 0).isActive = true
        _createdContent.leadingAnchor.constraint(equalTo: _createdLabel.trailingAnchor, constant: 4).isActive = true
        _viewOne.trailingAnchor.constraint(greaterThanOrEqualTo: _createdContent.trailingAnchor, constant: 4).isActive = true
        
        _viewOne.addSubview(_chaptersContent)
        _chaptersContent.centerYAnchor.constraint(equalTo: _chaptersLabel.centerYAnchor, constant: 0).isActive = true
        _chaptersContent.leadingAnchor.constraint(equalTo: _chaptersLabel.trailingAnchor, constant: 4).isActive = true
        _viewOne.trailingAnchor.constraint(greaterThanOrEqualTo: _chaptersContent.trailingAnchor, constant: 4).isActive = true
        
        _viewOne.addSubview(_categoriesContent)
        _categoriesContent.leadingAnchor.constraint(equalTo: _categoriesLabel.trailingAnchor, constant: 4).isActive = true
        _viewOne.trailingAnchor.constraint(greaterThanOrEqualTo: _categoriesContent.trailingAnchor, constant: 4).isActive = true
        _categoriesContent.topAnchor.constraint(equalTo: _categoriesLabel.topAnchor).isActive = true
    }
    
    
    func setup_btnSegmented() {
        _viewTwo.addSubview(_btnSegmented)
        _viewTwo.trailingAnchor.constraint(equalTo: _btnSegmented.trailingAnchor, constant: 25).isActive = true
        _btnSegmented.leadingAnchor.constraint(equalTo: _viewTwo.leadingAnchor, constant: 25).isActive = true
        _btnSegmented.topAnchor.constraint(equalTo: _viewTwo.topAnchor, constant: 8).isActive = true
        _viewTwo.bottomAnchor.constraint(equalTo: _btnSegmented.bottomAnchor, constant: 8).isActive = true
    }
    
    func setup_descriptionView() {
        _viewThree.addSubview(_descriptionView)
        _viewThree.addConstraintWithVSF(format: "H:|[v0]|", views: _descriptionView)
        _viewThree.addConstraintWithVSF(format: "V:|[v0]|", views: _descriptionView)
    }
    
    
    func setup_collectionView() {
        _viewThree.addSubview(_collectionView)
        _viewThree.addConstraintWithVSF(format: "H:|[v0]|", views: _collectionView)
        _viewThree.addConstraintWithVSF(format: "V:|[v0]|", views: _collectionView)
    }
    
    // Chạy chương trình
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        getDataForAPI() // Load data
        print(id)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        _btnSegmented.selectedSegmentIndex = 1  // Mặc định khi chạy là nút index 1 (Chapter)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setup_viewOneTwoThree()
        setup_imageView()
        setup_AllLabel()
        setup_AllContent()
        setup_btnSegmented()
        setup_descriptionView()
        setup_collectionView()
        
        _collectionView.layer.zPosition = 1     // dữ liệu nút index 1 (Chapter)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getDataForAPI() {
        guard let id = self.id else { return }
        self.startLoading()         // Animation loading
        Alamofire.request("\(apiHost)manga/\(id)").responseJSON { (response) in
            if let data = response.result.value as? JSONData {
                if let mangaDetail = MangaDetail(data: data) {
                    self.title = mangaDetail.title // Gán title trên navigation
                    self.mangaDetail = mangaDetail
                    self.setupScreen()
                    self._collectionView.reloadData()
                    self.stopLoading()   // Animation loading
                }
            }
        }
    }
    
    // Setup hiển thị trên màn hình
    func setupScreen() {
        guard let mangaDetail = self.mangaDetail else { return }
        _authorContent.text = mangaDetail.author
        _createdContent.text = formatDateToString(date: mangaDetail.createdDate) // convert sang ngày tháng
        _chaptersContent.text = "\(mangaDetail.shortChapterDetail.count)" // Tổng số chap
        _categoriesContent.text = mangaDetail.categories.joined(separator: ", ") // joined ? Chuyển mảng thành String qua kí tự input
        
        _descriptionView.text = mangaDetail.description
        // Dùng kingfisher
        _imageView.kf.indicatorType = .activity
        _imageView.kf.indicator?.startAnimatingView()
        
        guard let imgUrl = URL(string: mangaDetail.imageLink) else { return }
        _imageView.kf.setImage(with: imgUrl, placeholder: #imageLiteral(resourceName: "placeholderManga"), options: [.transition(.fade(0.25))], progressBlock: nil, completionHandler: nil)
    }
    
    
    // Dữ liệu trong segmentedControl
    func changeView() {
        if _btnSegmented.selectedSegmentIndex == 0 {
            _collectionView.layer.zPosition = 0
            _descriptionView.layer.zPosition = 1
        } else {
            _collectionView.layer.zPosition = 1
            _descriptionView.layer.zPosition = 0
        }
    }
}

extension DetailMangaViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mangaDetail != nil ? (mangaDetail?.shortChapterDetail.count)! : 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellOne", for: indexPath) as! DetailCell
        guard let mangaDetail = self.mangaDetail else { return cell}
        if mangaDetail.shortChapterDetail.count <= 0 || mangaDetail.shortChapterDetail.count < indexPath.row { return cell }
        let shortDetail = mangaDetail.shortChapterDetail[indexPath.row]
        
        
        cell.getForCell(shortDetail: shortDetail) // Configure for cell file
        return cell
    }
}

extension DetailMangaViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    // Chuyển sang screen tiếp theo
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self ._collectionView.layer.zPosition == 0 { return }
        guard let mangaDetail = self.mangaDetail else { return }
        let vc = MangaChapterHolderVC.newVC(data: mangaDetail.shortChapterDetail[indexPath.item]) // OOP
        navigationController?.pushViewController(vc, animated: true)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.size.width, height: 50)
    }
}



























