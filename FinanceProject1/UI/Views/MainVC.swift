//
//  ViewController.swift
//  FinanceProject1
//
//  Created by Fatih Emre Sarman on 12.02.2024.
//

import UIKit

class MainVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cur.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let currency = cur[indexPath.row]
        let collectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "GridViewCell", for: indexPath) as! GridViewCell
        
        collectionCell.configureCell(withForexName: currency.forexName ?? " ", alis: String(currency.alis ?? 0.0), satis: String(currency.satis ?? 0.0))
        
        return collectionCell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cur.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currency = cur[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListViewCell", for: indexPath) as! ListViewCell
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.aliceBlue
        cell.selectedBackgroundView = backgroundView
        
        cell.configureCell(withForexName: currency.forexName ?? " ", alis: String(currency.alis ?? 0.0), satis: String(currency.satis ?? 0.0))
        
        print("Kur: \(String(describing: currency.forexName))")
        
        return cell
    }
    
    
    @IBOutlet weak var toggleButton: UIBarButtonItem!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    
    
    var cur = [Kurlar]()
    var vm = MainVM()
    
    var isGridView = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Hoşgeldiniz"
        
        
        let appearance = UINavigationBarAppearance()
        
        appearance.titleTextAttributes = [ .font: UIFont(name: "Roboto-Medium", size: 22)!]
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        tableView.isHidden = true
        collectionView.isHidden = false
        
        toggleButton.setSymbolImage(.grid, contentTransition: .automatic)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        _ = vm.cur.subscribe(onNext: {liste in
            self.cur = liste
            self.tableView.reloadData()
            self.collectionView.reloadData()
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DispatchQueue.global().async {
            self.vm.getToken(/*private*/) { result in
                switch result {
                case .success(let token):
                    print("Token received: \(token)")
                    self.vm.getKurListe(token: token) { result in
                        switch result {
                        case .success(let data):
                            self.cur = data
                            
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                                self.collectionView.reloadData()
                            }
                        case .failure(let error):
                            print("Error getting token: \(error)")
                        }
                    }
                case .failure(let error):
                    print("Error getting token: \(error)")
                }
            }
        }
    }
    
    
    @IBAction func toggleBtn(_ sender: Any) {
        
        if tableView.isHidden {
            
            tableView.isHidden = false
            collectionView.isHidden = true
            
            toggleButton.image = UIImage(named: "list")
        } else {
            tableView.isHidden = true
            collectionView.isHidden = false
            
            toggleButton.image = UIImage(named: "grid")
        }
    }
}


extension MainVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        // Section insets (distance from boundary )
        return UIEdgeInsets(top: 16, left: 16, bottom: 0, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 8
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let collectionViewWidth = collectionView.frame.width - 32
        _ =  collectionView.frame.width
        
        let cellWidth = (collectionViewWidth-16) / 3
        let cellHeight = cellWidth
        
        return CGSize(width: cellWidth , height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        cell.alpha = 0
        UIView.animate(withDuration: 0.5, delay: 0.05 * Double(indexPath.row), animations: {
            cell.alpha = 1
        })
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        cell.alpha = 0
        UIView.animate(withDuration: 0.5, delay: 0.05 * Double(indexPath.row), animations: {
            cell.alpha = 1
        })
    }

}




