//
//  ChatViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import FirebaseAuth

class ChatViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    
    var messages: [Message] = [
    
        Message(sender: "zaini@outlook.com", body: "Hello"),
        Message(sender: "Ali@outlook.com", body: "Hi"),
        Message(sender: "zaini@outlook.com", body: "What's up?")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = K.appName;
        navigationItem.hidesBackButton = true;
        tableView.dataSource = self;
        
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        
        messageTextfield.text = "";
    }
    
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        
        do {
          try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true);
        } catch let signOutError as NSError {
          print("Error signing out: %@", signOutError)
            
        }
    }
    
}

extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MessageCell;
        //var content = cell.defaultContentConfiguration();
        //content.text = messages[indexPath.row].body;
        cell.label.text = messages[indexPath.row].body;
        return cell;
    }
}
