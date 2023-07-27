//
//  Api.swift
//  RealWeatherAppVer3
//
//  Created by jhchoi on 2023/07/25.
//

import Foundation
import RxSwift

class Api {
    func getApi(cityName: String) async throws -> [String:Any] {
        var components = URLComponents()
        
        let scheme = "https"
        let host = "api.openweathermap.org"
        let apiKey = "a8c1d55d8c112dbe5f0576f243f507ac"
        
        components.scheme = scheme
        components.host = host
        components.path = "/data/2.5/weather"
        components.queryItems = [URLQueryItem(name: "q", value: cityName), URLQueryItem(name: "appid", value: apiKey)]
        
        let url = components.url!
        
        let request = URLRequest(url: url)
        
        let session = URLSession(configuration: .default)
        
        let (data, _) = try await session.data(for: request)
        // data(for:) 함수를 비동기적으로 호출하고, 요청이 완료된 후에 data 변수에 결과 데이터를 할당 -> try await 붙인 이유
        
        let decoder = JSONDecoder()
        let weatherModel = try? decoder.decode(WeatherModel.self, from: data)
        // debugPrint(weatherModel)
        let weatherDictionary = self.encodeModelToDictionary(model: weatherModel)

        return weatherDictionary!
    }
    
    func getApi2(cityName: String) -> Observable<[String:Any]> {
        return Observable.create() { emitter in
            DispatchQueue.global().async {
                
                var components = URLComponents()
                
                let scheme = "https"
                let host = "api.openweathermap.org"
                let apiKey = "a8c1d55d8c112dbe5f0576f243f507ac"
                
                components.scheme = scheme
                components.host = host
                components.path = "/data/2.5/weather"
                components.queryItems = [URLQueryItem(name: "q", value: cityName), URLQueryItem(name: "appid", value: apiKey)]
                
                let url = components.url!
                
                let request = URLRequest(url: url)
                
                let session = URLSession(configuration: .default)
                
                let task = session.dataTask(with: request) { data, _ , error in
                    guard error == nil else {
                        emitter.onError(error!)
                        return
                    }
                    
                    DispatchQueue.main.async {
                        
                        if let data = data {
                            let decoder = JSONDecoder()
                            
                            let weatherModel = try? decoder.decode(WeatherModel.self, from: data)
                            
                            let weatherDictionary = self.encodeModelToDictionary(model: weatherModel)
                            
                            emitter.onNext(weatherDictionary!)
                            //print("weatherDictionary! \(weatherDictionary!)")
                        }
                        emitter.onCompleted()
                    }
                }
                task.resume()
                print("1")
            }
            return Disposables.create()
        }
    }
    
    func encodeModelToDictionary<T: Codable>(model: T) -> [String: Any]? {
        guard let jsonData = try? JSONEncoder().encode(model) else {
               return nil
           }
        guard let dictionary = try? JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? [String: Any] else {
               return nil
           }
        return dictionary
    }
}
