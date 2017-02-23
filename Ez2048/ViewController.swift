//
//  ViewController.swift
//  Ez2048
//
//  Created by iOS Student on 2/23/17.
//  Copyright © 2017 tek4fun. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var lbl_Score: UILabel!
    var overlayView: UIView!
    var alertView: UIView!
    var animator: UIDynamicAnimator!
    var attachmentBehavior : UIAttachmentBehavior!

    var b = Array(repeating: Array(repeating: 0, count: 4), count: 4)
    override func viewDidLoad() {
        super.viewDidLoad()
        let directions: [UISwipeGestureRecognizerDirection] = [.right, .left, .up, .down]
        createOverlay()
        createAlert()
        for direction in directions
        {
            let gesture = UISwipeGestureRecognizer(target: self, action: #selector(respondToswipeGesture(gesture:)))
            gesture.direction = direction
            self.view.addGestureRecognizer(gesture)
        }
        randomNum(-1)
    }
    func randomNum(_ type: Int)
    {
        switch type {
        case 0:
            left()
        case 1:
            right()
        case 2:
            up()
        case 3:
            down()
        default:
            break
        }
        var rnlabelX = arc4random_uniform(4)
        var rnlabelY = arc4random_uniform(4)
        let rdNum = arc4random_uniform(2) == 0 ? 2 : 4
        while b[Int(rnlabelX)][Int(rnlabelY)] != 0
        {
            rnlabelX = arc4random_uniform(4)
            rnlabelY = arc4random_uniform(4)
        }
        b[Int(rnlabelX)][Int(rnlabelY)] = rdNum
        let numlabel = 100 + (Int(rnlabelX)*4) + Int(rnlabelY)
        ConvertNumLabel(numlabel: numlabel, value: String(rdNum))
        transfer()
    }
    func isLose() -> Bool
    {
        var count = 16
        for i in 0 ..< 4
        {
            for j in 0 ..< 4
            {
                if b[i][j] != 0
                {
                    count -= 1
                }
            }
        }
        if count <= 0 {
            return true
        }
        return false
    }
    func changeBackColor(numlabel: Int, color: UIColor)
    {
        let label = self.view.viewWithTag(numlabel) as! UILabel
        label.backgroundColor = color
    }

    func respondToswipeGesture(gesture: UIGestureRecognizer) {
        if isLose() {
            showAlert()
        }
            if let swipeGesture = gesture as? UISwipeGestureRecognizer {
                switch swipeGesture.direction {
                case UISwipeGestureRecognizerDirection.left:
                    randomNum(0)
                case UISwipeGestureRecognizerDirection.right:
                    randomNum(1)
                case UISwipeGestureRecognizerDirection.up:
                    randomNum(2)
                case UISwipeGestureRecognizerDirection.down:
                    randomNum(3)
                default:
                    break
                }
            }
    }
    func ConvertNumLabel(numlabel: Int, value: String)
    {
        let label = self.view.viewWithTag(numlabel) as! UILabel
        label.text = value
    }
    func transfer()
    {
        for i in 0 ..< 4
        {
            for j in 0 ..< 4
            {
                let numlabel = 100 + (i*4) + j
                ConvertNumLabel(numlabel: numlabel, value: String(b[i][j]))
                switch b[i][j] {
                case 2,4:changeBackColor(numlabel: numlabel, color: UIColor.cyan)
                case 8,16:changeBackColor(numlabel: numlabel, color: UIColor.green)
                case 16,32:changeBackColor(numlabel: numlabel, color: UIColor.orange)
                case 64:changeBackColor(numlabel: numlabel, color: UIColor.red)
                case 128,256,512:changeBackColor(numlabel: numlabel, color: UIColor.yellow)
                case 1024,2048:changeBackColor(numlabel: numlabel, color: UIColor.purple)
                default: changeBackColor(numlabel: numlabel, color: UIColor.brown)
                }
            }
        }
    }
    func up()
    {

        for col in 0 ..< 4
        {
            var check = false
            for row in 1 ..< 4
            {
                var tx = row
                if (b[row][col] == 0)
                {
                    continue;
                }
                for rowc in ((-1 + 1)...row - 1).reversed()
                {
                    if (b[rowc][col] != 0 && (b[rowc][col] != b[row][col] || check))
                    {
                        break
                    }
                    else
                    {
                        tx = rowc
                    }
                }
                if (tx == row)
                {
                    continue
                }
                if (b[row][col] == b[tx][col])
                {
                    check = true
                    GetScore(value: b[tx][col])
                    b[tx][col] *= 2
                }
                else
                {
                    b[tx][col] = b[row][col]
                }
                b[row][col] = 0;
            }
        }
    }

    func down()
    {
        for col in 0 ..< 4
        {
            var check = false
            for row in 0 ..< 4
            {
                var tx = row

                if (b[row][col] == 0)
                {
                    continue
                }
                for rowc in row + 1 ..< 4
                {
                    if (b[rowc][col] != 0 && (b[rowc][col] != b[row][col] || check))
                    {
                        break;
                    }
                    else
                    {
                        tx = rowc
                    }
                }
                if (tx == row)
                {
                    continue
                }
                if (b[tx][col] == b[row][col])
                {
                    check = true
                    GetScore(value: b[tx][col])
                    b[tx][col] *= 2

                }
                else
                {
                    b[tx][col] = b[row][col]
                }
                b[row][col] = 0;
            }
        }
    }
    func left()
    {
        for row in 0 ..< 4
        {
            var check = false
            for col in 1 ..< 4
            {
                if (b[row][col] == 0)
                {
                    continue
                }
                var ty = col
                for colc in ((-1 + 1)...col - 1).reversed()
                {
                    if (b[row][colc] != 0 && (b[row][colc] != b[row][col] || check))
                    {
                        break
                    }
                    else
                    {
                        ty = colc
                    }
                }
                if (ty == col)
                {
                    continue;
                }
                if (b[row][ty] == b[row][col])
                {
                    check = true
                    GetScore(value: b[row][ty])
                    b[row][ty] *= 2

                }
                else
                {
                    b[row][ty]=b[row][col]
                }
                b[row][col] = 0
            }
        }
    }
    func right()
    {
        for row in 0 ..< 4
        {
            var check = false
            for col in ((-1 + 1)...3).reversed()
            {
                if (b[row][col] == 0)
                {
                    continue
                }
                var ty = col
                for colc in col + 1 ..< 4
                {
                    if (b[row][colc] != 0 && (b[row][colc] != b[row][col] || check))
                    {
                        break
                    }
                    else
                    {
                        ty = colc
                    }
                }
                if (ty == col)
                {
                    continue;
                }
                if (b[row][ty] == b[row][col])
                {
                    check = true
                    GetScore(value: b[row][ty])
                    b[row][ty] *= 2

                }
                else
                {
                    b[row][ty] = b[row][col]
                }
                b[row][col] = 0

            }
        }
    }
    
    func GetScore(value: Int)
    {
        lbl_Score.text = String(Int(lbl_Score.text!)! + value)
    }

    func createOverlay() {
        overlayView = UIView(frame: view.bounds)
        overlayView.backgroundColor = UIColor.gray
        overlayView.alpha = 0.0
        view.addSubview(overlayView)
    }

    func createAlert() {

        let alertWidth: CGFloat = 100
        let alertHeight: CGFloat = 100
        let buttonWidth: CGFloat = 30
        let alertViewFrame: CGRect = CGRect(x: view.bounds.maxX/2 - alertWidth/2, y: view.bounds.maxY/2 - alertHeight/2, width: alertWidth, height: alertHeight)
        alertView = UIView(frame: alertViewFrame)
        alertView.backgroundColor = UIColor.white
        alertView.alpha = 0.0
        alertView.layer.cornerRadius = 10;
        alertView.layer.shadowColor = UIColor.black.cgColor;
        alertView.layer.shadowOffset = CGSize(width: 0, height: 5);
        alertView.layer.shadowOpacity = 0.3;
        alertView.layer.shadowRadius = 10.0;

        //create Close Button
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "Dismiss.png"), for: UIControlState())
        button.backgroundColor = UIColor.clear
        button.frame = CGRect(x: alertWidth/2 - buttonWidth/2, y: -buttonWidth/2, width: buttonWidth, height: buttonWidth)
        button.addTarget(self, action: #selector(ViewController.dismissAlert), for: UIControlEvents.touchUpInside)

        //create Text View
        let rectLabel = CGRect(x: 0, y: alertHeight/2 , width: alertWidth, height: alertHeight/2)
        let label = UITextView(frame: rectLabel)
        label.text = "You Lose!"
        label.font = UIFont.systemFont(ofSize: 20)
        label.contentMode = .scaleToFill
        label.textAlignment = .center
        label.isEditable = false
        alertView.addSubview(label)
        alertView.addSubview(button)
        view.addSubview(alertView)
    }

    func showAlert() {
        if (alertView == nil) {
            createAlert()
        }
        // Animate in the overlay
        UIView.animate(withDuration: 0.4, animations: {
            self.overlayView.alpha = 1.0
        })

        // Animate the alert view using UIKit Dynamics.
        alertView.alpha = 1.0
        
    }
    func dismissAlert() {
        UIView.animate(withDuration: 0.4, animations: {
            self.overlayView.alpha = 0.0
            self.alertView.alpha = 0.0
            }, completion: {
                (value: Bool) in
                self.alertView.removeFromSuperview()
                self.alertView = nil
        })

    }
}

