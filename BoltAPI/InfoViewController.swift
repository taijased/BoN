//
//  InfoViewController.swift
//  BoltAPI
//
//  Created by Maxim Spiridonov on 19/06/2019.
//  Copyright © 2019 Maxim Spiridonov. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController,CAAnimationDelegate, StoryboardInitializable {
    
    let colorOne = UIColor(hexValue: "#E47470", alpha: 1)!.cgColor
    let colorTwo = UIColor(hexValue: "#7EC050", alpha: 1)!.cgColor
    let colorThree = UIColor(hexValue: "#3E45E5", alpha: 1)!.cgColor
    let gradient = CAGradientLayer()
    var gradientSet = [[CGColor]]()
    var currentGradient: Int = 0
    
    @IBOutlet weak var blueView: UIView! {
        didSet {
            blueView.translatesAutoresizingMaskIntoConstraints = false
            blueView.layer.shadowRadius = 3
            blueView.layer.shadowOpacity = 0.4
            blueView.layer.shadowOffset = CGSize(width: 2.5, height: 4)
            blueView.layer.cornerRadius = 10
        }
    }
    @IBOutlet weak var redView: UIView! {
        didSet {
            redView.translatesAutoresizingMaskIntoConstraints = false
            redView.layer.shadowRadius = 3
            redView.layer.shadowOpacity = 0.4
            redView.layer.shadowOffset = CGSize(width: 2.5, height: 4)
            redView.layer.cornerRadius = 10
        }
    }
    @IBAction func closeButton(_ sender: UIButton) {
        sender.flash()
        dismiss(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        createGradientView()
    }
    /// Creates gradient view
    
    func createGradientView() {
        
        
        gradientSet.append([colorOne, colorTwo])
        gradientSet.append([colorTwo, colorThree])
        gradientSet.append([colorThree, colorOne])
        
        gradient.frame = self.view.bounds
        gradient.colors = gradientSet[currentGradient]
        gradient.startPoint = CGPoint(x:1, y:1)
        gradient.endPoint = CGPoint(x:0, y:1)
        gradient.drawsAsynchronously = true
        
        self.view.layer.insertSublayer(gradient, at: 0)
        
        animateGradient()
    }
    func animateGradient() {
        
        if currentGradient < gradientSet.count - 1 {
            currentGradient += 1
        } else {
            currentGradient = 0
        }
        
        let gradientChangeAnimation = CABasicAnimation(keyPath: "colors")
        gradientChangeAnimation.duration = 3.0
        gradientChangeAnimation.toValue = gradientSet[currentGradient]
        gradientChangeAnimation.fillMode = CAMediaTimingFillMode.forwards
        gradientChangeAnimation.isRemovedOnCompletion = false
        gradientChangeAnimation.delegate = self
        gradient.add(gradientChangeAnimation, forKey: "gradientChangeAnimation")
    }
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            gradient.colors = gradientSet[currentGradient]
            animateGradient()
        }
    }
   
    
}
