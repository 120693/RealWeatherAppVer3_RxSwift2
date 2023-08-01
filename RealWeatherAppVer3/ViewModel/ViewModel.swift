//
//  ViewModel.swift
//  RealWeatherAppVer3
//
//  Created by jhchoi on 2023/07/25.
//

import Foundation
import RxSwift
import RxCocoa
import KRProgressHUD

class ViewModel {
    
    var api = Api()
    
    let disposebag = DisposeBag()
    
    var weatherDictionary: [String:Any] = [:]
    var weatherKeys: [String] = ["name","week","coord","main", "weather","wind"]
    
    // PublishSubject
//    var weatherValues = PublishSubject<[Any]>()
//    var mainDict = PublishSubject<[String: Any]>()
//    var windDict = PublishSubject<[String: Any]>()
//    var weatherDict = PublishSubject<[String: Any]>()
//    var coordDict = PublishSubject<[String: Any]>()
    
    // BehaviorRelay
    var weatherValues = BehaviorRelay<[Any]>(value: [])
    var mainDict = BehaviorRelay<[String: Any]>(value: [:])
    var windDict = BehaviorRelay<[String: Any]>(value: [:])
    var weatherDict = BehaviorRelay<[String: Any]>(value: [:])
    var coordDict = BehaviorRelay<[String: Any]>(value: [:])
    
    var dayName: [String] = ["월","화","수","목","금","토","일"]
    var dayIcon: [String] = ["10d","01d","02d","03d","04d","11d","13d"]
        
    func getWeatherDict3(cityName: String) {
        
        KRProgressHUD.show()
        api.getApi3(cityName: cityName, completion: { [weak self] weatherDictionary in
            print("completion 시작")
            // PublishSubject
//            for (_ , value) in weatherDictionary {
//                // 배열 생성
//                var valuesArray: [Any] = []
//                valuesArray.append(value)
//                self?.weatherValues.onNext(valuesArray) // self를 약한 참조(weak)로 선언
//            }
//            if let mainDictionary = weatherDictionary["main"] as? [String: Any],
//               let windDictionary = weatherDictionary["wind"] as? [String: Any],
//               let coordDictionary = weatherDictionary["coord"] as? [String: Any],
//               let weatherArray = weatherDictionary["weather"] as? [Any],
//               let weatherDictionary = weatherArray.first as? [String: Any] {
//
//                self?.mainDict.onNext(mainDictionary)
//                self?.windDict.onNext(windDictionary)
//                self?.coordDict.onNext(coordDictionary)
//
//                var weatherValues: [String: Any] = [:]
//                for (key, value) in weatherDictionary {
//                    weatherValues[key] = value
//                }
//                self?.weatherDict.onNext(weatherValues)
//            }
//            KRProgressHUD.dismiss()
            
            // BehaviorRelay
            for (_ , value) in weatherDictionary {
                // 배열 생성
                var valuesArray: [Any] = []
                valuesArray.append(value)
                self?.weatherValues.accept(valuesArray) // self를 약한 참조(weak)로 선언
            }
            if let mainDictionary = weatherDictionary["main"] as? [String: Any],
               let windDictionary = weatherDictionary["wind"] as? [String: Any],
               let coordDictionary = weatherDictionary["coord"] as? [String: Any],
               let weatherArray = weatherDictionary["weather"] as? [Any],
               let weatherDictionary = weatherArray.first as? [String: Any] {
                
                self?.mainDict.accept(mainDictionary)
                self?.windDict.accept(windDictionary)
                self?.coordDict.accept(coordDictionary)
                
                var weatherValues: [String: Any] = [:]
                for (key, value) in weatherDictionary {
                    weatherValues[key] = value
                }
                self?.weatherDict.accept(weatherValues)
            }
            KRProgressHUD.dismiss()
        })
    }
}
