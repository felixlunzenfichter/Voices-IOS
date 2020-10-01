//
//  RecorderViewController.swift
//  Voices IOS
//
//  Created by Felix Lunzenfichter on 28.09.20.
//  Copyright © 2020 Felix Lunzenfichter. All rights reserved.
//

import UIKit
import AVFoundation

class RecorderViewController: UIViewController, AVAudioRecorderDelegate {
    
    var audioSession: AVAudioSession = AVAudioSession.sharedInstance()
    var audioRecorder: AVAudioRecorder?
    let persistentContainer = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    var audioFileName :String?

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpAudioSession()
    }
    
    fileprivate func setUpAudioSession() {
        do {
            try audioSession.setCategory(.playAndRecord)
            func emptyPermissionBlock(permissionGranded: Bool) {}
            audioSession.requestRecordPermission(emptyPermissionBlock(permissionGranded:))
        } catch {
            // Problemo
        }
    }
}

// MARK:- IBActions
extension RecorderViewController {
    @IBAction func pressedRecordButton(_ sender: Any) {
        audioFileName = "\(getCurrentTimeStamp()).m4a"
        let audioFilePath = getVoiceURL(audioFileName: audioFileName!)
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.medium.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilePath, settings: settings)
            print("audioFilename: \(audioFilePath)")
            audioRecorder?.delegate = self
            audioRecorder?.record()
        } catch {
            // not jud
        }
        
        persistentContainer.saveVoice(voiceName: audioFileName!)
        
    }
    
    @IBAction func StopRecordingButtonPressed(_ sender: Any) {
        audioRecorder?.stop()
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


