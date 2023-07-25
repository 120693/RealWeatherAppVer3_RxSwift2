//
//  PageViewController.swift
//  RealWeatherAppVer3
//
//  Created by jhchoi on 2023/07/25.
//

import UIKit

class PageViewController: UIPageViewController {

    var viewsList: [UIViewController]
    
    init(viewsList: [UIViewController]) {
        self.viewsList = viewsList
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("PageViewController Did Load")
        
        self.dataSource = self
        
        if let vc = viewsList.first {
            self.setViewControllers([vc], direction: .forward, animated: true, completion: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("PageViewController Will Appear")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("PageViewController Did Appear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("PageViewController Will Disappear")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("PageViewController Did Disappear")
    }
}

extension PageViewController: UIPageViewControllerDataSource {
    
    // 이전 페이지 이동
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        // 현재 페이지의 뷰 컨트롤러(viewController)가 viewsList 배열의 몇 번째 요소인지 확인합니다.
        // 만약 뷰 컨트롤러가 배열에 존재하지 않는다면(lastIndex(of:)의 반환 값이 nil), nil을 반환하여 이전 페이지가 없음을 알립니다.
        
        if let resultVC = viewController as? ResultViewController {
            debugPrint("PageViewController 이젼: resultVC.cityName(\(resultVC.cityName))")
        }
        
        guard let index = viewsList.lastIndex(of: viewController) else { return nil }
        
        debugPrint("PageViewController 이젼: index(\(index))")
        
        // 이전 페이지의 인덱스
        let previousIndex = index - 1
        
        // 이전 페이지의 인덱스(previousIndex)가 0보다 작거나 같은지 확인합니다.
        // 0보다 작거나 같다면, 이전 페이지가 없으므로(viewsList 배열의 첫 번째 요소 이전을 나타내는 인덱스는 없음), nil을 반환하여 이전 페이지가 없음을 알립니다.
        guard previousIndex >= 0 else {
            debugPrint("PageViewController 이젼: guard previousIndex >= 0 else {")
            return nil
        }
        
        // 이전 페이지의 인덱스(previousIndex)가 viewsList 배열의 유효한 범위 내에 있는지 확인합니다.
        // 유효한 범위를 벗어난다면, 이전 페이지가 없으므로(viewsList 배열의 마지막 요소 이후를 나타내는 인덱스는 없음), nil을 반환하여 이전 페이지가 없음을 알립니다.
        guard previousIndex < viewsList.count else {
            debugPrint("PageViewController 이젼: guard previousIndex < viewsList.count else {")
            return nil
        }
        return viewsList[previousIndex]
    }
    
    // 다음 페이지 이동
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        if let resultVC = viewController as? ResultViewController {
            debugPrint("PageViewController 다옴: resultVC.cityName(\(resultVC.cityName))")
        }
        
        guard let index = viewsList.lastIndex(of: viewController) else {
            debugPrint("PageViewController 다옴: guard let index = viewsList.lastIndex(of: viewController) else {")
            return nil
        }
        
        debugPrint("PageViewController 다옴: index(\(index))")
        
        let previousIndex = index + 1
        guard previousIndex >= 0 else {return nil}
        guard previousIndex < viewsList.count else {
            debugPrint("PageViewController 다옴: guard previousIndex < viewsList.count else {")
            return nil
        }
        return viewsList[previousIndex]
    }
}

