//
//  DetailCell.swift
//  final_Manga
//
//  Created by Godfather on 12/11/16.
//  Copyright © 2016 Godfather. All rights reserved.
//

import UIKit

class DetailCell: BaseCellCollection {
    
    //////
    func getForCell(shortDetail: ShortChapterDetail) {
        _nameLabel.text = shortDetail.chapterName
        _dateLabel.text = "\(formatDateToString(date: shortDetail.updatedDate))" // convert sang ngày tháng
    }
    //////
    override var isSelected: Bool {
        didSet {
            if isSelected {
                backgroundColor = rgbColor(red: 152, green: 210, blue: 230, alpha: 0.3)
            } else {
                backgroundColor = .white
            }
        }
    }
    ////
    let _nameLabel: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .left
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.numberOfLines = 0
        lbl.sizeToFit()
        return lbl
    }()
    
    let _dateLabel: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont.italicSystemFont(ofSize: 14)
        return lbl
    }()
    
    let seporator: UIView = {
        let sp = UIView()
        sp.backgroundColor = rgbColor(red: 42, green: 103, blue: 132, alpha: 1)
        sp.translatesAutoresizingMaskIntoConstraints = false
        return sp
    }()
    
    // Autolayout
    func setup_nameLabel() {
        addSubview(_nameLabel)
        _nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        _nameLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        _nameLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        _nameLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
    }
    
    func setup_dateLabel() {
        addSubview(_dateLabel)
        _dateLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        self.trailingAnchor.constraint(equalTo: _dateLabel.trailingAnchor, constant: 8).isActive = true
        _dateLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    func setup_seporator() {
        addSubview(seporator)
        seporator.topAnchor.constraint(equalTo: _nameLabel.bottomAnchor, constant: 8).isActive = true
        seporator.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1).isActive = true
        seporator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        seporator.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive = true
    }
    override func setupInCell() {
        backgroundColor = .white
        setup_nameLabel()
        setup_dateLabel()
        setup_seporator()
        
    }
}
