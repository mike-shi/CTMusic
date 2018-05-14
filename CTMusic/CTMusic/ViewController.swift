//
//  ViewController.swift
//  swiftMethordTest
//
//  Created by 施胡炜 on 2017/6/19.
//  Copyright © 2017年 施胡炜. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    var DigestArr: [Int] = [51,55,45,96,32,11,54,44,88,77,36]
    
    var strArr :[String] = ["213" ,"fdgd","asd","gdfg","asf","fgrt"]
    
    @IBOutlet weak var label1: UILabel!
    
    @IBOutlet weak var label2: UILabel!
    
    @IBOutlet weak var textField1: UITextField!
    
    @IBOutlet weak var textField2: UITextField!
    
    @IBOutlet weak var btn1: UIButton!
    
    @IBOutlet weak var btn2: UIButton!
    
    @IBOutlet weak var segMentView: UISegmentedControl!
    
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let price = Double(3)
        let str = "实际到账：" + String(format: "￥%.2f", price/100)
        
        let insertArr = strArr.joined(separator: "|")
        
        print(insertArr)
        
        print("dsvv" + str)

        exampleZip()
        
        map()
        
        let arr = [3,2,4]
        
        
        let resultArr:[Int] = twoSum(arr, 6)
        
        print(resultArr)
        
        let count = lengthOfLongestSubstring("pwwkew")
        
        print(count)
        
        
        let scheme = "action=pay&sid=3"

        
        let titleView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 375, height: 30))
        
        let text = UITextField.init(frame: CGRect.init(x: 12, y: 0, width: titleView.width - 12, height: 30))
        titleView.addSubview(text)
        
        text.clearButtonMode = .whileEditing
        
        titleView.backgroundColor = UIColor.lightGray
        
        self.navigationItem.titleView = titleView
        
//        let c2 = NSString.encode(toPercentEscape: c)
//        
//        let c3 = NSString.init(string: scheme).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlPathAllowed)
//        
//        let number = NSDecimalNumber.init(string: "30.489")
//        
//        let zero = NSDecimalNumber.init(string: "0")
//        
//        let roundingBehavior = NSDecimalNumberHandler.init(roundingMode: .plain, scale: 2, raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: false)
//
//        let t = number.adding(zero, withBehavior: roundingBehavior)
        
        bindText()
        
        
        
    }
    
    func lengthOfLongestSubstring(_ s: String) -> Int {
        var arr:[String] = []

        for i in 0 ..< s.characters.count {
            let c = NSString.init(string: s).substring(with: NSMakeRange(i, 1))
            if !arr.contains(c) {
                arr.append(c)
            }
        }
        arr.sort()
        print(arr)
        return arr.count
    }
    
    func twoSum(_ nums: [Int], _ target: Int) -> [Int] {
        
        for i in 0 ..< nums.count {
            for j in 0..<i{
                if nums[j] == target - nums[i]{
                    return [i,j]
                }
            }
        }
        return [0,0]
    }
    
    func bindText(){
        btn1.rx.tap.subscribe(onNext: { [weak self] x in
            self?.label2.text = "btn1 taped"
            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "clouseViewController")
            self?.navigationController?.pushViewController(vc, animated: true)
            
        }).disposed(by: bag)

        segMentView.rx.value.subscribe(onNext: { [weak self] x in
            self?.label2.text = "segment value is \(x) "
        }).disposed(by: bag)
    }
    
    func exampleFilter()  {
        
        Observable.of(
            "🐱3", "🐰2", "🐶1",
            "🐸33", "🐱22", "🐰11",
            "🐹333", "🐸222", "🐱111")
            .filter {
                $0.contains("2")
            }
            .subscribe(onNext: { print($0) })
            .disposed(by: bag)
        
    }
    
    func exampleZip() {
        let disposeBag = DisposeBag()
        
//        let stringSubject = PublishSubject<String>()
//        let intSubject = PublishSubject<Int>()
        
        Observable.zip(textField1.rx.text.orEmpty,textField2.rx.text.orEmpty) { (textValue1,textValue2) -> String in
            
           return "\(textValue1) \(textValue2)"
            }.map{  $0.description   }
            .bind(to: label1.rx.text)
        .disposed(by: disposeBag)
    }
    
    func exampleMerge() {
        let disposeBag = DisposeBag()
        
        let subject1 = PublishSubject<String>()
        let subject2 = PublishSubject<String>()
        
        Observable.of(subject1, subject2)
        .merge()
        .subscribe(onNext: { print($0) })
        .disposed(by: disposeBag)
        
        subject1.onNext("🅰️")
        
        subject1.onNext("🅱️")
        
        subject2.onNext("①")
        
        subject2.onNext("②")
        
        subject1.onNext("🆎")
        
        subject2.onNext("③")
    }
    
    func consult(){
        Observable.combineLatest(textField1.rx.text.orEmpty,textField2.rx.text.orEmpty) { (textValue1,textValue2) -> Int in
            return (Int(textValue1) ?? 0) + (Int(textValue2) ?? 0)
        }.map {  $0.description   }
        .bind(to: label1.rx.text).disposed(by: bag)
    }
    
    func map()  {
        let mapResult = DigestArr.map {$0 + 2}
        print(mapResult)
        let mapResult2 = DigestArr.map {"mike\($0)"}
        print(mapResult2)
        
        let flatMap = strArr.flatMap {$0 + "|"}
        print(flatMap)
    }
    

    func myInterval(_ interval: TimeInterval) -> Observable<Int> {
        return Observable.create { observer in

            let timer = DispatchSource.makeTimerSource(queue: DispatchQueue.global())
            timer.scheduleRepeating(deadline: DispatchTime.now() + interval, interval: interval)
            
            let cancel = Disposables.create {

                timer.cancel()
            }
            
            var next = 0
            timer.setEventHandler {
                if cancel.isDisposed {
                    return
                }
                observer.on(.next(next))
                next += 1
            }
            timer.resume()
            
            return cancel
        }
    }
    
    
    func printStart()  {
        
        let counter = myInterval(0.1)
        
        print("Started ----")
        
        let subscription1 = counter
            .subscribe(onNext: { n in

            })
        let subscription2 = counter
            .subscribe(onNext: { n in
                print("Second \(n)")
            })
        
        Thread.sleep(forTimeInterval: 0.5)
        
        subscription1.dispose()
        
        Thread.sleep(forTimeInterval: 0.5)
        
        subscription2.dispose()
        
        print("Ended ----")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

