//
//  PicturesOfUserCollectionViewCell.swift
//  ZomallApp
//
//  Created by Baskt QA on 18/10/2020.
//  Copyright © 2020 Usman. All rights reserved.
//

import UIKit

class PicturesOfUserCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var userImages: UIImageView!
    @IBOutlet weak var mainView: UIView!
    
    override func awakeFromNib() {
        HelpingClass.ApplyShadow(ViewPlaceHolder: self.mainView, shadowRadius: 10)
        self.setupMainView()
    }
    
    func setupMainView()
    {
        self.mainView.layer.shadowColor = UIColor.lightGray.cgColor
        self.mainView.layer.shadowOpacity = 0.4
        self.mainView.layer.shadowOffset = CGSize(width: 0, height: 5)
        self.mainView.layer.shadowRadius = 3
        self.mainView.layer.masksToBounds = false;
        self.mainView.layer.cornerRadius = 5
        //self.bottomView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner] // top left corner, top right corner respectively
    }
    
    
    
}
