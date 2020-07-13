//
//  Blockchain.swift
//  Elections
//
//  Created by Vladimir Bulakhov on 02/05/2020.
//  Copyright © 2020 Vladimir Bulakhov. All rights reserved.
//

import Foundation
import Firebase

class Blockchain {
    var chain = [Block]()
    var blockChainRef = Database.database().reference().child("blockChain")
    func createGenesisBlock(choice: String){
        var genesisBlock = Block()
        genesisBlock.hash = genesisBlock.generateHash()
        genesisBlock.choice = choice
        //genesisBlock.data = data
        genesisBlock.previousHash = "0000"
        genesisBlock.index = 0
        chain.append(genesisBlock)
    }
    
    func createBlock(choice: String){
        var newBlock = Block()
        newBlock.hash = newBlock.generateHash()
        newBlock.choice = choice
        //newBlock.data = data
        newBlock.previousHash = chain[chain.count-1].hash
        newBlock.index = chain.count
        chain.append(newBlock)
        
    }
}
