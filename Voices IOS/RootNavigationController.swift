//
//  MyNavigationController.swift
//  Voices IOS
//
//  Created by Felix Lunzenfichter on 28.09.20.
//  Copyright © 2020 Felix Lunzenfichter. All rights reserved.
//

import UIKit
import CoreData

class RootNavigationController: UINavigationController {
    
    var container: NSPersistentContainer!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard container != nil else {
            fatalError("This view needs a persistent container.")
        }

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
