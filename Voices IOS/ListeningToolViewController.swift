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
    @IBOutlet var textLabel: UILabel!
    var voicePath: String!
    
    var updater : CADisplayLink!
    
    var audioPlayer: AVAudioPlayer!
    var audioSession: AVAudioSession = AVAudioSession.sharedInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpAudioSession()
        initAudioPlayer()
        initializePathLabel()

        // Do any additional setup after loading the view.
    }
    
    // MARK: - setup
    fileprivate func initAudioPlayer() {
        let audioFilename : URL = URL(fileURLWithPath: voicePath)
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audioFilename)
            audioPlayer.delegate = self
        } catch {
            // catching dick
        }
    }
    
    fileprivate func setUpAudioSession() {
        do {
            try audioSession.setCategory(.playback, mode: .default)
            try audioSession.setActive(true)
//            audioSession.requestRecordPermission(permissionBlock(permissionGranded:))
        } catch {
            // Problemo
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
    
    fileprivate func initializePathLabel() {
        let duration: Double = (audioPlayer.duration * 10).rounded() / 10
        textLabel.text = "length of Voice: \(duration) seconds"
        textLabel.numberOfLines = 0
    }
    
    
    // MARK: - listening controls.
    @IBAction func playButtonPushed(_ sender: Any) {
        audioPlayer.play()
        
        updater = CADisplayLink(target: self, selector: #selector(self.musicProgress))
        updater.preferredFramesPerSecond = 5
        updater.add(to: RunLoop.current, forMode: RunLoop.Mode.default)
    }

    @IBAction func pauseButtonPushed(_ sender: Any) {
        audioPlayer.pause()
    }
    
    @objc func musicProgress()  {
        let normalizedTime = Float(self.audioPlayer!.currentTime / (self.audioPlayer!.duration) )
        self.listeningProgressBar.progress = normalizedTime
        print(normalizedTime)
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
