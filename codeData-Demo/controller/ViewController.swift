//
//  ViewController.swift
//  codeData-Demo
//
//  Created by zed on 9/17/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView : UITableView!
    
    var person = [Person]()
   private var personManager = PersonManger()
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        
        
        tableView.dataSource = self
        tableView.delegate = self

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("view Will Appear for show and reload data")
        // get data from CoreData or Database
        person = personManager.getAllPersons()
        
        // data reload when we add new person
        tableView.reloadData()
    }
    
}

extension ViewController: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return person.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactCellID" ,for: indexPath)
        let person = person[indexPath.row]
        
        cell.imageView?.image = UIImage(data: person.image!)
        cell.textLabel?.text = person.name
        cell.detailTextLabel?.text = "AGE: \(person.age)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let contactVC = storyboard?.instantiateViewController(withIdentifier: "contactVC") as! AddContextViewController
        contactVC.person = person[indexPath.row]
        
        show(contactVC, sender: nil)
        
        
    }
    
    
}


