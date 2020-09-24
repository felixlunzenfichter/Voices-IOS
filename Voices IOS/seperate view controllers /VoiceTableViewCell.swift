//
//  VoiceCellTableViewCell.swift
//  Voices IOS
//
//  Created by Felix Lunzenfichter on 19.09.20.
//  Copyright © 2020 Felix Lunzenfichter. All rights reserved.
//

import UIKit
import AVFoundation

class VoiceTableViewCell: UITableViewCell, AVAudioPlayerDelegate {
    
    // MARK: - Properties
    @IBOutlet var title: UITextField!
    @IBOutlet var button: UIButton!
    var path : String!
    
    
    
    
    @IBAction func play(_ sender: Any) {
        /*
        let audioFilename = URL(fileURLWithPath: title.text!)
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audioFilename)
            audioPlayer.delegate = self
        } catch {
            // catching dick
        }
        audioPlayer.play()
        */
        
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
