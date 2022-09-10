//
//  EmptyTableView.swift
//  NewNews
//
//  Created by valters.steinblums on 07/09/2022.
//

import UIKit

extension UITableView {
    func setEmptyView(title: String, messageImage: UIImage, message: String) {
        
        let emptyView = UIView(frame: CGRect(x: self.center.x, y: self.center.y, width: self.bounds.size.width, height: self.bounds.size.height))
        
        let messageImageView = UIImageView()
        let titleLabel = UILabel()
        let messageLabel = UILabel()
        
        messageImageView.backgroundColor = .clear
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        messageImageView.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.textColor = UIColor.label
        titleLabel.font = UIFont(name: "LeagueSpartan-Bold", size: 22)
        
        messageImageView.tintColor = .label
        messageLabel.textColor = UIColor.label
        messageLabel.font = UIFont(name: "LeagueSpartan-Light", size: 15)
        
        emptyView.addSubview(titleLabel)
        emptyView.addSubview(messageImageView)
        emptyView.addSubview(messageLabel)

        titleLabel.bottomAnchor.constraint(equalTo: messageImageView.topAnchor, constant: -30).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        
        messageImageView.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        messageImageView.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor).isActive = true
        messageImageView.widthAnchor.constraint(equalToConstant: 120).isActive = true
        messageImageView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        
        messageLabel.topAnchor.constraint(equalTo: messageImageView.bottomAnchor, constant: 30).isActive = true
        //messageLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        messageLabel.trailingAnchor.constraint(equalTo: emptyView.safeAreaLayoutGuide.trailingAnchor).isActive = true
        messageLabel.leadingAnchor.constraint(equalTo: emptyView.safeAreaLayoutGuide.leadingAnchor).isActive = true
        
        messageImageView.image = messageImage
        titleLabel.text = title
        
        messageLabel.text = message
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        
        self.backgroundView = emptyView
        self.separatorStyle = .none
    }
}
