import UIKit
import FirebaseAuth
import FirebaseFirestore

class ChatViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    
    var messages: [Message] = []
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messageTextfield.delegate = self
        tableView.dataSource = self
        navigationItem.hidesBackButton = true
        title = K.nameApp
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        
        loadMessage()
    }
    
    func loadMessage() -> Void {
        db.collection(K.FStore.collectionName).addSnapshotListener { (querySnapshot, err) in
            self.messages = []
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                if let document = querySnapshot?.documents {
                    for doc in document {
                        let data = doc.data()
                        if let sender = data[K.FStore.senderField] as? String, let body = data[K.FStore.bodyField] as? String {
                            self.messages.append(Message(sender: sender, body: body))
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                                print(self.messages)
                            }
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        if let messageBody = messageTextfield.text, let messageSender = Auth.auth().currentUser?.email {
            //var message = Message(sender: messageSender, body: messageBody)
            db.collection(K.FStore.collectionName).addDocument(data: [K.FStore.senderField : messageSender, K.FStore.bodyField : messageBody]) { err in
                if let err = err {
                    print("Error adding data: \(err)")
                } else {
                    print("Data added successfully")
                }
            }
        }
    }
    
    @IBAction func LogOutPressed(_ sender: UIBarButtonItem) {
        do {
          try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
          print("Error signing out: %@", signOutError)
        }
    }
    
}

extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MessageCell
        cell.label.text = messages[indexPath.row].body
        return cell
    }
    
}

extension ChatViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
}
