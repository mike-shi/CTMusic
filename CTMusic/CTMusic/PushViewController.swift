//
//  PushViewController.swift
//  swiftMethordTest
//
//  Created by 施胡炜 on 2017/9/4.
//  Copyright © 2017年 施胡炜. All rights reserved.
//

import UIKit
import RxSwift

class PushViewController: UIViewController {

    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let button = UIButton.init(frame: .init(x: 15, y: 15, width: 40, height: 40))
        
        button.setTitle("╳", for: .normal)
        
        self.view.addSubview(button)
        
        button.rx.tap.subscribe { [weak self] x in
            
            
        }.addDisposableTo(bag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
