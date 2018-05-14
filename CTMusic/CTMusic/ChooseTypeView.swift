//
//  ChooseTypeView.swift
//  S4SFinancialClient
//
//  Created by 施胡炜 on 2017/9/21.
//  Copyright © 2017年 zikong. All rights reserved.
//

import UIKit

class ChooseTypeView: UIView {
    
    @IBOutlet var sendCarer: UIStackView!
    @IBOutlet var sendCarerView: UIView!
    
    @IBOutlet var sendToShopUser: UIStackView!
    @IBOutlet var sendToShopUserView: UIView!
    
    @IBOutlet var sendOnlineShop: UIStackView!
    @IBOutlet var sendOnlineShopView: UIView!
    
    @IBOutlet var codeSend: UIStackView!{
        didSet{
            codeSend.isHidden = true
        }
    }
    @IBOutlet var sendCodeView: UIView!
    
    
    var selectClosure: ((_ type:Int) -> Void)?
    
    @IBAction func selectTypeAction(_ sender: UIButton) {
        self.selectClosure?(sender.tag)
    }
 
    class func createTypeView() -> ChooseTypeView {
        let typeView = UINib(nibName: "ChooseTypeView", bundle: Bundle.main).instantiate(withOwner: nil, options: nil)[0] as! ChooseTypeView
        return typeView
    }

    

}
