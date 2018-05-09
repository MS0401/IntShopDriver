//
//  FortgotPasswordController.swift
//  IntShopDriver
//
//  Created by Olexandr on 10/30/17.
//  Copyright © 2017 Olexandr. All rights reserved.
//

import UIKit

class FortgotPasswordController: UIViewController {
    
    @IBOutlet var email: UITextField!
    @IBOutlet var sequrity: UILabel!
    @IBOutlet var answer: UITextField!
    @IBOutlet var tableView: UITableView!
    
    let answerQuestions = ["Your brand first car", "Your pet's name", "Your teacher name", "Our company name"]
    
    var flag = true
    var tapGestureRecogniser = UITapGestureRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tapGestureRecogniser = UITapGestureRecognizer(target: self, action: #selector(FortgotPasswordController.SelectingQuestion(_:)))
        tapGestureRecogniser.numberOfTapsRequired = 1
        tapGestureRecogniser.numberOfTouchesRequired = 1
        self.sequrity.addGestureRecognizer(tapGestureRecogniser)
        self.sequrity.isUserInteractionEnabled = true
        
        self.Initialize()
    }
    
    func SelectingQuestion(_ sender: UITapGestureRecognizer) {
        
        if flag {
            self.flag = false
            UIView.transition(with: self.tableView, duration: 0.3, options: .transitionCurlDown, animations: { self.tableView.isHidden = false }, completion: nil)
            
            
            
        } else {
            self.flag = true
            UIView.transition(with: self.tableView, duration: 0.3, options: .transitionCurlUp, animations: { self.tableView.isHidden = true }, completion: nil)
            
            
        }
    }
    
    func Initialize() {
        self.tableView.isHidden = true        
        self.tableView.layer.cornerRadius = 5
        self.tableView.layer.masksToBounds = true
    }
    
    @IBAction func BacktoLogin(_ sender: UIButton) {
//        self.dismiss(animated: true, completion: nil)
        let  vc =  self.navigationController?.viewControllers.filter({$0 is ViewController}).first
        self.navigationController?.popToViewController(vc!, animated: true)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


extension FortgotPasswordController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.answerQuestions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "sequrity", for: indexPath) as! SecurityCell
        cell.answerType.text = self.answerQuestions[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.sequrity.text = self.answerQuestions[indexPath.row]
        self.flag = true
        UIView.transition(with: self.tableView, duration: 0.3, options: .transitionCurlUp, animations: { self.tableView.isHidden = true }, completion: nil)
    }
    
}
