//
//  PDFViewController.swift
//  swiftMethordTest
//
//  Created by 施胡炜 on 2018/1/9.
//  Copyright © 2018年 施胡炜. All rights reserved.
//

import UIKit
import PDFGenerator

class PDFViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func createPDF(_ sender: Any) {
        let v1 = UIView(frame: CGRect(x: 0.0,y: 0, width: 375, height: 667))
        v1.backgroundColor = .red
        let v2 = UIView(frame: CGRect(x: 0.0,y: 0, width: 375, height: 375))
        v2.backgroundColor = .green
        
        let page1 = PDFPage.view(v1)
        let page2 = PDFPage.view(v2)
        let page3 = PDFPage.whitePage(CGSize.init(width: 375, height: 375))

        let pages = [page1, page2, page3]
        
        let dst = NSTemporaryDirectory().appending("sample1.pdf")
        do {
            try PDFGenerator.generate(pages, to: dst)
            openPDFViewer(dst)
        } catch (let e) {
            print(e)
        }
    }
    
    fileprivate func openPDFViewer(_ pdfPath: String) {
        let url = URL(fileURLWithPath: pdfPath)
        let storyboard = UIStoryboard(name: "PDFPreviewVC", bundle: nil)
        let vc = storyboard.instantiateInitialViewController() as! PDFPreviewVC
        vc.setupWithURL(url)
        present(vc, animated: true, completion: nil)
    }
    
}
