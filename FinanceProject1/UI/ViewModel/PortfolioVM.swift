//
//  PortfolioVM.swift
//  FinanceProject1
//
//  Created by Fatih Emre Sarman on 13.02.2024.
//

import Foundation
import RxSwift
import RxCocoa

class PortfolioVM {
    private let portfolioRepo: PortfolioDaoRepo
    private let disposeBag = DisposeBag()

    private var portfolioData = BehaviorRelay<[Exchange]>(value: [])

    var portfolioObservable: Observable<[Exchange]> {
        return portfolioData.asObservable()
    }

    init(portfolioRepo: PortfolioDaoRepo) {
        self.portfolioRepo = portfolioRepo
    }
    
    func updatePortfolio() {
        portfolioRepo.getPortfolioForCurrentUser()
            .subscribe(onNext: { [weak self] portfolio in
                self?.portfolioData.accept(portfolio)
            }, onError: { error in
                print("Hata oluştu: \(error.localizedDescription)")
            })
            .disposed(by: disposeBag)
    }
}
