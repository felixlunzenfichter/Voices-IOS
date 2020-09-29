//
//  VoicesTableViewController.swift
//  Voices IOS
//
//  Created by Felix Lunzenfichter on 19.09.20.
//  Copyright © 2020 Felix Lunzenfichter. All rights reserved.
//

import UIKit



class VoicesTableViewController: UITableViewController {
    
    // MARK: - Properties
    var voices : [URL]!
    var chosenVoice : URL?
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        voices = getListOfVoices()

        // Uncomment the following line to preserve selection between presentations
         self.clearsSelectionOnViewWillAppear = true
    }
    
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return voices.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : VoiceTableViewCell = getVoiceCell(tableView, indexPath)
        initializeVoiceCell(cell, indexPath)
        
        return cell
    }
    
    fileprivate func getVoiceCell( _ tableView: UITableView, _ indexPath: IndexPath) -> VoiceTableViewCell{
        let cellIdentifier = "VoiceTableViewCell"
        return tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? VoiceTableViewCell ?? VoiceTableViewCell()
    }
    
    fileprivate func initializeVoiceCell(_ cell: VoiceTableViewCell, _ indexPath: IndexPath) {
        let timeStamp: String = String(String(voices[indexPath.row]).suffix(23).prefix(19))
        cell.title.text = timeStamp
        cell.path = voices[indexPath.row]
    }
    
    // MARK: - Navigation
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        chosenVoice = voices[indexPath.row]
        
        if let playWindow = storyboard?.instantiateViewController(identifier: "PlayWindow") as? ListeningToolViewController {
            playWindow.voicePath = chosenVoice
            navigationController?.pushViewController(playWindow, animated: true)
        }
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        unselectRow(animated)
    }
    
    fileprivate func unselectRow(_ animated: Bool) {
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedIndexPath, animated: animated)
        }
    }

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
            move into trash bin.
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */
    
    @IBAction func refreshButtonPressed(_ sender: Any) {
        voices = getListOfVoices()
        self.tableView.reloadData()
    }
    
    // MARK:- Private Methods
    
    func getListOfVoices() -> [URL] {
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        var fileURLs : [URL]!
        do {
            fileURLs = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
            // process files
        } catch {
            print("Error while enumerating files \(documentsURL.path): \(error.localizedDescription)")
        }
        return fileURLs
    }

}
