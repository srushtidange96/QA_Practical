//
//  SecondVC.swift
//  Quantsapp
//
//  Created by Srushti Dange on 20/07/22.
//

import UIKit

class SecondVC: UIViewController {
    
    @IBOutlet weak var stackView:           UIStackView!
    @IBOutlet weak var topView:             UIView!
    @IBOutlet weak var collectionView:      UICollectionView!
    
    //MARK:- Variables
    var arrData                             = [[String:[[String:String]]]]()
    var filteredData                        = [[String:String]]()
    var arrCVData                           = [[String:String]]()
    var isSearchActive                      = false
    var btnBarSearch                        :UIBarButtonItem!
    var btnBarCancel                        :UIBarButtonItem!
    var searchBar                           :UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        // Set up all UI related Stuff
        self.initConfig()
    }
    func initConfig() {
        // Navigation
       self.collectionView.register(UINib(nibName: "StocksCVCell", bundle: nil), forCellWithReuseIdentifier: "StocksCVCell")
       self.collectionView.alwaysBounceVertical = true
       setUpNavigation()
       setupInitialView()
    }
    func setUpNavigation(){
        //Navigation title design
        let btnSearch = UIButton(type: .custom)
        btnSearch.setTitle("Search", for: .normal)
        btnSearch.setTitleColor(.blue, for: .normal)
        btnSearch.addTarget(self, action: #selector(btnBarSearchClicked), for: .touchUpInside)
        let menuBarItem = UIBarButtonItem(customView: btnSearch)
        btnBarSearch = menuBarItem
        self.navigationItem.rightBarButtonItem = btnBarSearch
        self.title = "Second"
    }
    
    func setupInitialView() {
        //Initially "ALL" data has to be seen when loaded
        let abc = arrData[0]
        for (_,val) in abc {
            arrCVData = val
        }
        self.arrCVData = self.arrCVData.sorted { (($0["open_interest_change"]!) as AnyObject).localizedStandardCompare((($1["open_interest_change"]! as AnyObject) as! String)) == ComparisonResult.orderedDescending }
        filteredData = arrCVData
        
        //Seting up dynamic stack of buttons for response keys eg: 1, lu, s, sc
        for (index,i) in arrData.enumerated(){
            for (key,_ ) in i {
                let button = UIButton()
                button.tag = index
                button.setTitle(key.uppercased(), for: .normal)
                button.setTitleColor(.black, for: .normal)
                button.alpha = key == "all" ? 1 : 0.5
                switch key {
                case "all":
                    button.backgroundColor = UIColor.init(hexString: "#FDA01D")
                    break
                case "l":
                    button.backgroundColor = UIColor.init(hexString: "#00ff00")
                    break
                case "lu":
                    button.backgroundColor = UIColor.init(hexString: "#00d0f9")
                    break
                case "s":
                    button.backgroundColor = UIColor.init(hexString: "#ff0000")
                    break
                case "sc":
                    button.backgroundColor = UIColor.init(hexString: "#ffff00")
                    break
                default:
                    button.backgroundColor = UIColor.white
                    break
                }
                button.addTarget(self, action: #selector(populateData(_:)), for: .touchUpInside)
                button.translatesAutoresizingMaskIntoConstraints = false
                button.heightAnchor.constraint(equalToConstant: 30).isActive = true
                button.layer.cornerRadius = button.frame.height/2
                button.layer.masksToBounds = false
                button.layoutIfNeeded()
                stackView.alignment = .center
                stackView.distribution = .fillEqually
                stackView.spacing = 10.0
                stackView.addArrangedSubview(button)
            }
        }
    }
    
    @objc func btnBarSearchClicked() {
        self.setupSearchBar()
    }
    func setupSearchBar() {
        //Search bar UI and handling events
        searchBar = UISearchBar(frame: CGRect.zero)
        searchBar.delegate = self
        searchBar.isTranslucent = false
        searchBar.placeholder = "Search"
        searchBar.showsCancelButton = true
        searchBar.selectedScopeButtonIndex = 1
        searchBar.tintColor = .black
        searchBar.searchBarStyle = .default
        let cancelButtonAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        UIBarButtonItem.appearance(whenContainedInInstancesOf:
                                    [UISearchBar.self]).setTitleTextAttributes(cancelButtonAttributes, for: .normal)
        if let textfield = searchBar.value(forKey: "searchField") as? UITextField {
            textfield.textColor = UIColor.black
            textfield.backgroundColor = UIColor.white
        }
        self.navigationItem.titleView = searchBar
        searchBar.alpha = 1
        searchBar.becomeFirstResponder()
    }
    @objc func populateData(_ sender:UIButton) {
        // Click events of dynamic stack button
        filteredData.removeAll()
        arrCVData.removeAll()
        for item in stackView.arrangedSubviews {
            if let items = item as? UIButton {
                if sender.tag == items.tag{
                    sender.alpha = (sender.tag == items.tag) ? 1 : 0.5
                }else{
                    items.alpha = 0.5
                }
            }
        }
        let abc = arrData[sender.tag]
        for (_,val) in abc {
            arrCVData = val
        }
        //sorting based on "open_interest_change" in desc order
        self.arrCVData = self.arrCVData.sorted { (($0["open_interest_change"]!) as AnyObject).localizedStandardCompare((($1["open_interest_change"]! as AnyObject) as! String)) == ComparisonResult.orderedDescending }
        filteredData = arrCVData
        self.collectionView.reloadData()
        self.stackView.layoutIfNeeded()
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        collectionView.collectionViewLayout.invalidateLayout()
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}


extension SecondVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (self.view.frame.width) / 4, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StocksCVCell", for: indexPath) as! StocksCVCell
        cell.lblSymbol.text = filteredData[indexPath.row]["symbol"] as? String
        cell.innerView.backgroundColor = UIColor.init(hexString: filteredData[indexPath.row]["color"] as! String)
        let percentFormatter = NumberFormatter()
        percentFormatter.numberStyle = NumberFormatter.Style.percent
        percentFormatter.minimumFractionDigits = 1
        percentFormatter.maximumFractionDigits = 2
        let raw_val: Double = Double(filteredData[indexPath.row]["open_interest_change"] as! String) ?? 0
        let percent_val = percentFormatter.string(for: raw_val)
        cell.lblPrice.text = percent_val
        return cell
    }
}
//MARK:- SEARCH DELEGATES
extension SecondVC: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.isSearchActive = true
        searchBar.showsCancelButton = false
    }
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        let cancelSearchBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(cancelBarButtonItemClicked))
        self.navigationItem.setRightBarButton(cancelSearchBarButtonItem, animated: true)
        return true
    }
    @objc func cancelBarButtonItemClicked() {
        self.searchBarCancelButtonClicked(self.searchBar)
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.navigationItem.setRightBarButton(btnBarSearch, animated: true)
        self.isSearchActive = false
        self.navigationItem.titleView = nil
        self.isSearchActive = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
        self.collectionView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.isSearchActive = false
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        var searchPredicate  = NSPredicate()
        isSearchActive = true
        searchPredicate = NSPredicate(format: "symbol CONTAINS[C] %@", searchText)
        self.filteredData = searchText.isEmpty ? self.arrCVData : self.arrCVData.filter { searchPredicate.evaluate(with: $0) }
        self.collectionView.reloadData()
    }
}

//MARK:- COLOR Extension
extension UIColor {
    //MARK: Get UIColor from hex color
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue:      CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}
