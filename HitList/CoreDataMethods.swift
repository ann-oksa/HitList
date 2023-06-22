//
//  CoreDataMethods.swift
//  HitList
//
//  Created by mac on 12.03.2023.
//

import UIKit
import CoreData

//extension ViewController {
//    func prepareToUseCoreData() {
//        self.appDelegate = UIApplication.shared.delegate as? AppDelegate
//        self.managedContext = appDelegate?.persistentContainer.viewContext
//    }
//    
//    func getAllData() {
//        let fetchRequest =
//        NSFetchRequest<NSManagedObject>(entityName: "Person")
//        
//        do {
//            guard let managedContext = self.managedContext else { return }
//            people = try managedContext.fetch(fetchRequest)
//        } catch let error as NSError {
//            print("Could not fetch. \(error), \(error.userInfo)")
//        }
//    }
//    func save(name: String) {
//        guard let managedContext = self.managedContext else { return }
//        let entity = NSEntityDescription.entity(forEntityName: "Person",
//                                                in: managedContext)!
//        let person = NSManagedObject(entity: entity,
//                                     insertInto: managedContext)
//        person.setValue(name, forKeyPath: "name")
//        
//        do {
//            try managedContext.save()
//            people.append(person)
//        } catch let error as NSError {
//            print("Could not save. \(error), \(error.userInfo)")
//        }
//    }
//    
//    func remove(index: Int) {
//        guard let managedContext = self.managedContext else { return }
//        managedContext.delete(self.people[index])
//        people.remove(at: index)
//        do {
//            try  managedContext.save()
//        } catch let error as NSError {
//            print("Could not remove. \(error), \(error.userInfo)")
//        }
//    }
//    
//    func change(text: String?, index: Int?) {
//        guard let managedContext = self.managedContext,
//        let index = index else { return }
//        people[index].setValue(text, forKeyPath: "name")
//        do {
//            try  managedContext.save()
//        } catch let error as NSError {
//            print("Could not change. \(error), \(error.userInfo)")
//            
//        }
//    }
//}
