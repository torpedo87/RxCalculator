//
//  ViewController.swift
//  RxCalculator
//
//  Created by junwoo on 2017. 12. 1..
//  Copyright © 2017년 samchon. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
  
  @IBOutlet weak var inputTxtField: UITextField!
  @IBOutlet weak var converter: UISwitch!
  @IBOutlet weak var outputTxtField: UITextField!
  
  let numbers = Variable<[Int]>([])
  let result = Variable<Int>(Int())
  let bag = DisposeBag()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    bindUI()
  }
  
  func bindUI() {
    inputTxtField.rx.text.asObservable()
      .subscribe(onNext: { [weak self] value in
        guard let value = value else { return }
        let numberArr = value.components(separatedBy: " ").flatMap({ Int($0) })
        self?.numbers.value = numberArr
      })
    .disposed(by: bag)
    
    Observable.combineLatest(
      numbers.asObservable(),
      converter.rx.isOn,
      resultSelector: { (currentNumbers: [Int], isPlus: Bool) -> Int in
        if isPlus {
          return currentNumbers.reduce(0, { $0 + $1} )
        } else {
          return currentNumbers.reduce(1, { $0 * $1} )
        }
    })
    .bind(to: result)
    .disposed(by: bag)
    
    result.asObservable()
      .subscribe(onNext: { [weak self] value in
        self?.outputTxtField.text = String(value)
    })
    .disposed(by: bag)
    
    
  }
  
  
  
}

