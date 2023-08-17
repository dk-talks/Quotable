//
//  ViewController.swift
//  Quotable
//
//  Created by Dinesh Sharma on 09/08/23.
//

import UIKit

class RegisterViewController: UIViewController {
    
    var currentCode: String = ""
    var currentCountry: Country?
    
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var textMobileNo: UITextField!
    @IBOutlet weak var btnChangeCountry: UIButton!
    @IBOutlet weak var imgFlag: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let locale = Locale.current
        if #available(iOS 16, *) {
            if let cc = locale.language.region {
                currentCode = "\(cc.identifier)"
            }
        } else {
            if let cc = locale.regionCode {
                currentCode = "\(cc)"
            }
        }
        fetchCurrentCountryDetails() {result in
            switch(result) {
            case .success(let country):
                self.currentCountry = country
                if let cc = self.currentCountry {
                    APIClient.urlToImage(URL(string: cc.flags.png)!) { result in
                        switch result {
                        case .success(let img):
                            DispatchQueue.main.async {
                                self.imgFlag.image = img
                            }
                            break;
                        case .failure(let err):
                            print("error in parsing image from URL: \(err)")
                        }
                    }
                    DispatchQueue.main.async {
                        self.btnChangeCountry.setTitle(" \(cc.name.common) \(cc.idd.root)\(cc.idd.suffixes.first ?? "") \u{25BC}", for: .normal)
                    }
                    
                }
                break;
            case .failure(let err):
                print("error in fetching current country: \(err)")
            }
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleCountrySelection(_:)), name: Notification.Name(rawValue: countrySelectedNotification), object: nil)
    }
    
    @objc func handleCountrySelection(_ notification: Notification) {
        if let selectedCountry = notification.object as? CountrySelected {
            imgFlag.image = selectedCountry.flag
            btnChangeCountry.setTitle(" \(selectedCountry.name) \(selectedCountry.code) \u{25BC}", for: .normal)
        }
    }

    @IBAction func btnNextTapped(_ sender: Any) {
    }
    
    @IBAction func btnChangeCountryTapped(_ sender: Any) {
        
        let selectVC = storyboard?.instantiateViewController(withIdentifier: "selectCountryVC") as! SelectCountryViewController
        
        selectVC.modalPresentationStyle = .overCurrentContext
        
        present(selectVC, animated: false)
        
        
    }
    
    func fetchCurrentCountryDetails(_ completion: @escaping (Result<Country, Error>) -> Void) {
        APIClient.fetchData() { result in
            switch result{
            case .success(let countries):
                for country in countries {
                    if(country.altSpellings.first == self.currentCode) {
                        completion(.success(country))
                    }
                }
                break;
            case .failure(let err):
                completion(.failure(err))
                print("some error occured while fetching data from API : \(err)")
            }
        }
    }
}

