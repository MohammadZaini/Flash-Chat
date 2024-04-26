//
//  ChatViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class ChatViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    
    var messages: [Message] = [
        
        Message(sender: "zaini@outlook.com", body: "Hello"),
        Message(sender: "Ali@outlook.com", body: "Hi"),
        Message(sender: "zaini@outlook.com", body: "What's up?")
    ]
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = K.appName;
        navigationItem.hidesBackButton = true;
        tableView.dataSource = self;
        
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        
        loadMessages()
    }
    
    func loadMessages() {
        
        db.collection(K.FStore.collectionName).addSnapshotListener { QuerySnapshot, error in
            self.messages = [];
            if let e = error {
                print(e.localizedDescription)
            }  else {
                
                if let snapshotDocuments = QuerySnapshot?.documents {
                    for doc in snapshotDocuments  {
                        let data = doc.data()
                        if let messageSender = data[K.FStore.senderField] as? String, let message  = data[K.FStore.bodyField] as? String {
                            let newMessage = Message(sender: messageSender, body: message)
                            self.messages.insert(newMessage,at: 0);
                            
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                        }
                    }
                }
            }
        }
        
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        
        if let messageBody = messageTextfield.text , let sender = Auth.auth().currentUser?.email {
            
            db.collection(K.FStore.collectionName).addDocument(data: [
                K.FStore.senderField: sender,
                K.FStore.bodyField: messageBody
            ]) { error in
                if let e = error {
                    print(e.localizedDescription)
                } else {
                    print("Succeded!")
                    self.messageTextfield.text = "";
                }
            }
        }
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
