//
//  PersonManager.swift
//  codeData-Demo
//
//  Created by zed on 9/17/21.
//

import Foundation
import  UIKit
import CoreData

class  PersonManger {
    
    // delegate form appDelegate coreData
    private var context = AppDelegate.viewContext
    
    func create(personModel: PersonModel) {
        let newPerson = Person(context: context)
        newPerson.name = personModel.name
        newPerson.age = personModel.age
        newPerson.image = personModel.image.pngData()
//        do {
//           try context.save()
//        }catch {
//
//        }
        
        try? context.save()
    }
    
    // this function for convert person to personModels
    func getAll() -> [PersonModel]{
        let requset:NSFetchRequest = Person.fetchRequest()
        var personModels = [PersonModel]()
        
        // $0 it is data inside of persons and it is property in side persons
        // .map it is for convert form persons to personModels
        if let persons = try? context.fetch(requset){
            personModels = persons.map({
                PersonModel(name: $0.name ?? "No userName", age: $0.age, image: UIImage(data: $0.image!) ?? UIImage(named: "placeholder")!)
            })
    return personModels
        
        }
        return []
    }
    // we use this method becouse we need person for delete
    func getAllPersons() -> [Person]{
        
        let requset:NSFetchRequest = Person.fetchRequest()

        if let persons = try? context.fetch(requset){
        
            return persons
        }
        return []
    }
    
    // paramater complition it is a call back func that we use closer func
    func delete(person:Person, complition: (_ isSuccess: Bool)-> ())  {
        
        context.delete(person)
        do {
            try context.save()
            complition(true)
        }catch{
            complition(false)
        }
        
    }
    
    func update(from person: Person, by personModel: PersonModel)  {
        
        person.name = personModel.name
        person.age = personModel.age
        person.image = personModel.image.pngData()
        
        try? context.save()
    }
    
}
