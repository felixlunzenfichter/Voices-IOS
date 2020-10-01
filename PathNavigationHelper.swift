//
//  PathNavigationHelper.swift
//  Voices IOS
//
//  Created by Felix Lunzenfichter on 01.10.20.
//  Copyright © 2020 Felix Lunzenfichter. All rights reserved.
//

import Foundation

class PathNavigationHelper {
    func getDocumentsDirectory() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    func getVoiceURL(audioFileName: String) -> URL {
        getDocumentsDirectory().appendingPathComponent("\(audioFileName)")
    }
}
