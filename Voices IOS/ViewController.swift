//
//  ViewController.swift
//  Voices IOS
//
//  Created by Felix Lunzenfichter on 15.09.20.
//  Copyright © 2020 Felix Lunzenfichter. All rights reserved.
//

import UIKit
import AVFoundation

func getDocumentsDirectory() -> URL {
    return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
}



class ViewController: UIViewController, AVAudioPlayerDelegate {
    
    
    var audioPlayer: AVAudioPlayer!
    var audioRecorder: AVAudioRecorder!
    var audioSession: AVAudioSession = AVAudioSession.sharedInstance()
    

    fileprivate func setUpAudioSession() {
        do {
            try audioSession.setCategory(.playAndRecord)
            audioSession.requestRecordPermission(permissionBlock(permissionGranded:))
        } catch {
            // Problemo
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpAudioSession()
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

    // MARK: - Recording
    
    func getCurrentTimeStamp() -> String {
        let date = Date()
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = df.string(from: date)
        return dateString
    }

    
    
    @IBAction func record(_ sender: Any) {
        
        let dateString = getCurrentTimeStamp()
        
        let audioFilename = getDocumentsDirectory().appendingPathComponent("\(dateString).m4a")
        
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        do {
            let fileURLs = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
            print("files:")
            print(fileURLs)
            // process files
        } catch {
            print("Error while enumerating files \(documentsURL.path): \(error.localizedDescription)")
        }
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.medium.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()
        } catch {
            // not jud
        }
    }
    
    @IBAction func stopRecording(_ sender: Any) {
        audioRecorder.stop()
        audioRecorder = nil
        
        let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.m4a")
        print(getDocumentsDirectory().description)
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audioFilename)
            audioPlayer.delegate = self
        } catch {
            // catching dick
        }
        
        
    }
    
    // MARK: - Playback
    
    @IBAction func play(_ sender: Any) {
        audioPlayer.play()
    }
    
    @IBAction func pause(_ sender: Any) {
        audioPlayer.pause()
    }
    
    @IBAction func stopPlaying(_ sender: Any) {
        audioPlayer.stop()
        audioPlayer.currentTime = 0
    }
    
}

extension ViewController: AVAudioRecorderDelegate {
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            audioRecorder.stop()
            audioRecorder = nil
        }
    }
    
}



