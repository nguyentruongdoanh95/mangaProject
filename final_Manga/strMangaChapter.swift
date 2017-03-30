//
//  strMangaChapter.swift
//  final_Manga
//
//  Created by Godfather on 12/11/16.
//  Copyright © 2016 Godfather. All rights reserved.
//

import Foundation

struct ShortChapterDetail {
    var chapterNumber:  Int = 0
    var updatedDate:    Date = Date()
    var chapterName:    String = "" // Tên của chapter
    var chapterId:      String = ""
    
    init?(arr: [Any]) {
        guard arr.count > 0 else {return nil}
        for i in 0..<arr.count {
            switch i {
            case 0:
                guard let chapterNumber = arr[i] as? Int else {return nil}
                self.chapterNumber = chapterNumber
            case 1:
                if let updatedDateTimeInterval = arr[i] as? TimeInterval {
                    let updatedDate = Date(timeIntervalSince1970: updatedDateTimeInterval)
                    self.updatedDate = updatedDate
                }
            case 2:
                if let chapterName = arr[i] as? String {
                    self.chapterName = "Chapter \(chapterName)"
                } else {
                    self.chapterName = "Chapter ..."
                }
            default:
                guard let chapterId = arr[i] as? String else {return nil}
                self.chapterId = chapterId
            }
        }
    }
}

