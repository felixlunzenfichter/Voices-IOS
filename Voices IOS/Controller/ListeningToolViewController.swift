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

class ListeningToolViewController: UIViewController, AVAudioPlayerDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    // MARK:- Properties
    @IBOutlet var playPauseButton: UIButton!
    @IBOutlet var transcription: UILabel!
    @IBOutlet var listeningProgressBar: UIProgressView!
    @IBOutlet var timeInfo: UILabel!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var transcribeButton: UIButton!
    @IBOutlet var pickerView: UIPickerView!
    
//    enum Languages {
//        case English
//        case German
//        case French
//        case Spanish
//    }
//
////    var languages : [Languages : String] = [Languages.English : "en",
////                                            Languages.German : "de",
////                                            Languages.French : "fr",
////                                            Languages.Spanish : "es"
////                                            ]
    
    let languages : [String] = ["en", "de", "fr"]
    var language : String = "en"
    
    let persistentContainer = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    var voice: Voice!
    var voiceURL : URL!
    var currentlyTranscribing : Bool = false
    
    var duration: Double = 0.0
    
    var audioPlayer: AVAudioPlayer?
    var audioSession: AVAudioSession = AVAudioSession.sharedInstance()
    
    // MARK: - setup
    override func viewDidLoad() {
        super.viewDidLoad()
        
        #warning("unwrap this safely")
        voiceURL = getVoiceURL(audioFileName: (voice.filename ?? "No file name Found"))
        
        setUpAudioSession()
        initAudioPlayer()
        
        UIsetup()
    
        setUpLanguagePicker()
        
    }
    
    fileprivate func setUpLanguagePicker() {
        pickerView.delegate = self
        pickerView.dataSource = self
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

    fileprivate func initAudioPlayer() {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: voiceURL)
            audioPlayer?.delegate = self
        } catch {
            print(error)
            let alert = UIAlertController(title: "Error", message: "Initializing the audio player caused the following error: \(error.localizedDescription)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {(action) in
                self.navigationController?.popViewController(animated: true)
            }))
            self.present(alert, animated: true)
        }
    }

    fileprivate func UIsetup() {
        setDuration()
        initTimeInfo()
        listeningProgressBar.progress = 0.0
        transcription.numberOfLines = 0
        if voice.transcript != nil {
            transcription.text = voice.transcript
        }
        setUIToCurrentlyNotTranscribing()
    }
    
    func setUIToCurrentlyNotTranscribing () {
        transcribeButton.isHidden = false
        activityIndicator.isHidden = true
        activityIndicator.startAnimating()
    }
    
    func setUIToCurrentlyTranscribing () {
        transcribeButton.isHidden = true
        activityIndicator.isHidden = false
    }
    
    fileprivate func setDuration() {
        duration = ((audioPlayer?.duration ?? 0.0) * 10).rounded() / 10
    }

    
    fileprivate func initTimeInfo() {
        timeInfo.text = "0/\(duration)"
    }

}

// MARK:- Actions.
extension ListeningToolViewController {
    @IBAction func playButtonPushed(_ sender: Any) {
        
        // Unwrap safely.
        guard let audioPlayer = audioPlayer else {
            return
        }
        
        if (audioPlayer.isPlaying) {
            audioPlayer.pause()
            playPauseButton.setImage(#imageLiteral(resourceName: "play_1"), for: .normal)
        } else {
            audioPlayer.play()
            playPauseButton.setImage(#imageLiteral(resourceName: "pause_1"), for: .normal)
            handleUIUpdateWhileListening()
        }
    }
    
    @IBAction func deleteButtonPushed(_ sender: Any) {
        persistentContainer.deleteVoice(voice: voice)
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func transcribeButtonPushed(_ sender: Any) {
        setUIToCurrentlyTranscribing()
        transcribe(url: voiceURL as URL.ReferenceType)
    }
    
    
    
}

//MARK:- Update UI while playing.
extension ListeningToolViewController {
    
    fileprivate func handleUIUpdateWhileListening() {
        let updater = CADisplayLink(target: self, selector: #selector(self.listeningProgress))
        updater.preferredFramesPerSecond = 60
        updater.add(to: RunLoop.current, forMode: RunLoop.Mode.default)
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
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        playPauseButton.setImage(#imageLiteral(resourceName: "play_1"), for: .normal)
    }
}

// MARK: - Speech recognition.
extension ListeningToolViewController : SFSpeechRecognizerDelegate {
    fileprivate func saveTranscriptionInDatabase(_ result: SFSpeechRecognitionResult) {
        self.voice.transcript = result.bestTranscription.formattedString
        do {
            try self.persistentContainer.viewContext.save()
        } catch {
            print("Error saving voice transcription in database: \(error)")
        }
    }
    
    func transcribe(url:NSURL) {
        
        guard let myRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: language)) else {
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
            let alert = UIAlertController(title: "Error", message: "Speech to text sevice not available. Are you connected to the internet?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
            return
        }

        let request = SFSpeechURLRecognitionRequest(url: url as URL)
        
        myRecognizer.recognitionTask(with: request) { (result, error) in

            guard let result = result else {
                // Recognition failed, so check error for details and handle it
                print("fail")
                self.transcription.text = "Apple failed to transcribe this voice."
                self.setUIToCurrentlyNotTranscribing()
                return
            }
          // Print the speech that has been recognized so far
            if result.isFinal {
                self.setUIToCurrentlyNotTranscribing()
                self.transcription.text = result.bestTranscription.formattedString
                self.saveTranscriptionInDatabase(result)
            }
       }
        
        
    }
}

// MARK:- helper functions.
extension ListeningToolViewController {
    func getDocumentsDirectory() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    func getVoiceURL(audioFileName: String) -> URL {
        getDocumentsDirectory().appendingPathComponent("\(audioFileName)")
    }
}

extension ListeningToolViewController {
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // Number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return languages.count
    }
    
    // The data to return fopr the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return languages[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        language = languages[row]
        // This method is triggered whenever the user makes a change to the picker selection.
        // The parameter named row and component represents what was selected.
    }
}

extension Notification.Name {
    static let playPauseEvent = Notification.Name("PlayPauseEvent")
}

