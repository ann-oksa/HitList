//
//  ViewController.swift
//  HitList
//
//  Created by mac on 02.03.2023.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    var people: [NSManagedObject] = []
    var appDelegate: AppDelegate?
    var managedContext:  NSManagedObjectContext?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "My friends"
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: "Cell")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        prepareToUseCoreData()
        getAllData()
    }
    
    @IBAction func addName(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let addNoteVC = storyboard.instantiateViewController(withIdentifier: "AddNew") as? AddNew else { return }
        addNoteVC.modalTransitionStyle = .crossDissolve
        addNoteVC.modalPresentationStyle = .custom
        addNoteVC.delegate = self
        navigationController?.pushViewController(addNoteVC, animated: true)
    }
}

extension ViewController: AddNewProtocol {
    func changeCurrentNote(text: String?, index: Int?) {
        change(text: text, index: index)
       self.tableView.reloadData()
    }
   
    func addNewNoteClicked(notes: String) {
        self.save(name: notes)
        self.tableView.reloadData()
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let person = people[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = person.value(forKeyPath: "name") as? String
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentNote = people[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let addNoteVC = storyboard.instantiateViewController(withIdentifier: "AddNew") as? AddNew else { return }
        addNoteVC.modalTransitionStyle = .crossDissolve
        addNoteVC.modalPresentationStyle = .custom
        addNoteVC.delegate = self
        addNoteVC.currentNote = currentNote
        addNoteVC.currentNoteIndex = indexPath.row
        navigationController?.pushViewController(addNoteVC, animated: true)
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            remove(index: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
        }
    }
}
