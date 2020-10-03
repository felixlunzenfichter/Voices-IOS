//
//  RecorderViewController.swift
//  Voices IOS
//
//  Created by Felix Lunzenfichter on 28.09.20.
//  Copyright © 2020 Felix Lunzenfichter. All rights reserved.
//

import UIKit
import AVFoundation
import RecordButtonSwift

class RecorderViewController: UIViewController, AVAudioRecorderDelegate {
    
    var audioSession: AVAudioSession = AVAudioSession.sharedInstance()
    var audioRecorder: AVAudioRecorder?
    let persistentContainer = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    var voiceFileName: String?
    

    @IBOutlet var recordButton: RecordButton!


    var progressTimer : Timer!
    var progress : CGFloat! = 0
    
    func record() {
        self.progressTimer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: Selector(("updateProgress")), userInfo: nil, repeats: true)
    }
    
    func updateProgress() {
        
        let maxDuration = CGFloat(5) // max duration of the recordButton
        
        progress = progress + (CGFloat(0.05) / maxDuration)
        recordButton.setProgress(progress)
        
        if progress >= 1 {
            progressTimer.invalidate()
        }
        
    }
    
    func stop() {
        self.progressTimer.invalidate()
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpAudioSession()
    }
    
    fileprivate func setUpAudioSession() {
        
        do {
            try audioSession.setCategory(.playAndRecord)
        } catch {
            print(error)
        }
        
        func emptyPermissionBlock(permissionGranded: Bool) {}
        audioSession.requestRecordPermission(emptyPermissionBlock(permissionGranded:))
    }
}

// MARK:- IBActions
extension RecorderViewController {
    fileprivate func startRecording() {
        voiceFileName = "\(getCurrentTimeStamp()).m4a"
        let audioFilePath = getVoiceURL(audioFileName: voiceFileName!)
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilePath, settings: settings)
            print("audioFilename: \(audioFilePath)")
            audioRecorder?.delegate = self
            audioRecorder?.record()
        } catch {
            // not jud
        }
        
        persistentContainer.saveVoice(voiceName: voiceFileName!)
    }
    
    fileprivate func stopRecording() {
        audioRecorder?.stop()
        audioRecorder = nil
    }
    
    @IBAction func recordButtonPressed(_ sender: Any) {
        if audioRecorder == nil {
            startRecording()
        } else {
            stopRecording()
        }
    }

}

// MARK:- Helper functions.
extension RecorderViewController {
    func getDocumentsDirectory() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }

    func getVoiceURL(audioFileName: String) -> URL {
        getDocumentsDirectory().appendingPathComponent("\(audioFileName)")
    }

    func getCurrentTimeStamp() -> String {
        let date = Date()
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = df.string(from: date)
        return dateString
    }
}


