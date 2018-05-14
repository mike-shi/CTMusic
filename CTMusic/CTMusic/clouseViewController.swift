//
//  clouseViewController.swift
//  swiftMethordTest
//
//  Created by 施胡炜 on 2017/7/21.
//  Copyright © 2017年 施胡炜. All rights reserved.
//

import UIKit
import pop
import AlamofireImage
import YYText

typealias sendValueClosure = (_ string:String)->Void

class clouseViewController: UIViewController {

    var testClosure:sendValueClosure?
    

    var nameArr:[String] = ["Banana","Apple","LLL","Apple","LLL","Apple","LLL","Apple","LLL","Apple","LLL","Apple","LLL","Apple","LLL","Apple","LLL","Apple","LLL"]
    
    var nameDict:NSMutableDictionary?
    
    var chooseTypeView:ChooseTypeView?
    
    @IBOutlet weak var answerField: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let text = NSMutableAttributedString.init()
        
        for i in 0...nameArr.count - 1 {
            let tag = nameArr[i]
            let tagText = NSMutableAttributedString.init(string: tag)
            if i != 0{
            tagText.yy_insertString("   ", at: 0)
            }
            tagText.yy_appendString("   ")
            
            tagText.yy_font = UIFont.systemFont(ofSize: 17)
            
            tagText.yy_setTextBinding(YYTextBinding.init(deleteConfirm: false), range: tagText.yy_rangeOfAll())

//            tagText.yy_color = UIColor.hex
            
            
            let border = YYTextBorder.init()
            border.strokeWidth = 1.5
            border.fillColor = UIColor.blue
            border.cornerRadius = 100
            
            border.lineJoin = .bevel
            
            border.insets = UIEdgeInsetsMake(-2, -5.5, -2, -8)
            
            tagText.yy_setTextBackgroundBorder(border, range: NSString.init(string: tagText.string).range(of: tag))
            text.append(tagText)
        }
        text.yy_lineSpacing = 10
        text.yy_lineBreakMode = .byWordWrapping
        
        text.yy_appendString("\n")
        
        let textView = YYLabel.init()
        
        textView.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10)
        textView.backgroundColor = UIColor.lightGray
        textView.numberOfLines = 0
        textView.text = "asfdadsadfsgdsa"
        textView.attributedText = text
        self.view.addSubview(textView)
        
        let layout = YYTextLayout.init(containerSize: CGSize.init(width: 375 - 30, height: CGFloat(MAXFLOAT)), text: text)
        let introHeight = layout?.textBoundingSize.height;
        
//        let heigtht = self.getTextHeigh(textStr: text.string, font: UIFont.systemFont(ofSize: 17), width: 375 - 30)
        
        _ = textView.sd_layout().topSpaceToView(self.view,300)?.leftSpaceToView(self.view,15)?.rightSpaceToView(self.view,15)?.heightIs(introHeight! + 60)
        
    }
    
    func getTextHeigh(textStr:String,font:UIFont,width:CGFloat) -> CGFloat {
        
        let normalText: NSString = textStr as NSString
        let size = CGSize.init(width: width, height: 1000)
        let dic = NSDictionary(object: font, forKey: NSFontAttributeName as NSCopying)
        let stringSize = normalText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic as? [String : AnyObject], context:nil).size
        return stringSize.height
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var back: UIButton!

    @IBAction func backAvt(_ sender: Any) {
//        if (testClosure != nil){
//            testClosure!("回调传值")
//        }


        
        
        
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
