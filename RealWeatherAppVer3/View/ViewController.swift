//
//  ViewController.swift
//  RealWeatherAppVer3
//
//  Created by jhchoi on 2023/07/19.
//

import UIKit

class ViewController: UIViewController {

    var viewModel = ViewModel()
    
    @IBOutlet weak var cityNameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.title = "실시간 날씨 정보"
        cityNameTextField.text = "Seoul, Gwangju, Busan, Seoul, London, BangKok"
    }

    @IBAction func resultButton(_ sender: UIButton) {
        if let input = cityNameTextField.text {
            let trimmedInput = input.replacingOccurrences(of: " ", with: "")
            let cityNames = trimmedInput.components(separatedBy: ",")
        
            getResult2(cityNames: cityNames)
        }
    }
    
    func getResult2(cityNames: [String]) {
        var viewsList: [UIViewController] = []
        for cityName in cityNames {
            let resultViewController = ResultViewController(cityName: cityName)
            viewsList.append(resultViewController)
        }
        let pageViewController = PageViewController(viewsList: viewsList)
        self.navigationController?.pushViewController(pageViewController, animated: true)
    }
}

