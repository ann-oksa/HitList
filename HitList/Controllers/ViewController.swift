//
//  ViewController.swift
//  HitList
//
//  Created by mac on 02.03.2023.
//

import UIKit
import CoreData

final class ViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var addNewNameButton: UIBarButtonItem!

    // MARK: - Private properties
    private let constant = Constant.shared
    private var people: [NSManagedObject] = []
    private var appDelegate: AppDelegate?
    private var managedContext: NSManagedObjectContext?

    // MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        prepareToUseCoreData()
        getAllData()
    }
}

private extension ViewController {
    func setupView() {
        tableView.delegate = self
        tableView.dataSource = self
        title = constant.titleMyFriend
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: constant.cell)
        addNewNameButton.target = self
        addNewNameButton.action = #selector(goToAddNewNameVC)
    }

    @objc func goToAddNewNameVC() {
        let storyboard = UIStoryboard(name: constant.storyboardMain, bundle: nil)
        guard let addNewNameVC = storyboard.instantiateViewController(withIdentifier: constant.addNewName) as? AddNew else { return }
        addNewNameVC.modalTransitionStyle = .crossDissolve
        addNewNameVC.modalPresentationStyle = .custom
        addNewNameVC.delegate = self
        navigationController?.pushViewController(addNewNameVC, animated: true)
    }
}

extension ViewController: AddNewDelegate {
    func changeCurrentNote(text: String?, index: Int?) {
        change(text: text, index: index)
        tableView.reloadData()
    }

    func addNewNoteClicked(notes: String) {
        save(name: notes)
        tableView.reloadData()
    }
}

// MARK: - CoreDataMethods
private extension ViewController {
    func prepareToUseCoreData() {
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        managedContext = appDelegate?.persistentContainer.viewContext
    }

    func getAllData() {
        let fetchRequest =
        NSFetchRequest<NSManagedObject>(entityName: constant.entityNamePerson)

        do {
            guard let managedContext = managedContext else { return }
            people = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    func save(name: String) {
        guard let managedContext = managedContext else { return }
        let entity = NSEntityDescription.entity(forEntityName: constant.entityNamePerson,
                                                in: managedContext)!
        let person = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        person.setValue(name, forKeyPath: constant.name)

        do {
            try managedContext.save()
            people.append(person)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }

    func remove(index: Int) {
        guard let managedContext = managedContext else { return }
        managedContext.delete(people[index])
        people.remove(at: index)
        do {
            try  managedContext.save()
        } catch let error as NSError {
            print("Could not remove. \(error), \(error.userInfo)")
        }
    }

    func change(text: String?, index: Int?) {
        guard let managedContext = managedContext,
              let index = index else { return }
        people[index].setValue(text, forKeyPath: constant.name)
        do {
            try  managedContext.save()
        } catch let error as NSError {
            print("Could not change. \(error), \(error.userInfo)")

        }
    }
}
// MARK: - Table View
extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let person = people[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: constant.cell, for: indexPath)
        cell.textLabel?.text = person.value(forKeyPath: constant.name) as? String
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentNote = people[indexPath.row]
        let storyboard = UIStoryboard(name: constant.storyboardMain, bundle: nil)
        guard let addNewNameVC = storyboard.instantiateViewController(withIdentifier: constant.addNewName) as? AddNew else { return }
        addNewNameVC.modalTransitionStyle = .crossDissolve
        addNewNameVC.modalPresentationStyle = .custom
        addNewNameVC.delegate = self
        addNewNameVC.currentNote = currentNote
        addNewNameVC.currentNoteIndex = indexPath.row
        navigationController?.pushViewController(addNewNameVC, animated: true)
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
