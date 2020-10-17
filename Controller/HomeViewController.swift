//
//  HomeViewController.swift
//  ZomallApp
//
//  Created by Baskt QA on 17/10/2020.
//  Copyright © 2020 Usman. All rights reserved.
//

import UIKit
import Shuffle_iOS


class HomeViewController: UIViewController {
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var crossButton: UIButton!
    @IBOutlet weak var heartButton: UIButton!
    
let cardStack = SwipeCardStack()
    
    let cardImages = [
        #imageLiteral(resourceName: "launch"),
        #imageLiteral(resourceName: "Me"),
        #imageLiteral(resourceName: "launch"),
        #imageLiteral(resourceName: "Me"),
        #imageLiteral(resourceName: "launch"),
        #imageLiteral(resourceName: "Me"),
    ]
   // public var previousView: (() -> UIView?)?
   
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var swipeCard: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupButtons()
        self.setupBottomView()
        cardStack.dataSource = self
        cardStack.delegate = self
        swipeCard.addSubview(cardStack)
        cardStack.frame = swipeCard.safeAreaLayoutGuide.layoutFrame
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
   
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func card(fromImage image: UIImage) -> SwipeCard {
      let card = SwipeCard()
      card.swipeDirections = [.left, .right]
      card.content = UIImageView(image: image)
      
      let leftOverlay = UIView()
      leftOverlay.backgroundColor = .white
      
      let rightOverlay = UIView()
      rightOverlay.backgroundColor = .white
        card.layer.cornerRadius = 5
      card.setOverlays([.left: leftOverlay, .right: rightOverlay])
      
      return card
    }
    func setupButtons() {
        self.crossButton.layer.cornerRadius = 0.5 * crossButton.bounds.size.width
        crossButton.clipsToBounds = true
        self.heartButton.layer.cornerRadius = 0.5 * heartButton.bounds.size.width
        heartButton.clipsToBounds = true

        self.refreshButton.layer.cornerRadius = 0.5 * refreshButton.bounds.size.width
        refreshButton.clipsToBounds = true

    }
    func setupBottomView()
    {
       // HelpingClass.ApplyShadow(ViewPlaceHolder: self.bottomView, shadowRadius: 5)
        self.bottomView.layer.shadowColor = UIColor.white.cgColor
        self.bottomView.layer.shadowOpacity = 0.4
        self.bottomView.layer.shadowOffset = CGSize(width: 0, height: 5)
        self.bottomView.layer.shadowRadius = 3
        self.bottomView.layer.masksToBounds = false;
        self.bottomView.layer.cornerRadius = 30
        self.bottomView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner] // top left corner, top right corner respectively
    }
    func openProfile(index: Int) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "OthersProfileViewController") as! OthersProfileViewController
        vc.index = index
        vc.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
extension HomeViewController: SwipeCardStackDataSource {
    func cardStack(_ cardStack: SwipeCardStack, cardForIndexAt index: Int) -> SwipeCard {
      return card(fromImage: cardImages[index])
    }

    func numberOfCards(in cardStack: SwipeCardStack) -> Int {
      return cardImages.count
    }
}

extension HomeViewController: SwipeCardStackDelegate {
    func cardStack(_ cardStack: SwipeCardStack, didSelectCardAt index: Int){
        self.openProfile(index: index)
        print(index)
    }
    func cardStack(_ cardStack: SwipeCardStack, didSwipeCardAt index: Int, with direction: SwipeDirection){
        print(direction)
    }
    
    
    

}
