//
//  VoiceCellTableViewCell.swift
//  Voices IOS
//
//  Created by Felix Lunzenfichter on 19.09.20.
//  Copyright © 2020 Felix Lunzenfichter. All rights reserved.
//

import UIKit
import AVFoundation

class VoiceTableViewCell: UITableViewCell{
    
    // MARK: - Properties

    @IBOutlet var date: UILabel!
    @IBOutlet var title: UILabel!
    @IBOutlet var language: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }


}
