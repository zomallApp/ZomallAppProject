//
//  MessageCellTableViewCell.swift
//  ZomallApp
//
//  Created by Usman on 17/07/2020.
//  Copyright © 2020 Usman. All rights reserved.
//

import UIKit

class MessageCellTableViewCell: UITableViewCell {
    @IBOutlet var name: UILabel!
    
    @IBOutlet var body: UILabel!
    @IBOutlet var messageImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        messageImage.image  = UIImage(systemName:"person.crop.circle.fill")
        messageImage.tintColor = UIColor.gray
        messageImage.layer.borderWidth = 1
        messageImage.layer.masksToBounds = false
        messageImage.layer.borderColor = UIColor.clear.cgColor
        messageImage.layer.cornerRadius = messageImage.frame.height/2
        messageImage.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }

}
