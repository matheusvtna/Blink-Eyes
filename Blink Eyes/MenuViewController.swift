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
        
        UIImageView.animate(withDuration: 0.9, delay: 0.0, options: [.repeat, .autoreverse], animations: {
            self.tapLabel.alpha = 0.3
            self.tapLabel.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }) { _ in
            
        }
        
        score.text = String(Score.shared.highScore)
        
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer){
        let game = storyboard?.instantiateViewController(identifier: "Game") as! GameViewController
        game.modalPresentationStyle = .fullScreen
        self.present(game, animated: true, completion: nil)
    }
    
}
