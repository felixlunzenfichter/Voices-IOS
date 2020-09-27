//
//  PlayerViewController.swift
//  Voices IOS
//
//  Created by Felix Lunzenfichter on 20.09.20.
//  Copyright © 2020 Felix Lunzenfichter. All rights reserved.
//

import UIKit
import AVFoundation

class PlayerViewController: UIViewController {

    @IBOutlet var progressBar: UIProgressView!
    @IBOutlet var play: UIButton!
    @IBOutlet var pause: UIButton!
    @IBOutlet var textLabel: UILabel!
    
    
    
    var path: String!
    
    
    fileprivate func initializePathLabel() {
        textLabel.text = path
        textLabel.numberOfLines = 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializePathLabel()
        // Do any additional setup after loading the view.
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
