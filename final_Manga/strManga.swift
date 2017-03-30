//
//  strManga.swift
//  final_Manga
//
//  Created by Godfather on 12/10/16.
//  Copyright © 2016 Godfather. All rights reserved.
//

import Foundation
typealias JSONData = [String:Any]

struct Manga {
    var title:          String              // Tiêu đề viết hoa
    var alias:          String              // Tiêu đề viết thường
    var category:       Array<String> = []  // Thể loại
    var hits:           Int = 0
    var id:             String
    var imgLink:        String        = ""
    var lastedDate:     Date          = Date()
    var status:         Int           = 1
    
    
    init?(data: JSONData) {
        guard let title = data["t"] as? String else { return nil }
        guard let alias = data["a"] as? String else { return nil }
        guard let id    = data["i"] as? String else { return nil }
        
        self.title = title
        self.alias = alias
        self.id = id
        
        if let category = data["c"] as? [String] {
            self.category = category
        }
        
        if let hits = data["h"] as? Int {
            self.hits = hits
        }
        
      
        if let imgLink = data["im"] as? String, imgLink != "" {
            // https://cdn.mangaeden.com/mangasimg/imgLink
            self.imgLink = "\(hostImgLink)\(imgLink)"
        }
        
        if let lastedDateTimeInterval = data["ld"] as? TimeInterval {
            self.lastedDate = Date(timeIntervalSince1970: lastedDateTimeInterval)
        }
        
        if let status = data["s"] as? Int {
            self.status = status
        }
    }
}



