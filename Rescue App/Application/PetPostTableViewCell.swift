//
//  PetPostTableViewCell.swift
//  Rescue App
//
//  Created by Christopher Horton on 1/30/19.
//  Copyright © 2019 Unikorn. All rights reserved.
//

import UIKit
import MessageUI
class PetPostTableViewCell: UITableViewCell  {
    
    var post: PetPost?
    var delegate:EmailDelegator!
    
    var titleLabel: UILabel = {
        var titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
        return titleLabel
    }()
    
    var dateLabel: UILabel = {
        var dateLabel = UILabel()
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.font = dateLabel.font.withSize(15)
        return dateLabel
    }()
    
    var descriptionLabel: UILabel = {
        var descLabel = UILabel()
        descLabel.translatesAutoresizingMaskIntoConstraints = false
        descLabel.font = descLabel.font.withSize(15)
        return descLabel
    }()
    
    var statusImage: UIImageView = {
        var imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    var checkmarkImage: UIImageView = {
        var imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    } ()
    
    var postImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
    var detailsImageView: UIImageView = {
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
//        containerView.addSubview(statusImage)
        self.addSubview(postImageView)
        self.addSubview(containerView)
        self.addSubview(statusImage)
        self.addSubview(checkmarkImage)
        self.addSubview(detailsImageView)
        self.addSubview(dateLabel)
        
        containerView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        containerView.leadingAnchor.constraint(equalTo:self.leadingAnchor, constant:10).isActive = true
        containerView.trailingAnchor.constraint(equalTo:self.trailingAnchor, constant:-10).isActive = true
        containerView.heightAnchor.constraint(equalToConstant:50).isActive = true
        
        titleLabel.topAnchor.constraint(equalTo:self.containerView.topAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo:self.containerView.leadingAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo:self.containerView.trailingAnchor).isActive = true
        
        descriptionLabel.topAnchor.constraint(equalTo:self.titleLabel.bottomAnchor).isActive = true
        descriptionLabel.leadingAnchor.constraint(equalTo:self.containerView.leadingAnchor).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo:self.titleLabel.bottomAnchor).isActive = true
        descriptionLabel.leadingAnchor.constraint(equalTo:self.containerView.leadingAnchor).isActive = true
        
        postImageView.leadingAnchor.constraint(equalTo:self.leadingAnchor, constant:10).isActive = true
        postImageView.widthAnchor.constraint(equalToConstant:225).isActive = true
        postImageView.heightAnchor.constraint(equalToConstant: 225).isActive = true
        postImageView.topAnchor.constraint(equalTo: self.containerView.bottomAnchor, constant: 10).isActive = true

        statusImage.topAnchor.constraint(equalTo:self.postImageView.bottomAnchor).isActive = true
        statusImage.leadingAnchor.constraint(equalTo:self.leadingAnchor, constant:10).isActive = true
        statusImage.widthAnchor.constraint(equalToConstant:50).isActive = true
        statusImage.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        checkmarkImage.topAnchor.constraint(equalTo:self.postImageView.bottomAnchor, constant:5).isActive = true
        checkmarkImage.leadingAnchor.constraint(equalTo: statusImage.trailingAnchor).isActive = true
        checkmarkImage.widthAnchor.constraint(equalToConstant:40).isActive = true
        checkmarkImage.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        detailsImageView.widthAnchor.constraint(equalToConstant:30).isActive = true
        detailsImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        detailsImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -50).isActive = true
        detailsImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true

        dateLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        dateLabel.trailingAnchor.constraint(equalTo:self.trailingAnchor, constant:-10).isActive = true
        dateLabel.centerYAnchor.constraint(equalTo: self.postImageView.bottomAnchor, constant: 25).isActive = true
        
        // MARK: Tap gesture to change status of animal
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(tapDetected))
        statusImage.isUserInteractionEnabled = true
        statusImage.addGestureRecognizer(singleTap)
        
        checkmarkImage.isUserInteractionEnabled = true
        checkmarkImage.addGestureRecognizer(singleTap)
    }
    
    @objc func tapDetected() {
        
        self.delegate.email(postID: (post?.id)!)
    }

   
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let _post = post {
            titleLabel.text = _post.title
            descriptionLabel.text = _post.description
            dateLabel.text = "Date"
        }

        statusImage.image = UIImage(named: "binoculars")
        statusImage.setImageColor(color: UIColor.red)
        
        checkmarkImage.image = UIImage(named: "checkmark")
        checkmarkImage.setImageColor(color: UIColor.gray)
        
        detailsImageView.image = UIImage(named: "details")
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
