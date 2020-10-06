//
//  ShareViewController.swift
//  importVocieExtension
//
//  Created by Felix Lunzenfichter on 05.10.20.
//  Copyright © 2020 Felix Lunzenfichter. All rights reserved.
//

import UIKit
import Social
import CoreData

class ShareViewController: SLComposeServiceViewController {

    override func isContentValid() -> Bool {
        // Do validation of contentText and/or NSExtensionContext attachments here
        return true
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
            let container = NSPersistentContainer(name: "Model")
            container.loadPersistentStores { description, error in
                if let error = error {
                    fatalError("Unable to load persistent stores: \(error)")
                }
            }
            return container
        }()

    override func didSelectPost() {
        // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
    
        let attachments = (self.extensionContext?.inputItems.first as? NSExtensionItem)?.attachments ?? []

        let contentType : String = "com.apple.m4a-audio"
        
        for provider in attachments {
            print("provider: \(provider)")
            if provider.hasItemConformingToTypeIdentifier(contentType) {
                provider.loadItem(forTypeIdentifier: contentType, options: nil, completionHandler: {(maybeURL, error) in
                    // Handle the error here if you want
                    guard error == nil else { print("Error loading item data from provider in extension"); return}
                    print("data: \(maybeURL)")
                    let url = maybeURL as! URL
                    print("url: \(url)")
                    let audioData: Data
                    print(self.getDocumentsDirectory())
                    do {
                        audioData = try Data(contentsOf: url)
                    } catch {
                        print(error)
                        return
                    }
                    print(audioData)
                    let voiceTitle = self.getCurrentTimeStamp().appending(".m4a")
                    let targetURL = self.getVoiceURL(audioFileName: voiceTitle)
                    print(targetURL)
                    self.persistentContainer.saveVoice(voiceName: voiceTitle)
                    do {
                        try audioData.write(to: targetURL)
                    } catch {
                        print(error)
                    }
                })
            }
        }
        // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
        self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
    }

    override func configurationItems() -> [Any]! {
        // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
        return []
    }
}

// MARK:- helper functions.
extension ShareViewController {
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

extension NSPersistentContainer {
    func saveVoice(voiceName: String) {
        let voice = Voice(context: self.viewContext)
        voice.title = voiceName
        voice.filename = voiceName
        do {
            try self.viewContext.save()
        } catch {
            print(error)
        }
    }
}



