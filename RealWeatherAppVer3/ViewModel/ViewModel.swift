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
    
    var weatherInfo: [String:Any]?
    var weatherKeys: [String] = ["name","week","coord","main", "weather","wind"]
    
    var weatherValues = BehaviorRelay<[Any]>(value: [])
    var mainDict = BehaviorRelay<[String: Any]>(value: [:])
    var windDict = BehaviorRelay<[String: Any]>(value: [:])
    var weatherDict = BehaviorRelay<[String: Any]>(value: [:])
    var coordDict = BehaviorRelay<[String: Any]>(value: [:])
    
    var dayName: [String] = ["월","화","수","목","금","토","일"]
    var dayIcon: [String] = ["10d","01d","02d","03d","04d","11d","13d"]
    
    func getWeatherDict(cityName: String) {
        Task {
            do {
                debugPrint("ResultViewController getWeatherDict(\(cityName))")
                weatherInfo = try await api.getApi(cityName: cityName)
                
                debugPrint("ResultViewController weatherInfo()")
                
                if let weatherInfo = weatherInfo {
                    for (_ , value) in weatherInfo {
                        // 배열 생성
                        var valuesArray: [Any] = []
                        valuesArray.append(value)
                        
                        weatherValues.accept(valuesArray)
                    }
                }
                
                if let dictionary = weatherInfo,
                   let mainDictionary = dictionary["main"] as? [String: Any],
                   let windDictionary = dictionary["wind"] as? [String: Any],
                   let coordDictionary = dictionary["coord"] as? [String: Any],
                   let weatherArray = dictionary["weather"] as? [Any],
                   let weatherDictionary = weatherArray.first as? [String: Any] {
                    
                    mainDict.accept(mainDictionary)
                    windDict.accept(windDictionary)
                    coordDict.accept(coordDictionary)
                    
                    var weatherValues: [String: Any] = [:]
                    for (key, value) in weatherDictionary {
                        weatherValues[key] = value
                    }
                    weatherDict.accept(weatherValues)
                }
            } catch {
                debugPrint("ResultViewController Error(\(error))")
            }
        }
    }
}
