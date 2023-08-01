//
//  ResultViewController.swift
//  RealWeatherAppVer3
//
//  Created by jhchoi on 2023/07/25.
//

import UIKit
import RxSwift
import Kingfisher

public func kToC(kelvin: Double) -> String {
    let celsius: Double
    let result: String
    
    celsius = kelvin - 273.15
    
    result = String(format:"%.2f", celsius) + "°C"
    
    return result
}

class ResultViewController: UIViewController {
        
    var api = Api()
    
    var viewModel = ViewModel()
    
    let disposebag = DisposeBag()
    
    var cityName:String
    
    @IBOutlet weak var tableView: UITableView!
    
    init(cityName: String) {
        self.cityName = cityName
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // BehaviorRelay 사용했을 경우
        viewModel.getWeatherDict3(cityName: cityName)
        debugPrint("ResultViewController viewDidLoad(\(self.cityName))")
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "HeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "HeaderView")
        tableView.register(UINib(nibName: "WeekTableViewCell", bundle: nil), forCellReuseIdentifier: "WeekTableViewCell")
        tableView.register(UINib(nibName: "CollectionTableViewCell", bundle: nil), forCellReuseIdentifier: "CollectionTableViewCell")
        tableView.register(UINib(nibName: "FooterView", bundle: nil), forHeaderFooterViewReuseIdentifier: "FooterView")
    }
    override func viewWillAppear(_ animated: Bool) {
        // PublishSubject를 사용할 것이면 여기에 viewModel.getWeatherDict(cityName: cityName) 실행
        super.viewWillAppear(animated)
        debugPrint("ResultViewController viewWillAppear(\(cityName))")
        // viewModel.getWeatherDict3(cityName: cityName) // PublishSubject 사용했을 경우
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        debugPrint("ResultViewController viewDidAppear(\(cityName))")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        debugPrint("ResultViewController viewWillDisAppear(\(cityName))")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        debugPrint("ResultViewController viewDidDisAppear(\(cityName))")
    }
}

extension ResultViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        debugPrint("ResultViewController numberOfSections(\(cityName))")
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return viewModel.dayName.count
        }
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "HeaderView") as! HeaderView
        
        if section == 0 {
                view.cityNameLabel.text = cityName
            
            viewModel.weatherDict
                .observe(on: MainScheduler.instance) // UI 관련 작업은 메인 스레드에서 이벤트 처리
                .subscribe(onNext: { [weak view] weatherDict in // .subscribe(onNext:) 메서드를 사용하여 Observable을 구독합니다. 이렇게 하면 Observable에서 이벤트가 발생할 때마다 클로저가 실행
                        guard let view = view else { return }
                        if let icon = weatherDict["icon"] as? String {
                            let urlString = "https://openweathermap.org/img/wn/\(icon)@2x.png"
                            if let url = URL(string: urlString) {
                                view.iconImageView.kf.setImage(with: url)
                                view.iconImageView.contentMode = .scaleAspectFill
                            }
                        }
                    })
                .disposed(by: disposebag)
                        
            viewModel.mainDict
                .observe(on: MainScheduler.instance)
                .subscribe(onNext: { [weak view] mainDict in
                    guard let view = view else { return }
                    if let maxTemp = mainDict["temp_max"] as? Double {
                        view.maxTempLabel.text = "최고:" + kToC(kelvin: maxTemp)
                    }
                    if let temp = mainDict["temp"] as? Double {
                        view.currentTempLabel.text = kToC(kelvin: temp)
                    }
                    if let minTemp = mainDict["temp_min"] as? Double {
                        view.minTempLabel.text = "최저:" + kToC(kelvin: minTemp)
                    }
                })
                .disposed(by: disposebag)
            
            return view
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return "7일간의 일기예보"
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {

        if section == 0 {
            return 250
        }
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 0 {
            let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "FooterView") as! FooterView
            
            return view
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {

        if section == 0 {
            
            return 160
        }
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CollectionTableViewCell", for: indexPath) as! CollectionTableViewCell
            
            viewModel.mainDict
                .observe(on: MainScheduler.instance)
                .subscribe(onNext: { mainDict in
                    cell.mainData(with: mainDict)
                })
                .disposed(by: disposebag)
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "WeekTableViewCell", for: indexPath) as! WeekTableViewCell
            
            cell.dayName.text = viewModel.dayName[indexPath.row]
            
            guard let url = URL(string: "https://openweathermap.org/img/wn/\(viewModel.dayIcon[indexPath.row])@2x.png") else { return cell}
            
            cell.dayIcon.kf.setImage(with: url)
            cell.dayIcon.contentMode = .scaleAspectFill

            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 150
        } else {
            return UITableView.automaticDimension
        }
    }
}
