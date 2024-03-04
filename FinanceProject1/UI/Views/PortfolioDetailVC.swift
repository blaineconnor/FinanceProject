//
//  PortfolioDetailVC.swift
//  FinanceProject1
//
//  Created by Fatih Emre Sarman on 13.02.2024.
//

import UIKit

class PortfolioDetailVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let appearance = UINavigationBarAppearance()
        
        appearance.titleTextAttributes = [ .font: UIFont(name: "Roboto-Medium", size: 22)!]
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        
        // Do any additional setup after loading the view.
    }

}
