//
//  FiveByFiveViewController.swift
//  EightPuzzle - AleksPenev&JordanGary
//
//  Created by Aleksandar Penev on 3/12/19.
//  Copyright © 2019 Aleksandar Penev. All rights reserved.
//

import UIKit

class FiveByFiveViewController: UIViewController {

    @IBOutlet weak var blocksView: UIView!
    
    var gameViewWidth: CGFloat!
    var blockWidth: CGFloat!
    
    //x and y coords used for the buttons in the grid
    var xCenter : CGFloat!
    var yCenter : CGFloat!
    
    
    //blocks holds all of the buttons
    //centers will hold the center of all of the buttons
    //!!!!IMPORTANT!!!!! can check if in right place using
    //            buttonPlus.center == buttonPlus.centerHold
    var blocksArray: NSMutableArray = []
    var centersArray: NSMutableArray = []
    
    
    
    //touch booleans for handling the first button being touched and the second button being touched
    var oneTouch = false
    var twoTouch = false
    
    //the variables used to hold position of two buttons pushed
    var firstCenter: buttonPlus!
    var secondCenter: buttonPlus!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        //Gestures here
        let rightSwipeGesture = UISwipeGestureRecognizer(target: self, action:#selector(FiveByFiveViewController.rightSwipedByUser(_:)))
        
        rightSwipeGesture.numberOfTouchesRequired = 2
        rightSwipeGesture.direction = .right
        view.addGestureRecognizer(rightSwipeGesture)
        
        //Grid Creation Here
        createGrid()
        randomize()
        
    }
    
    
    
    @objc func rightSwipedByUser(_ gesture: UISwipeGestureRecognizer){
        dismiss(animated: true, completion: nil)
        
    }
    
    
    /*
     function when buttons are pressed:
     case1: first button pressed, the center gets stored in the 'firstCenter' var
     the alpha is changed so that you know which block is selected.
     
     case2: second button pushed...
     calculate the difference between the centers of the buttons
     
     if that difference is less than or equal to their width(+4 for rounding)
     then they are adjacent so swap them
     otherwise
     reset the first button pressed's alpha and say it isn't touched
     anymore
     */
    @objc func buttonPressed(_ sender: buttonPlus!){
        if (oneTouch == false) {
            firstCenter = sender
            firstCenter.alpha = 0.5
            oneTouch = true
        } else {
            secondCenter = sender
            let xDifference: CGFloat = firstCenter.center.x - secondCenter.center.x
            let yDifference: CGFloat = firstCenter.center.y - secondCenter.center.y
            let dist: CGFloat = sqrt(pow(xDifference, 2) + pow(yDifference, 2))
            if dist <= blockWidth + 4{ //added plus 4 because of rounding when dealing with floats
                let tempCenter: CGPoint = firstCenter.center
                UIView.beginAnimations(nil, context: nil)
                UIView.setAnimationDuration(0.2)
                firstCenter.center = secondCenter.center
                secondCenter.center = tempCenter
                UIView.commitAnimations()
                firstCenter.alpha = 1
                oneTouch = false
                gameCheck()
            } else {
                firstCenter.alpha = 1
                oneTouch = false
            }
        }
    }
    
    
    func gameCheck() {
        var counter = 0
        for block in blocksArray {
            if (block as! buttonPlus).center == (block as! buttonPlus).centerHold {
                counter += 1
            }
        }
        
        //case where all of the tiles are in the correct place
        if counter == 25 {
            let alertController =
                UIAlertController(title: title,
                                  message: "Great Job! You Won!",
                                  preferredStyle: .alert)
            
            let resetAction =
                UIAlertAction(title: "Yes, I'm great, now reset the puzzle!",
                              style: .default) {_ in
                                self.randomize() }
            
            
            alertController.addAction(resetAction)
            
            present(alertController,
                    animated: true,
                    completion: nil)
        }
    }
    
    
    func createGrid(){
        
        gameViewWidth = blocksView.frame.size.width
        blockWidth = gameViewWidth / 5
        
        xCenter = blockWidth / 2
        yCenter = blockWidth / 2
        
        var labelnum : Int = 1
        
        for _ in 0..<5{
            for _ in 0..<5{
                let blockFrame : CGRect = CGRect(x: 0, y: 0, width: blockWidth, height: blockWidth)
                let block: buttonPlus = buttonPlus(frame: blockFrame)
                block.isUserInteractionEnabled = true
                
                let currCenter : CGPoint = CGPoint(x: xCenter, y: yCenter)
                
                block.center = currCenter
                block.centerHold = currCenter
                
                centersArray.add(currCenter)
                
                if let image = UIImage(named: "Triangle"+String(labelnum)){
                    block.setImage(image, for: .normal)
                }
                
                labelnum += 1
                block.backgroundColor = UIColor.darkGray
                block.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
                blocksView.addSubview(block)
                
                blocksArray.add(block)
                
                xCenter += blockWidth
            }
            xCenter = blockWidth / 2
            yCenter += blockWidth
        }
    }
    
    
    
    func randomize(){
        //This is so that the centers aren't destroyed when they are removed below
        let mutableCentersArray: NSMutableArray = centersArray.mutableCopy() as! NSMutableArray
        
        
        for block in blocksArray{
            let randomIndex: Int = Int(arc4random_uniform(UInt32(mutableCentersArray.count)))
            let randomCenter: CGPoint = mutableCentersArray[randomIndex] as! CGPoint
            
            (block as! buttonPlus).center = randomCenter
            mutableCentersArray.removeObject(at: randomIndex) //array objs removed here
        }
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
