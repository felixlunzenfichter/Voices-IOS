//
//  PlayerViewController.swift
//  Voices IOS
//
//  Created by Felix Lunzenfichter on 20.09.20.
//  Copyright © 2020 Felix Lunzenfichter. All rights reserved.
//

import UIKit
import AVFoundation
import Speech

class ListeningToolViewController: UIViewController, AVAudioPlayerDelegate {
    
    // MARK:- Properties

    @IBOutlet var listeningProgressBar: UIProgressView!
    @IBOutlet var playPauseButton: UIButton!
    @IBOutlet var timeInfo: UILabel!
    @IBOutlet var transcription: UILabel!
    
    var playing: Bool = false
    
    var voice: Voice!
    var voiceURL : URL!
    
    var duration: Double = 0.0
    
    var audioPlayer: AVAudioPlayer?
    var audioSession: AVAudioSession = AVAudioSession.sharedInstance()
    
    // MARK: - setup
    override func viewDidLoad() {
        super.viewDidLoad()
        
        #warning("unwrap this safely")
        voiceURL = getVoiceURL(audioFileName: voice.filename!)
        
        setUpAudioSession()
        initAudioPlayer()
        setDuration()
        initTimeInfo()
        listeningProgressBar.progress = 0.0
        transcription.numberOfLines = 0
        transcribe(url: voiceURL as URL.ReferenceType)

    }

    fileprivate func initAudioPlayer() {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: voiceURL)
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
    }
    

    
    // MARK: - listening controls.
    fileprivate func handleUIUpdateWhileListening() {
        let updater = CADisplayLink(target: self, selector: #selector(self.listeningProgress))
        updater.preferredFramesPerSecond = 60
        updater.add(to: RunLoop.current, forMode: RunLoop.Mode.default)
    }
    
    @IBAction func playButtonPushed(_ sender: Any) {
        if (audioPlayer!.isPlaying) {
            audioPlayer?.pause()
            playPauseButton.setImage(#imageLiteral(resourceName: "play_1"), for: .normal)
        } else {
            audioPlayer?.play()
            playPauseButton.setImage(#imageLiteral(resourceName: "pause_1"), for: .normal)
            handleUIUpdateWhileListening()
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        playPauseButton.setImage(#imageLiteral(resourceName: "play_1"), for: .normal)
    }
    
    @objc func listeningProgress()  {
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

}

extension ListeningToolViewController : SFSpeechRecognizerDelegate {
    
    // MARK: - Speech recognition
    func transcribe(url:NSURL) {
        guard let myRecognizer = SFSpeechRecognizer() else {
        // A recognizer is not supported for the current locale
            print("Could not create SFpeechRecognizer instance in function recognizeFile().")
            return
        }
        myRecognizer.delegate = self
        
        SFSpeechRecognizer.requestAuthorization { authStatus in
            print(authStatus)
        }
       
        if !myRecognizer.isAvailable {
            // The recognizer is not available right now
            return
        }
        

        let request = SFSpeechURLRecognitionRequest(url: url as URL)
        
        myRecognizer.recognitionTask(with: request) { (result, error) in
            guard let result = result else {
                // Recognition failed, so check error for details and handle it
                print("fail")
                self.transcription.text = "Apple failed to transcribe this voice."
                return
            }
          // Print the speech that has been recognized so far
            if result.isFinal {
                self.transcription.text = result.bestTranscription.formattedString
                #warning ("TODO: Save transcript in database.")
            }
       }
    }
    
    func getDocumentsDirectory() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    func getVoiceURL(audioFileName: String) -> URL {
        getDocumentsDirectory().appendingPathComponent("\(audioFileName)")
    }
    
}

extension Notification.Name {
    static let playPauseEvent = Notification.Name("PlayPauseEvent")
}
