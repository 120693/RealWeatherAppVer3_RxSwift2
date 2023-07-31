//
//  Api.swift
//  RealWeatherAppVer3
//
//  Created by jhchoi on 2023/07/25.
//

import Foundation
import RxSwift

class Api {    
    func getApi3(cityName: String, completion: @escaping (_ :[String:Any])->()) {
        
        print("Api호출")
        
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
        
        session.dataTask(with: request) { data, _ , error in
            if let data = data {
                let decoder = JSONDecoder()
                
                let weatherModel = try? decoder.decode(WeatherModel.self, from: data)
                
                let weatherDictionary = self.encodeModelToDictionary(model: weatherModel)
                
                DispatchQueue.main.async {
                    completion(weatherDictionary!)
                    print("completion 완료")
                }
            }
        }.resume()
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
