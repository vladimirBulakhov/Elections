//
//  LoginViewController.swift
//  Elections
//
//  Created by Vladimir Bulakhov on 02/05/2020.
//  Copyright © 2020 Vladimir Bulakhov. All rights reserved.
//

/*
Для входа name: "Александр", surname: "Андрющенко", numberOfPassport: "0003" пользователь еще не голосовал
Для входа name: "Владимир", surname: "Булахов", numberOfPassport: "0000" пользователь уже проголосовал

*/
import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var nameTF: UITextField!
    
    @IBOutlet weak var surnameTF: UITextField!
    
    @IBOutlet weak var NumberOfPassport: UITextField!
    
    @IBOutlet weak var button: UIButton!
    
    
    var ref: DatabaseReference!
    var citizen: Citizen?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference().child("citizens")
        button.layer.cornerRadius = 25
        //var newCitizen = Citizen(name: "Александр", surname: "Андрющенко", numberOfPassport: "0003")
        //newCitizen.ref = ref.child(newCitizen.numberOfPassport.lowercased())
        //newCitizen.ref?.setValue(newCitizen.convertToDictionary())
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func ButtonTapped(_ sender: Any) {
        
       
        if NumberOfPassport.text != ""{
            
            ref = Database.database().reference().child("citizens")
            ref = ref.child(String(NumberOfPassport.text!))
            ref.observe(DataEventType.value, with: { (snapshot) in
            let snapshotValue = snapshot.value as? [String : AnyObject] ?? [:]
            guard let name = snapshotValue["name"],let surname = snapshotValue["surname"],let numberOfPassport = snapshotValue["numberOfPassport"], let vote = snapshotValue["isCitizenVoted"] else {return}
            let nameOfCitizen = name as! String
            let surnameOfCitizen = surname as! String
            let numberOfPasspot = numberOfPassport as! String
            let isVoted = vote as! Bool
                
            let citizen = Citizen(name: nameOfCitizen, surname: surnameOfCitizen, numberOfPassport: numberOfPasspot, isCitizenVoted: isVoted, ref: self.ref)
            self.citizen = citizen
                let nameTF = self.nameTF?.text
                let surnameTF = self.surnameTF?.text
                let numberTF = self.NumberOfPassport.text
                let newCitizen = Citizen(name: nameTF!, surname: surnameTF!, numberOfPassport: numberTF!)
                print(newCitizen)
                
                if self.citizen!.name == newCitizen.name && self.citizen!.surname == newCitizen.surname && self.citizen!.numberOfPassport == newCitizen.numberOfPassport{
                
                self.performSegue(withIdentifier: "firstSegue", sender: self)
            }
        })
            }
    
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "firstSegue"{
            let vc = segue.destination as! CollectionViewController
            vc.citizen = citizen
        }
    }
    
}
