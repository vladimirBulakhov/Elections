//
//  Block.swift
//  Elections
//
//  Created by Vladimir Bulakhov on 01/05/2020.
//  Copyright © 2020 Vladimir Bulakhov. All rights reserved.
//

import Foundation
import Firebase


struct Block{
    var hash: String
    var choice: String
    var previousHash: String
    var index: Int
    var ref : DatabaseReference?
    //var date: Date
    
    init(snapshot: DataSnapshot) {
    let snapshotValue = snapshot.value as! [String: AnyObject]
    hash = snapshotValue["hash"] as! String
    choice = snapshotValue["choice"] as! String
    previousHash = snapshotValue["previousHash"] as! String
    index = snapshotValue["index"] as! Int
    //date = snapshotValue["date"] as! Date
       
    ref = snapshot.ref
    }
    
    init(){
        hash = ""
        choice = ""
        previousHash = ""
        index = 0
    }
    
    func generateHash()-> String{
        return NSUUID().uuidString.replacingOccurrences(of: "-", with: "")
    }
    func convertToDictionary() -> Any {
        return ["hash": hash , "choice": choice, "previousHash": previousHash, "index" : index]
    }
    
    
}
