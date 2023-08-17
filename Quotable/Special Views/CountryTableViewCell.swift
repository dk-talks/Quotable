//
//  CountryTableViewCell.swift
//  Quotable
//
//  Created by Dinesh Sharma on 12/08/23.
//

import UIKit

class CountryTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var imgFlag: UIImageView!
    @IBOutlet weak var lblCountryCode: UILabel!
    @IBOutlet weak var lblCountryName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
