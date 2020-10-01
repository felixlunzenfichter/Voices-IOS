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
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var audioFileName :String?

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
    
    func getCurrentTimeStamp() -> String {
        let date = Date()
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = df.string(from: date)
        return dateString
    }
    
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
        
        // Save to database.
        let voice : Voice = Voice(context: self.context)
        voice.title = audioFileName
        voice.filename = audioFileName
        do {
            try context.save()
        } catch {
            print(error)
        }
        
    }
    
    @IBAction func StopRecordingButtonPressed(_ sender: Any) {
        audioRecorder?.stop()
    }
    
    func getDocumentsDirectory() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    func getVoiceURL(audioFileName: String) -> URL {
        getDocumentsDirectory().appendingPathComponent("\(audioFileName)")
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


