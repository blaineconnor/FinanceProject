//
//  FavoritesVC.swift
//  FinanceProject1
//
//  Created by Fatih Emre Sarman on 13.02.2024.
//

import UIKit
import RxSwift

class FavoritesVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var vm = FavoritesVM()
    var cur = [Kurlar]()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let appearance = UINavigationBarAppearance()
        
        appearance.titleTextAttributes = [ .font: UIFont(name: "Roboto-Medium", size: 22)!]
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        
        tableView.dataSource = self
    }
    
    
    @IBAction func favButtonTapped(_ sender: UIButton) {
    }
    
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
           getFavorites()
       }
       
       func getFavorites() {
           vm.getFavorites(forUser: 1)
               .subscribe(onNext: { [weak self] kurls in
                   self?.cur = kurls
                   self?.tableView.reloadData()
               }, onError: { error in
                   print("Error fetching favorites: \(error)")
               })
               .disposed(by: disposeBag)
       }
}

extension FavoritesVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cur.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FavoritesTVC", for: indexPath) as? FavoritesTVC else {
            fatalError("Cell is not of type FavoritesVC")
        }
        
        let forex = cur[indexPath.row]
        cell.configureCell(withForexName: forex.forexName, alis: "\(forex.alis)", satis: "\(forex.satis)", isFavorite: vm.isFavorite(forex))
        
        cell.favBtn.addTarget(self, action: #selector(favoriteButtonTapped(_:)), for: .touchUpInside)
        
        return cell
    }
    
    @objc func favoriteButtonTapped(_ sender:UIButton){
        guard let cell = sender.superview?.superview as? FavoritesTVC,
              let indexPath = tableView.indexPath(for: cell) else {
            return
        }
        
        let forex = cur[indexPath.row]
        vm.toggleFavorite(for: forex)
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}
