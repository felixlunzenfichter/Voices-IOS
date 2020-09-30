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
            audioRecorder?.delegate = self
            audioRecorder?.record()
        } catch {
            // not jud
        }
    }
    
    @IBAction func StopRecordingButtonPressed(_ sender: Any) {
        audioRecorder?.stop()
        
//        var voiceTableViewController : VoicesTableViewController = self.parent as! VoicesTableViewController
//        voiceTableViewController.tableView.reloadData()
    }
    
    func getDocumentsDirectory() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
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


