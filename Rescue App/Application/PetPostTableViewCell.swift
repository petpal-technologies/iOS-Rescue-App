//
//  PetPostTableViewCell.swift
//  Rescue App
//
//  Created by Christopher Horton on 1/30/19.
//  Copyright © 2019 Unikorn. All rights reserved.
//

import UIKit

class PetPostTableViewCell: UITableViewCell {
    
    var postTitle: String?
    var postDescription: String?
    var postImage: UIImage?
    
    var titleLabel: UILabel = {
        var titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()
    
    var descriptionLabel: UILabel = {
        var descLabel = UILabel()
        descLabel.translatesAutoresizingMaskIntoConstraints = false
        return descLabel
    }()
    
    var postImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
    let containerView:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        containerView.addSubview(titleLabel)
        containerView.addSubview(descriptionLabel)
        self.addSubview(postImageView)
        self.addSubview(containerView)
        
        
        postImageView.leadingAnchor.constraint(equalTo:self.leadingAnchor, constant:10).isActive = true
        postImageView.widthAnchor.constraint(equalToConstant:225).isActive = true
        postImageView.heightAnchor.constraint(equalToConstant: 225).isActive = true
        postImageView.topAnchor.constraint(equalTo: self.containerView.bottomAnchor, constant: 10).isActive = true

        containerView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        containerView.leadingAnchor.constraint(equalTo:self.leadingAnchor, constant:10).isActive = true
        containerView.trailingAnchor.constraint(equalTo:self.trailingAnchor, constant:-10).isActive = true
        containerView.heightAnchor.constraint(equalToConstant:40).isActive = true
        
        
        titleLabel.topAnchor.constraint(equalTo:self.containerView.topAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo:self.containerView.leadingAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo:self.containerView.trailingAnchor).isActive = true
        
        
        descriptionLabel.topAnchor.constraint(equalTo:self.titleLabel.bottomAnchor).isActive = true
        descriptionLabel.leadingAnchor.constraint(equalTo:self.containerView.leadingAnchor).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo:self.titleLabel.bottomAnchor).isActive = true
        descriptionLabel.leadingAnchor.constraint(equalTo:self.containerView.leadingAnchor).isActive = true

        
    }
   
    override func layoutSubviews() {
        super.layoutSubviews()
        if let postTitle = postTitle {
            titleLabel.text = postTitle
        }
        
        if let postDescription = postDescription {
            descriptionLabel.text = postDescription
        }
        
        if let postImage = postImage {
            postImageView.image = postImage
        }
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
