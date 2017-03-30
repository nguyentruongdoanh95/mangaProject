//
//  strMangaDetail.swift
//  final_Manga
//
//  Created by Godfather on 12/11/16.
//  Copyright © 2016 Godfather. All rights reserved.
//

import Foundation


struct MangaDetail {
    
    var author:             String                  // Tác giả
    var shortChapterDetail: [ShortChapterDetail] = [ShortChapterDetail]() // Số tập
    var chaptersLen:        Int = 0                 // Có bao nhiêu tập ?
    var createdDate:        Date = Date()           // Ngày
    var hits:               Int = 0
    var imageLink:          String = " "            // Hình thumbnail
    var lastChapterDateTimeInterval: Date = Date()  // Tập gần nhất
    var title:          String                      // Tựa đề
    var categories:     [String] = [String]()       // Thể loại
    var description:    String = "Đang Cập Nhật"    // Mô tả
    
    init?(data: JSONData) {
        guard let author    = data["author"]    as? String else { return nil }
        guard let title     = data["title"]     as? String else { return nil }
        
        self.author = author
        self.title  = title
        
        if let chaptersArr = data["chapters"] as? [Any], chaptersArr.count > 0 {
            for i in 0..<chaptersArr.count {
                guard let shortChapterDetailArr = chaptersArr[i] as? [Any] else { continue }
                
                if let shortChapterDetail = ShortChapterDetail(arr: shortChapterDetailArr) {
                    self.shortChapterDetail.append(shortChapterDetail)
                }
            }
        }
        
        if let chaptersLen = data["chapters_len"] as? Int {
            self.chaptersLen = chaptersLen
        }
        
        if let createdDateTimeInterval = data["created"] as? TimeInterval {
            self.createdDate = Date(timeIntervalSince1970: createdDateTimeInterval)
        }
        
        if let hits = data["hits"] as? Int {
            self.hits = hits
        }
        
        if let description = data["description"] as? String {
            self.description = description
        }
        
        if let imgLink = data["image"] as? String {
            self.imageLink = "\(hostImgLink)\(imgLink)"
        }
        
        if let lastChapterDateTimeInterval = data["last_chapter_date"] as? TimeInterval {
            self.lastChapterDateTimeInterval = Date(timeIntervalSince1970: lastChapterDateTimeInterval)
        }
        
        if let categories = data["categories"] as? [String] {
            self.categories = categories
        }
        
    }
}
