//
//  VoicesTableViewController.swift
//  Voices IOS
//
//  Created by Felix Lunzenfichter on 19.09.20.
//  Copyright © 2020 Felix Lunzenfichter. All rights reserved.
//

import UIKit
import CoreData


class VoicesTableViewController: UITableViewController {
    
    // MARK: - Properties
    var voices: [Voice]!

    private lazy var persistentContainer: PersistentContainer = {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        return appDelegate!.persistentContainer
    }()
 
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = true
        persistentContainer.listViewDelegate = self
        fetchVoices()
    }
    
    @IBAction func RecordNewVoiceButtonPressed(_ sender: Any) {
        if let recordingView = storyboard?.instantiateViewController(identifier: "RecordingView") as? RecorderViewController {
            navigationController?.pushViewController(recordingView, animated: true)
        }
    }
    
    func fetchVoices() {
        do {
            try self.voices = persistentContainer.viewContext.fetch(Voice.fetchRequest())
        } catch {
            print(error)
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

// MARK: - Navigation
extension VoicesTableViewController {

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let ListeningView = storyboard?.instantiateViewController(identifier: "PlayWindow") as? ListeningToolViewController {
            ListeningView.voice = voices[indexPath.row]
            navigationController?.pushViewController(ListeningView, animated: true)
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
}

// MARK: - tableView functions
extension VoicesTableViewController {
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
        cell.title.text = voices[indexPath.row].title
        
    }
}

extension VoicesTableViewController : ContentUpdateDelegate {
    func refreshList() {
        fetchVoices()
    }
}


