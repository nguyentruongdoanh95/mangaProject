//
//  strMangaImage.swift
//  final_Manga
//
//  Created by Godfather on 12/11/16.
//  Copyright © 2016 Godfather. All rights reserved.
//

import Foundation

struct ChapterImage {
    var chapterImageId: Int = 0
    var imgLink:String = ""
    var height: Int = 0
    var width: Int = 0
    
    init?(arr: [Any]) {
        guard arr.count > 0 else {return nil}
        for i in 0..<arr.count {
            switch i {
            case 0:
                guard let chapterImageId = arr[i] as? Int else {return nil}
                self.chapterImageId = chapterImageId
            case 1:
                if let imgLink = arr[i] as? String {
                    self.imgLink = "\(hostImgLink)\(imgLink)"
                }
            case 2:
                if i == 2 {
                    guard let width = arr[i] as? Int else { return nil }
                    self.width = width
                }
            default:
                guard let height = arr[i] as? Int else { return nil }
                self.height = height
            }
        }
    }
}
