//
//  PortfolioVC.swift
//  FinanceProject1
//
//  Created by Fatih Emre Sarman on 13.02.2024.
//

import UIKit
import DGCharts
import RxSwift
import RxCocoa

class PortfolioVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
   
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pieChartView: PieChartView!
    
    var portfolioVM: PortfolioVM!
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [.font: UIFont(name: "Roboto-Medium", size: 22)!]
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance

        
    }
    override func viewWillAppear(_ animated: Bool) {
        portfolioVM = PortfolioVM(portfolioRepo: PortfolioDaoRepo())

        portfolioVM.updatePortfolio()
        
        setupPieChart()
    }
    
    func setupPieChart() {
        portfolioVM.portfolioObservable
            .subscribe(onNext: { [weak self] portfolio in
                guard let self = self else { return }
                
                let dataEntries = portfolio.map { (exchange) -> PieChartDataEntry in
                    return PieChartDataEntry(value: exchange.Miktar ?? 0.0, label: exchange.Kur)
                }
                
                let dataSet = PieChartDataSet(entries: dataEntries, label: "")
                self.pieChartView.data = PieChartData(dataSet: dataSet)
                
                dataSet.colors = ChartColorTemplates.material()
                
                self.pieChartView.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
            })
            .disposed(by: disposeBag)
    }
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rowCount = 0
        portfolioVM.portfolioObservable
            .subscribe(onNext: { portfolio in
                rowCount = portfolio.count
            })
            .disposed(by: disposeBag)

        return rowCount
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PortfolioTVC", for: indexPath) as! PortfolioTVC

        portfolioVM.portfolioObservable
            .subscribe(onNext: { portfolio in
                let exchange = portfolio[indexPath.row]
                cell.configureCell(withForexName: exchange.Kur ?? "", Miktar: "\(exchange.Miktar ?? 0.0)", Deger: "\(exchange.Deger ?? 0.0)")
            })
            .disposed(by: disposeBag)

        return cell
    }

}



