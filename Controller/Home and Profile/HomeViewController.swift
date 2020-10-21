//
//  HomeViewController.swift
//  ZomallApp
//
//  Created by Baskt QA on 17/10/2020.
//  Copyright © 2020 Usman. All rights reserved.
//

import UIKit
import Shuffle_iOS
import SDWebImage


class HomeViewController: UIViewController {
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var crossButton: UIButton!
    @IBOutlet weak var heartButton: UIButton!
    var homeAPIStructs = HomeApiCallsStructs()
let cardStack = SwipeCardStack()
    var userInfo: [UserInfo]?
    let cardImmmm = [ #imageLiteral(resourceName: "Me"), #imageLiteral(resourceName: "placeholderMan"), #imageLiteral(resourceName: "Me"), #imageLiteral(resourceName: "placeholderMan"), #imageLiteral(resourceName: "Me"), #imageLiteral(resourceName: "placeholderMan"), #imageLiteral(resourceName: "Me"), #imageLiteral(resourceName: "placeholderMan"), #imageLiteral(resourceName: "Me"), #imageLiteral(resourceName: "placeholderMan")]
    var cardImages: [String] = []
   // public var previousView: (() -> UIView?)?
   
    @IBOutlet weak var userLocationLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var swipeCard: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
       
       
        
        // Do any additional setup after loading the view.
    }
    
    func setupCardStack(){
        DispatchQueue.main.async {
            self.cardStack.delegate = self
            self.cardStack.dataSource = self
            self.swipeCard.addSubview(self.cardStack)
            self.cardStack.frame = self.swipeCard.safeAreaLayoutGuide.layoutFrame
        }
//        swipeCard.addSubview(cardStack)
//        cardStack.frame = swipeCard.safeAreaLayoutGuide.layoutFrame
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        self.homeAPIStructs.getPeople(userId: "02d7e5e0-cf95-11ea-95b4-7be7507b6b0c", limit: 20)
        
              
               self.setupButtons()
               self.setupBottomView()
            //   self.setupCardStack()
               self.homeAPIStructs.delegate = self
        
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
    func openProfile(index: Int, userInfo: [UserInfo]) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "OthersProfileViewController") as! OthersProfileViewController
        vc.index = index
        vc.profileInfo = self.userInfo?[index]
        vc.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
extension HomeViewController: SwipeCardStackDataSource {
    func cardStack(_ cardStack: SwipeCardStack, cardForIndexAt index: Int) -> SwipeCard {
        print(self.cardImages[index])
        return card(fromImage: (UIImage(named: self.cardImages[index]) ?? UIImage(named: "placeholderMan")!))
    }

    func numberOfCards(in cardStack: SwipeCardStack) -> Int {
        return self.cardImages.count
    }
}

extension HomeViewController: SwipeCardStackDelegate {
    func cardStack(_ cardStack: SwipeCardStack, didSelectCardAt index: Int){
        self.openProfile(index: index, userInfo: self.userInfo!)
        
        print(index)
    }
    func cardStack(_ cardStack: SwipeCardStack, didSwipeCardAt index: Int, with direction: SwipeDirection){
        print(direction)
        self.nextCard(index: index)
    }
    
    
    

}
extension HomeViewController: HomeAPICallResponseDelegate {
    func getPeopleApi(apiStatus: String, result: [UserInfo]) {
        if apiStatus == "true" && result.count > 0 {
            var index = 0
            while (index < result.count) {
                self.cardImages.append((result[index].images ?? "placeholderMan")!)
                index += 1
            }
            
            
            self.userInfo = result
            DispatchQueue.main.async {
                 self.userNameLabel.text = result[0].user_name
                           self.userLocationLabel.text = result[0].location
                           self.setupCardStack()
            }
           
            
        }
    }
    func nextCard(index: Int)  {
        DispatchQueue.main.async {
            self.userNameLabel.text = self.userInfo?[index].user_name
            self.userLocationLabel.text = self.userInfo?[index].location
        }
        
    }
    
    
    
}
