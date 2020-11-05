//
//  CustomViewCell.swift
//  RSSNewsTask
//
//  Created by Геннадий Махмудов on 03.11.2020.
//

import UIKit

class CustomViewCell: UITableViewCell {
    
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.text = "Sample Text"
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let detailLabel: UILabel = {
        let label = UILabel()
        label.text = "Sample Text"
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(titleLabel)
        addSubview(detailLabel)
        
        addConstraintsWithFormat(format: "V:|-8-[v0]-4-[v1]-8-|", views: titleLabel, detailLabel)
        addConstraintsWithFormat(format: "H:|-8-[v0]-|", views: titleLabel)
        addConstraintsWithFormat(format: "H:|-10-[v0]-|", views: detailLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

