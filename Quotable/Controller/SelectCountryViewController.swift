//
//  SelectCountryViewController.swift
//  Quotable
//
//  Created by Dinesh Sharma on 12/08/23.
//

import UIKit

struct CountrySelected {
    var name: String
    var flag: UIImage
    var code: String
    
    init(name: String, flag: UIImage, code: String) {
        self.name = name
        self.flag = flag
        self.code = code
    }
}

class SelectCountryViewController: UIViewController {
    
    var countryList: [Country] = []

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textSearchCountry: UITextField!
    
    @IBOutlet weak var btnClose: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        APIClient.fetchData() { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.countryList = data
                    self.countryList.sort { country1, country2 in
                        return country1.name < country2.name
                    }
                    self.tableView.reloadData()
                }
                break;
            case .failure(let err):
                print("failed to fetch data: \(err)")
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    @IBAction func btnCloseTapped(_ sender: Any) {
        self.dismiss(animated: false)
    }
    
    
}

extension SelectCountryViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! CountryTableViewCell
        let name = cell.lblCountryName.text
        let flag = cell.imgFlag.image
        let code = "\(countryList[indexPath.row].idd.root) \((countryList[indexPath.row].idd.suffixes.first ?? "").prefix(5))"
        
        guard let name = name, let flag = flag else {
            return
        }
        
        let countrySelected = CountrySelected(name: name, flag: flag, code: code)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: countrySelectedNotification), object: countrySelected)
        
        self.dismiss(animated: false)
        
        
        
    }

}

extension SelectCountryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countryList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "countryCell", for: indexPath) as? CountryTableViewCell else {
            return UITableViewCell()
        }
        
            cell.lblCountryName.text = countryList[indexPath.row].name.common
        let code = countryList[indexPath.row].idd.root + (countryList[indexPath.row].idd.suffixes.first ?? "").prefix(5)
            cell.lblCountryCode.text = code
            // MARK: Force Unrapped URL Here
        APIClient.urlToImage(URL(string: countryList[indexPath.row].flags.png)!) { result in
            switch result {
            case .success(let img):
                DispatchQueue.main.async {
                    cell.imgFlag.image = img
                }
                break;
            case .failure(let err):
                print("completion(.failure() in urlToImg: \(err)")
            }
        }
        
        
        return cell
    }


}
