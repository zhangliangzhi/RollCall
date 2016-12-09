//
//  AddClassMemberViewController.swift
//  RollCall
//
//  Created by ZhangLiangZhi on 2016/12/9.
//  Copyright © 2016年 xigk. All rights reserved.
//

import UIKit

class AddClassMemberViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var textNum: UITextField!
    @IBOutlet weak var textName: UITextField!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        textNum.delegate = self
        textName.delegate = self
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == textNum {
            textName.becomeFirstResponder()
        }else if textField == textName {
            textField.resignFirstResponder()
        }
        return true
    }

    @IBAction func addOneMember(_ sender: Any) {
        
    }
    
}
