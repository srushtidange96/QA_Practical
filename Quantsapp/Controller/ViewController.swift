//
//  ViewController.swift
//  Quantsapp
//
//  Created by Srushti Dange on 20/07/22.
//

import UIKit

struct jsonData {
    var all = [[String:[[String:String]]]]()
}

class ViewController: UIViewController {

    @IBOutlet weak var btnnCheck:                  UIButton!
    var final_Dict                                 = [[String:[[String:String]]]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        initConfig()
    }
    func initConfig(){
        self.title = "First"
        parseData()
        btnnCheck.layer.cornerRadius = btnnCheck.frame.height/2
        btnnCheck.addTarget(self, action: #selector(btnCheckClicked), for: .touchUpInside)
    }

    @objc func btnCheckClicked() {
        //Call API
        let vc = SecondVC()
        vc.arrData = final_Dict
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func parseData(){
        let apiUrl = URL(string: "https://qapptemporary.s3.ap-south-1.amazonaws.com/test/synopsis.json")!
        
        let dataTask = URLSession.shared.dataTask(with: apiUrl) { (data, response, error) in
            guard let data = data, error == nil else {
                return
            }
            do {
                let result = try JSONDecoder().decode(Json4Swift_Base.self, from: data)
                let l = result.l ?? ""
                let s = result.s ?? ""
                let sc = result.sc ?? ""
                let lu = result.lu ?? ""
                
                var temp_l = [[String:String]]()
                var temp_sc = [[String:String]]()
                var temp_s = [[String:String]]()
                var temp_lu = [[String:String]]()
                
                
                let l_data = l.components(separatedBy: ";")
                let sc_data = sc.components(separatedBy: ";")
                let s_data = s.components(separatedBy: ";")
                let lu_data = lu.components(separatedBy: ";")
                
                for i in l_data {
                    let new_data = i.components(separatedBy: ",")
                    let dict = ["symbol":new_data[0],"price":new_data[1],"open_interest":new_data[2],"price_change":new_data[3],"open_interest_change":new_data[4],"color":"#00ff00"]
                    temp_l.append(dict)
                }
                
                for i in sc_data {
                    let new_data = i.components(separatedBy: ",")
                    let dict = ["symbol":new_data[0],"price":new_data[1],"open_interest":new_data[2],"price_change":new_data[3],"open_interest_change":new_data[4],"color":"#ffff00"]
                    temp_sc.append(dict)
                }
                
                for i in s_data {
                    let new_data = i.components(separatedBy: ",")
                    let dict = ["symbol":new_data[0],"price":new_data[1],"open_interest":new_data[2],"price_change":new_data[3],"open_interest_change":new_data[4],"color":"#ff0000"]
                    temp_s.append(dict)
                }
                
                for i in lu_data {
                    let new_data = i.components(separatedBy: ",")
                    let dict = ["symbol":new_data[0],"price":new_data[1],"open_interest":new_data[2],"price_change":new_data[3],"open_interest_change":new_data[4],"color":"#00d0f9"]
                    temp_lu.append(dict)
                }
                
                let merged_all = Dictionary((temp_l+temp_sc+temp_s+temp_lu).map{($0["symbol"]!,Array($0))}){$0 + $1}
                    .map{Dictionary($1 as [(String,String)]){$1}}
                self.final_Dict.insert(["all":merged_all], at: 0)
                self.final_Dict.insert(["l":temp_l], at: 1)
                self.final_Dict.insert(["sc":temp_sc], at: 2)
                self.final_Dict.insert(["s":temp_s], at: 3)
                self.final_Dict.insert(["lu":temp_lu], at: 4)
            }catch {
                print(error)
            }
        }
        dataTask.resume()
    }
}

