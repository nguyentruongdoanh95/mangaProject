//
//  ForAPI.swift
//  final_Manga
//
//  Created by Godfather on 12/10/16.
//  Copyright © 2016 Godfather. All rights reserved.
//

import UIKit

let apiHost     = "http://www.mangaeden.com/api/"
let hostImgLink = "https://cdn.mangaeden.com/mangasimg/"

let screenWidth = UIScreen.main.bounds.size.width
let screenHeight = UIScreen.main.bounds.size.height

// Chuyển kiểu Date sang String
func formatDateToString(date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd / MM / YYYY"
    return dateFormatter.string(from: date)
}
