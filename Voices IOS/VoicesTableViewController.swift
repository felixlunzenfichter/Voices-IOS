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
    var voices : [String]!
    var chosenVoice : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        voices = getListOfVoices()

        // Uncomment the following line to preserve selection between presentations
         self.clearsSelectionOnViewWillAppear = true

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
//         self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return voices.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "VoiceTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? VoiceTableViewCell else {
            fatalError("Unwrapping of VoiceTableViewCell failed.")
        }
        
        cell.title.text = String(voices[indexPath.row].suffix(23).prefix(19))
        cell.path = voices[indexPath.row]

        // Configure the cell...

        return cell
    }
    
    
    // MARK: - Navigation
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        chosenVoice = voices[indexPath.row]
        
        if let playWindow = storyboard?.instantiateViewController(identifier: "PlayWindow") as? PlayerViewController {
            playWindow.path = chosenVoice
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
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    
    // MARK:- Private Methods
    
    func getListOfVoices() -> [String] {
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        var fileURLs : [URL]!
        do {
            fileURLs = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
            // process files
        } catch {
            print("Error while enumerating files \(documentsURL.path): \(error.localizedDescription)")
        }
        return fileURLs.map {$0.relativePath}
    }

}
