//
//  PathNavigationHelper.swift
//  Voices IOS
//
//  Created by Felix Lunzenfichter on 01.10.20.
//  Copyright © 2020 Felix Lunzenfichter. All rights reserved.
//

import Foundation

class PathNavigaitonHelper {
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
