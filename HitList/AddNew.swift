//
//  AddNew.swift
//  HitList
//
//  Created by mac on 12.03.2023.
//

import UIKit
import CoreData

protocol AddNewProtocol: AnyObject {
    func addNewNoteClicked(notes: String)
    func changeCurrentNote(text: String?, index: Int?)
}

class AddNew: UIViewController {
    
    class var identifier: String { return String(describing: self) }
    weak var delegate: AddNewProtocol?
    var currentNote: NSManagedObject?
    var currentNoteIndex: Int?
    
    @IBOutlet weak var titleTextfiled: UITextField!
    
    @IBOutlet weak var notesTextfield: UITextField!
    
    @IBOutlet weak var addButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Add New"
        titleTextfiled.placeholder = "Name/Surname"
        notesTextfield.placeholder = "Notes"
        if let note = currentNote {
            titleTextfiled.text = note.value(forKey: "name") as? String
        }
        addButton.titleLabel?.text = currentNote == nil ? "Add" : "Change"
    }
    
    @IBAction func addButtonClicked(_ sender: Any) {
        guard let textToSave = titleTextfiled.text, !textToSave.isEmpty  else { return }
        if currentNote == nil {
            delegate?.addNewNoteClicked(notes: textToSave)
        } else {
            delegate?.changeCurrentNote(text: textToSave, index: currentNoteIndex)
        }
        navigationController?.popViewController(animated: true)
    }
    
}
