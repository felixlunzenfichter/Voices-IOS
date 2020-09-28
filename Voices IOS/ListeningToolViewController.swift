//
//  PlayerViewController.swift
//  Voices IOS
//
//  Created by Felix Lunzenfichter on 20.09.20.
//  Copyright © 2020 Felix Lunzenfichter. All rights reserved.
//

import UIKit
import AVFoundation

class ListeningToolViewController: UIViewController, AVAudioPlayerDelegate {
    
    // MARK:- Properties

    @IBOutlet var listeningProgressBar: UIProgressView!
    @IBOutlet var play: UIButton!
    @IBOutlet var pause: UIButton!
    @IBOutlet var timeInfo: UILabel!
    
    var voicePath: String!
    var duration: Double = 0.0
    
    var updater : CADisplayLink!
    
    var audioPlayer: AVAudioPlayer?
    var audioSession: AVAudioSession = AVAudioSession.sharedInstance()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpAudioSession()
        initAudioPlayer()
        setDuration()
        initTimeInfo()
        listeningProgressBar.progress = 0.0
    }
    
    // MARK: - setup
    fileprivate func initAudioPlayer() {
        let audioFilename : URL = URL(fileURLWithPath: voicePath)
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audioFilename)
            audioPlayer?.delegate = self
        } catch {
            print(error)
            print("Error initializing player")
            
        }
    }
    
    fileprivate func setUpAudioSession() {
        do {
            try audioSession.setCategory(.playback, mode: .default)
            try audioSession.setMode(.spokenAudio)
            try audioSession.setActive(true)
        } catch {
            print(error)
        }
    }
    
    func permissionBlock(permissionGranded: Bool) {
        DispatchQueue.main.async {
            if permissionGranded {
                // good
                print("permissions granted")
            } else {
                print("permissions not granded")
            }
        }
    }
    
    fileprivate func initTimeInfo() {
        timeInfo.text = "0/\(duration)"
    }
    
    fileprivate func setDuration() {
        duration = ((audioPlayer?.duration ?? 0.0) * 10).rounded() / 10
        print(duration)
    }
    
    // MARK: - listening controls.
    @IBAction func playButtonPushed(_ sender: Any) {
        audioPlayer?.play()
        
        updater = CADisplayLink(target: self, selector: #selector(self.musicProgress))
        updater.preferredFramesPerSecond = 5
        updater.add(to: RunLoop.current, forMode: RunLoop.Mode.default)
    }

    @IBAction func pauseButtonPushed(_ sender: Any) {
        audioPlayer?.pause()
    }
    
    @objc func musicProgress()  {
        updateProgressBar()
        updateTimeInfo()
    }
    
    fileprivate func updateProgressBar() {
        let normalizedTime = Float( (self.audioPlayer?.currentTime ?? 0.0 as Double) / duration)
        self.listeningProgressBar.progress = normalizedTime
    }
    
    fileprivate func updateTimeInfo () {
        let time : Double = audioPlayer?.currentTime ?? -69.0
        let roundedTime = (time * 10).rounded() / 10
        timeInfo.text = "\(roundedTime)/\(duration)"
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
