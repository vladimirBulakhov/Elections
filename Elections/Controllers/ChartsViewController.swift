//
//  ChartsViewController.swift
//  Elections
//
//  Created by Vladimir Bulakhov on 04/05/2020.
//  Copyright © 2020 Vladimir Bulakhov. All rights reserved.
//

import UIKit
import Charts
import Firebase

class ChartsViewController: UIViewController {
    
    var putinValue = PieChartDataEntry(value: 0)
    var baburinValue = PieChartDataEntry(value: 0)
    var grudininValue = PieChartDataEntry(value: 0)
    var jirinovskiyValue = PieChartDataEntry(value: 0)
    var sobchakValue = PieChartDataEntry(value: 0)
    var suraykinValue = PieChartDataEntry(value: 0)
    var titovValue = PieChartDataEntry(value: 0)
    var YavlinskiyValue = PieChartDataEntry(value: 0)
    var candidates : [Candidate]?
    @IBOutlet weak var pieChart: PieChartView!
    
    var blockChain = Blockchain()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pieChart.chartDescription?.text = "ГОЛОСОВАНИЕ "
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       let blockChainRef = Database.database().reference().child("blockChain")
        blockChainRef.observe(.value, with: { (snapshot) in
            
            var chain = [Block]()
            for item in snapshot.children {
                let block = Block(snapshot: item as! DataSnapshot)
                chain.append(block)
                
            }
            self.blockChain.chain = chain
            self.setChoices(blockChain: self.blockChain.chain)
        })
        pieChart.chartDescription?.text = "ГОЛОСОВАНИЕ"
        
        
        setChoices(blockChain: blockChain.chain)
        
        
    }
    

    
    
    func setChoices(blockChain :[Block]){
        
        self.candidates = Candidate.fillArray()
        
        
        for block in blockChain{
            for candidate in candidates!{
                if block.choice == candidate.shortName {
                    self.candidates![candidate.index].votes += 1
                }
            }
            pieChart.chartDescription?.text = "ГОЛОСОВАНИЕ"
            putinValue.value = Double(self.candidates![0].votes)
            putinValue.label = "Путин"
            baburinValue.value = Double(self.candidates![1].votes)
            baburinValue.label = "Бабурин"
            grudininValue.value = Double(self.candidates![2].votes)
            grudininValue.label = "Грудинин"
            jirinovskiyValue.value = Double(self.candidates![3].votes)
            jirinovskiyValue.label = "Жириновский"
            sobchakValue.value = Double(self.candidates![4].votes)
            sobchakValue.label = "Собчак"
            suraykinValue.value = Double(self.candidates![5].votes)
            suraykinValue.label = "Сурайкин"
            titovValue.value = Double(self.candidates![6].votes)
            titovValue.label = "Титов"
             YavlinskiyValue.value = Double(self.candidates![7].votes)
            YavlinskiyValue.label = "Явлинский"
            
            putinValue.value = 10
            baburinValue.value = 1
            grudininValue.value = 1
            jirinovskiyValue.value = 1
            sobchakValue.value = 1
            suraykinValue.value = 1
            titovValue.value = 1
            YavlinskiyValue.value = 1
 
            let allVotes = [putinValue,baburinValue,grudininValue,jirinovskiyValue,sobchakValue,suraykinValue,titovValue,YavlinskiyValue]
            
            let chatDataSet = PieChartDataSet(entries: allVotes, label: nil)
            chatDataSet.colors = [.black,.blue,.systemGreen,.orange,.purple,.red,.systemGray,.systemPink]
            let chartData = PieChartData(dataSet: chatDataSet)
            pieChart.data = chartData
            
        }
    }
    
}
