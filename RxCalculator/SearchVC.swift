//
//  SearchVC.swift
//  RxCalculator
//
//  Created by junwoo on 2017. 12. 1..
//  Copyright © 2017년 samchon. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SearchVC: UIViewController, UITableViewDataSource {
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var searchBar: UISearchBar!
  
  var shownCities = [String]()
  let disposeBag = DisposeBag()
  let allCities = ["New York", "London", "Oslo", "Warsaw", "Berlin", "Praga"]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.dataSource = self
    
    searchBar
      .rx.text // RxCocoa의 Observable 속성
      .orEmpty // 옵셔널이 아니도록 만듭니다.
      .debounce(0.5, scheduler: MainScheduler.instance) // 0.5초 기다립니다.
      .distinctUntilChanged() // 새로운 값이 이전의 값과 같은지 확인합니다.
      .filter { !$0.isEmpty } // 새로운 값이 정말 새롭다면, 비어있지 않은 쿼리를 위해 필터링합니다.
      .subscribe(onNext: { [unowned self] query in // 이 부분 덕분에 모든 새로운 값에 대한 알림을 받을 수 있습니다.
        self.shownCities = self.allCities.filter { $0.hasPrefix(query) } // 도시를 찾기 위한 “API 요청” 작업을 합니다.
        self.tableView.reloadData() // 테이블 뷰를 다시 불러옵니다.
      })
      .disposed(by: disposeBag)
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return shownCities.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cityPrototypeCell", for: indexPath)
    cell.textLabel?.text = shownCities[indexPath.row]
    
    return cell
  }
  
}

