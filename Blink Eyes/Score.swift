//
//  Score.swift
//  Blink Eyes
//
//  Created by Matheus Andrade on 05/07/20.
//  Copyright © 2020 Matheus Andrade. All rights reserved.
//

import Foundation

class Score {
    
    public static var shared = Score()
    
    public var amount: Int = 0
    public var highScore: Int {
        
        get{
            return UserDefaults.standard.integer(forKey: "highScore")
        }
        
        set{
            UserDefaults.standard.set(newValue, forKey: "highScore")
        }
        
    }
    
    public func addScore(){
        self.amount += 1
    }
    
    public func trySaveHighScore(){
        if(self.amount > self.highScore){
            self.highScore = self.amount
        }
    }
    
}
