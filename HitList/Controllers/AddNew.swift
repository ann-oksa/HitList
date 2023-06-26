//
//  AddNew.swift
//  HitList
//
//  Created by mac on 12.03.2023.
//

import UIKit
import CoreData

protocol AddNewDelegate: AnyObject {
    func addNewNoteClicked(notes: String)
    func changeCurrentNote(text: String?, index: Int?)
}

final class AddNew: UIViewController {

    // MARK: - Outlets
    @IBOutlet private weak var titleTextfiled: UITextField!
    @IBOutlet private weak var notesTextfield: UITextField!
    @IBOutlet private weak var addButton: UIButton!

    // MARK: - Private properties
    weak var delegate: AddNewDelegate?
    private let constant = Constant.shared

    // MARK: - Other
    class var identifier: String { return String(describing: self) }
    var currentNote: NSManagedObject?
    var currentNoteIndex: Int?

    // MARK: - LifecycleMethods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
}

private extension AddNew {
    func setupView() {
        title = constant.newName
        titleTextfiled.placeholder = constant.nameSurname
        notesTextfield.placeholder = constant.notes
        if let note = currentNote {
            titleTextfiled.text = note.value(forKey: constant.name) as? String
        }
        addButton.titleLabel?.text = currentNote == nil ? constant.add : constant.change
        addButton.addTarget(self, action: #selector(addButtonClicked), for: .touchUpInside)
    }

    @objc func addButtonClicked() {
        guard let textToSave = titleTextfiled.text, !textToSave.isEmpty  else { return }
        if currentNote == nil {
            delegate?.addNewNoteClicked(notes: textToSave)
        } else {
            delegate?.changeCurrentNote(text: textToSave, index: currentNoteIndex)
        }
        navigationController?.popViewController(animated: true)
    }
}
