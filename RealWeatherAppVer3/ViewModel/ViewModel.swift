//
//  ViewModel.swift
//  RealWeatherAppVer3
//
//  Created by jhchoi on 2023/07/25.
//

import Foundation
import RxSwift
import RxCocoa

class ViewModel {
    
    var api = Api()
    
    let disposebag = DisposeBag()
    
    var weatherInfo: [String:Any] = [:]
    var weatherKeys: [String] = ["name","week","coord","main", "weather","wind"]
    
    var weatherValues = PublishSubject<[Any]>()
    var mainDict = PublishSubject<[String: Any]>()
    var windDict = PublishSubject<[String: Any]>()
    var weatherDict = PublishSubject<[String: Any]>()
    var coordDict = PublishSubject<[String: Any]>()
    
    var dayName: [String] = ["월","화","수","목","금","토","일"]
    var dayIcon: [String] = ["10d","01d","02d","03d","04d","11d","13d"]
        
    func getWeatherDict3(cityName: String) {
        
        api.getApi3(cityName: cityName, completion: { [weak self] weatherInfo in
            print("completion 시작")
            for (_ , value) in weatherInfo {
                // 배열 생성
                var valuesArray: [Any] = []
                valuesArray.append(value)
                self?.weatherValues.onNext(valuesArray)
            }
            if let mainDictionary = weatherInfo["main"] as? [String: Any],
               let windDictionary = weatherInfo["wind"] as? [String: Any],
               let coordDictionary = weatherInfo["coord"] as? [String: Any],
               let weatherArray = weatherInfo["weather"] as? [Any],
               let weatherDictionary = weatherArray.first as? [String: Any] {
                
                self?.mainDict.onNext(mainDictionary)
                self?.windDict.onNext(windDictionary)
                self?.coordDict.onNext(coordDictionary)
                
                var weatherValues: [String: Any] = [:]
                for (key, value) in weatherDictionary {
                    weatherValues[key] = value
                }
                self?.weatherDict.onNext(weatherValues)
            }
        })
    }
}
