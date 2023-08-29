//
//  HomeViewController.swift
//  Quotable
//
//  Created by Dinesh Sharma on 22/08/23.
//

import UIKit

class HomeViewController: UIViewController {
    
    var quoteImages: [UIImage] = []
    var currentSection: Int?
    var quotes: [Quote] = []
    
    
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
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isUserInteractionEnabled = true
        
        let task = Task {
           quotes = await APIClient.fetchQuote()
            getImages()
        }
        
    }
    
    @IBAction func btnNextTapped(_ sender: Any) {
        scrollToNextCell()
    }
    
    
    @IBAction func btnProfileTapped(_ sender: Any) {
        collectionView.reloadData()
    }
    
    private func scrollToNextCell() {
        var minSection = Int.max
        for visibleItem in collectionView.indexPathsForVisibleItems {
            minSection = min(minSection, visibleItem.section)
        }
        currentSection = minSection
        guard var currentSection = currentSection else {
            return
        }
        let nextSection = currentSection+1
        if nextSection < numberOfSections(in: collectionView) {
            currentSection = nextSection
            print(currentSection)
            let nextIndexPath = IndexPath(row: 0, section: nextSection)
            collectionView.scrollToItem(at: nextIndexPath, at: .top, animated: true)

        }
    }
    
    private func getImages() {
        APIClient.fetchQuoteImage({ resultString in
            switch resultString {
            case.success(let fetchedQuote):
                let photos = fetchedQuote.photos
                // every photo from API
                if self.quotes.count == photos.count {
                    for (quote, photo) in zip(self.quotes, photos) {
                        APIClient.urlToImage(URL(string: photo.src.medium)!) { resultImg in
                            switch resultImg {
                            case .success(var img):
                                // here we can add text to image, and then append to main array of photos
                                if let img = ImageClient.addTextToImage(image: img, text: quote.content) {
                                    self.quoteImages.append(img)
                                }
                                
                                DispatchQueue.main.async {
                                    self.collectionView.reloadData()
                                }
                                break;
                            case .failure(let err):
                                print("error in converting url to image: \(err.localizedDescription)")
                            }
                        }
                    }
                }
                
                break;
            case .failure(let err):
                print("Error in fetching images for quotes: \(err.localizedDescription)")
            }
        })
    }
    
}

extension HomeViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        scrollToNextCell()
    }
    
}

extension HomeViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return quoteImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as? photoCollectionViewCell {
            cell.imgView.image = quoteImages[indexPath.section]
            
            return cell
        }
        return UICollectionViewCell()
    }
    
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfPhotosInOneLine = 1 // Adjust as needed
        let spacing: CGFloat = 10.0 // Adjust spacing between photos
        
        let availableWidth = collectionView.bounds.width - (spacing * CGFloat(numberOfPhotosInOneLine - 1))
        let itemWidth = availableWidth / CGFloat(numberOfPhotosInOneLine)
        
        return CGSize(width: itemWidth, height: itemWidth) // Assuming square photos
    }
    
    
}
