//
//  HomeViewController.swift
//  Quotable
//
//  Created by Dinesh Sharma on 22/08/23.
//

import UIKit

class HomeViewController: UIViewController {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var textSearch: UITextField!
    @IBOutlet weak var btnProfile: UIButton!
    @IBOutlet weak var btnCreate: UIButton!
    
    @IBOutlet weak var viewTags: UIView!
    
    @IBOutlet weak var btnNext: UIButton!
    
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var btnDownload: UIButton!
    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var btnChangePhoto: UIButton!
    
    var searchController: UISearchController!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    
    
    
}
