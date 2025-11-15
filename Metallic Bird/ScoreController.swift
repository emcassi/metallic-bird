//
//  ScoreController.swift
//  Metallic Bird
//
//  Created by Alex Sigalos on 11/12/25.
//

class ScoreController {
    static var score: UInt16 = 0

    static func increment() {
        score += 1
        if let scoreLabel = Game.world.child(name: "scoreLabel") as? ScoreLabel {
            scoreLabel.updateLabel()
        }
        Game.soundboard.play(sfx: .score)
    }

    static func reset() {
        score = 0
    }

    static func getScore() -> UInt16 {
        return score
    }

    static func getDigits() -> String {
        return String(score)
    }
}
