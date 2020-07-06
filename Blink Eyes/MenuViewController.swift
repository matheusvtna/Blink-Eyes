//
//  MenuViewController.swift
//  Blink Eyes
//
//  Created by Matheus Andrade on 04/07/20.
//  Copyright © 2020 Matheus Andrade. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController{
    
    @IBOutlet weak var score: UILabel!
    @IBOutlet weak var tapLabel: UILabel!
    
    override func viewDidLoad() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        
        self.view.addGestureRecognizer(tap)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        score.text = String(Score.shared.highScore)
    
        UIImageView.animate(withDuration: 0.9, delay: 0.0, options: [.repeat, .autoreverse], animations: {
            self.tapLabel.alpha = 0.3
            self.tapLabel.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            print("to animando")
        }) { _ in
            
        }
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer){
        
        removeAnimation()
        
        let game = storyboard?.instantiateViewController(identifier: "Game") as! GameViewController
        game.modalPresentationStyle = .fullScreen
        
        self.present(game, animated: true, completion: nil)
    }
    
    func removeAnimation() {
        self.score.layer.removeAllAnimations()
        self.view.layer.removeAllAnimations()
        self.view.layoutIfNeeded()
        
    }
    
}
