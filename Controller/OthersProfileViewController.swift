//
//  OthersViewController.swift
//  ZomallApp
//
//  Created by Baskt QA on 17/10/2020.
//  Copyright © 2020 Usman. All rights reserved.
//

import UIKit

class OthersProfileViewController: UIViewController {

    @IBOutlet weak var usersImagesCollectionView: UICollectionView!
    @IBOutlet weak var profileDetailView: UIView!
    var index: Int?
    let images = [ #imageLiteral(resourceName: "Me"), #imageLiteral(resourceName: "launch"), #imageLiteral(resourceName: "Me"), #imageLiteral(resourceName: "launch"), #imageLiteral(resourceName: "Me"), #imageLiteral(resourceName: "launch"), #imageLiteral(resourceName: "Me"), #imageLiteral(resourceName: "launch")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // print(index)
        
        self.usersImagesCollectionView.delegate = self
        self.usersImagesCollectionView.dataSource = self

        self.setupProfileView()
         //self.profileDetailView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
       // HelpingClass.ApplyShadow(ViewPlaceHolder: self.profileDetailView, shadowRadius: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    func setupProfileView()
       {
        
       
           self.profileDetailView.layer.shadowColor = UIColor.lightGray.cgColor
        self.profileDetailView.layer.shadowOpacity = 0.7
           self.profileDetailView.layer.shadowOffset = CGSize(width: 0, height: 5)
           self.profileDetailView.layer.shadowRadius = 3
           self.profileDetailView.layer.masksToBounds = false;
           self.profileDetailView.layer.cornerRadius = 20
           self.profileDetailView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner] // top left corner, top right corner respectively
         HelpingClass.ApplyShadow(ViewPlaceHolder: self.profileDetailView, shadowRadius: 5)x
       
       }

    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension OthersProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.usersImagesCollectionView.dequeueReusableCell(withReuseIdentifier: "PicturesOfUserCollectionViewCell", for: indexPath) as! PicturesOfUserCollectionViewCell
        cell.userImages.image = self.images[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        <#code#>
    }
    

    
    
    
}
extension OthersProfileViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout
                collectionViewLayout: UICollectionViewLayout,
                                minimumLineSpacingForSectionAt section: Int) -> CGFloat {

     return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
       return 5
    }
}

