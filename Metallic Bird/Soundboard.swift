//
//  Soundboard.swift
//  Metallic Bird
//
//  Created by Alex Sigalos on 11/12/25.
//

import AVFoundation

enum SFXPath: String {
    case flap = "wing.wav"
    case score = "point.wav"
    case hit = "hit.wav"
    case die = "die.wav"
}

enum SFX {
    case flap
    case score
    case hit
    case die
}

class Soundboard {
    var flapSFX: AVAudioPlayer?
    var scoreSFX: AVAudioPlayer?
    var hitSFX: AVAudioPlayer?
    var dieSFX: AVAudioPlayer?

    var queue: [SFX] = []
    var playingInQueue: SFX?

    init() {
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.ambient, options: [.mixWithOthers])
            try session.setPreferredSampleRate(44100) // 44.1 kHz Sample Rate
            try session.setPreferredIOBufferDuration(0.0058) // ~256 frames @ 48kHz (~5.8ms)
            try session.setActive(true)
        } catch {
            print("Failed to configure audio session: \(error)")
        }

        flapSFX = loadSFX(path: .flap)
        scoreSFX = loadSFX(path: .score)
        hitSFX = loadSFX(path: .hit)
        dieSFX = loadSFX(path: .die)
    }

    func loadSFX(path: SFXPath) -> AVAudioPlayer? {
        do {
            if let path = Bundle.main.path(forResource: path.rawValue, ofType: nil) {
                let url = URL(fileURLWithPath: path)
                let player = try AVAudioPlayer(contentsOf: url)
                _ = player.prepareToPlay()
                return player
            } else {
                print("SFX not found: \(path)")
                return nil
            }
        } catch {
            print("Failed to create sfx: \(path)")
            return nil
        }
    }

    func play(sfx: SFX) {
        let player: AVAudioPlayer?
        switch sfx {
        case .flap:
            player = flapSFX
        case .score:
            player = scoreSFX
        case .hit:
            player = hitSFX
        case .die:
            player = dieSFX
        }

        if let player = player, player.isPlaying {
            player.pause()
            player.currentTime = 0
        }
        player?.play()
    }

    func isPlaying(sfx: SFX) -> Bool {
        switch sfx {
        case .flap:
            return flapSFX?.isPlaying ?? false
        case .score:
            return scoreSFX?.isPlaying ?? false
        case .hit:
            return flapSFX?.isPlaying ?? false
        case .die:
            return dieSFX?.isPlaying ?? false
        }
    }

    func addToQueue(sfx: SFX) {
        queue.append(sfx)
    }

    func queueUpdate() {
        if let first = queue.first {
            if playingInQueue == first {
                if !isPlaying(sfx: first) {
                    queue.removeFirst()
                    playingInQueue = queue.first
                    if let newFirst = queue.first {
                        play(sfx: newFirst)
                    }
                }
            } else {
                playingInQueue = first
                play(sfx: first)
            }
        }
    }
}
