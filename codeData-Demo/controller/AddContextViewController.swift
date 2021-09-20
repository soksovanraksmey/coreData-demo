//
//  AddContextViewController.swift
//  codeData-Demo
//
//  Created by zed on 9/17/21.
//

import UIKit

class AddContextViewController: UIViewController {

    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var ageText: UITextField!
    @IBOutlet weak var actionButton: UIButton!
    
    private let personManager = PersonManger()
    var person:Person?
    var imagePickerController = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapkey = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        tapkey.cancelsTouchesInView = false
        view.addGestureRecognizer(tapkey)
  
        
        imageView.image = #imageLiteral(resourceName: "user")
        imagePickerController.delegate = self
        
        
        // update addContactController to updateController
        if let p = person{
            print("update contact")
            title = "Update Contact"
            imageView.image = UIImage(data: p.image!)
            nameText.text = p.name
            ageText.text = "\(p.age)"
            actionButton.setTitle("upDate", for: .normal)
            
            // add remore item to navigationBar
            let removeBtn = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteContact))
            
            navigationItem.rightBarButtonItem = removeBtn
            
        }else{
            print("add contact")
        }
        
        imageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapImage))
        imageView.addGestureRecognizer(tap)
        
    }
    func choseImage(type:UIImagePickerController.SourceType){
        self.imagePickerController.sourceType = type
        self.imagePickerController.allowsEditing = true
        present(self.imagePickerController, animated: true, completion: nil)
    }
    
    @objc func tapImage(){
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Photo", style: .default, handler: { (action) in
            self.choseImage(type:.photoLibrary )
        }))
        alert.addAction(UIAlertAction(title: "cameta", style: .default, handler: { (action) in
            self.choseImage(type: .camera)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @objc func deleteContact(){
        print("remove")
        let alert = UIAlertController(title: "Delete Contact", message: "Are you sure ?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (action) in
            
            self.personManager.delete(person: self.person!) { (isSucess) in
                if isSucess{
                    self.navigationController?.popViewController(animated: true)
                }else{
                    print("something was wrong")
                }
            }
            
        }))
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func submitBTn(_ sender: Any) {
        
        guard let name = nameText.text else {return}
        guard let age = Int16(ageText.text ?? "") else {return}
        guard let image = imageView.image else { return }
        
        let personModel = PersonModel(name: name , age: age, image: image)
        
        // check condition for using button one ban 2 action
        if let person = person {
            // update button
            personManager.update(from: person, by: personModel)
            
        }else{
            // create button
            personManager.create(personModel: personModel)
        }
        
        print("save success")
        navigationController?.popViewController(animated: true)
        
    }
    
}

extension AddContextViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
       

        if let img = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
               {
            imageView.image = img

               }
        else if let img = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
               {
            imageView.image = img
               }
        dismiss(animated: true, completion: nil)
    }
 
}
