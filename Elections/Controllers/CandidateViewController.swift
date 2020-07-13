//
//  CandidateViewController.swift
//  Elections
//
//  Created by Vladimir Bulakhov on 30/04/2020.
//  Copyright © 2020 Vladimir Bulakhov. All rights reserved.
//

import UIKit
import Firebase

class CandidateViewController: UIViewController {
    var citizen: Citizen?
    var SelectedCanidate: Candidate?
    var blockChainRef: DatabaseReference?
    var blockChain = Blockchain()
    
    @IBOutlet weak var imageViewCandidate: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var textViewCandidate: UITextView!
    
    @IBOutlet weak var button: UIButton!
    
    @IBOutlet weak var votedLabel: UILabel!
        
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageViewCandidate.image = UIImage(named: SelectedCanidate!.image)
        nameLabel.text = SelectedCanidate?.name
        textViewCandidate.text = SelectedCanidate?.description
        if citizen!.isCitizenVoted{
            button.isHidden = true
            votedLabel.isHidden = false
        } else {
            button.isHidden = false
            votedLabel.isHidden = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        blockChainRef = Database.database().reference().child("blockChain")
        blockChainRef?.observe(.value, with: { (snapshot) in
            
            var chain = self.blockChain.chain
            for item in snapshot.children {
                let block = Block(snapshot: item as! DataSnapshot)
                chain.append(block)
            }
            self.blockChain.chain = chain
            print(self.blockChain.chain.count)

        })
    }
    

    @IBAction func buttonTaped(_ sender: Any) {
        let alertController = UIAlertController(title: "Вы уверены?", message: "Вы точно хотите отдать голос за этого кандидата? Вы больше не сможете изменить свой выбор!", preferredStyle: .alert)
        let OkAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            print(self!.blockChain.chain.count)
            let citizen = self?.citizen
            if citizen?.isCitizenVoted == false{
            let ref = citizen?.ref
                let post = ["name": citizen?.name as Any,
                            "surname": citizen?.surname as Any,
                            "numberOfPassport": citizen?.numberOfPassport as Any,
                            "isCitizenVoted": true] as [String : Any]
            ref?.updateChildValues(post)
                //self!.citizen?.isCitizenVoted = true
                
                if self?.blockChain.chain.count == 0 {
                    self!.blockChain.createGenesisBlock(choice: self!.SelectedCanidate!.shortName)
                    
                    var block = self!.blockChain.chain[self!.blockChain.chain.count - 1]
                    block.ref = self!.blockChainRef!.child(String(block.index).lowercased())
                    block.ref?.setValue(block.convertToDictionary())
                } else {
                    self!.blockChain.createBlock(choice: self!.SelectedCanidate!.shortName)
                    
                    var block = self!.blockChain.chain[self!.blockChain.chain.count - 1]
                    block.ref = self!.blockChainRef!.child(String(block.index).lowercased())
                    block.ref?.setValue(block.convertToDictionary())
                }
                self!.button.isHidden = true
                self!.votedLabel.isHidden = false
                
            } else{
                print ("Вы уже голосовали")
            }
            self!.dismiss(animated: true)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(OkAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    
    
    
}
