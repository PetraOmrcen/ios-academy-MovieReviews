//
//  Cell1TableViewCell.swift
//  TV Shows
//
//  Created by Infinum on 28.07.2021..
//

import UIKit

class Cell1TableViewCell: UITableViewCell {

    @IBOutlet weak var decriptionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var reviwAndRatingLabel: UILabel!
    @IBOutlet weak var rewiewNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        rewiewNameLabel.font = UIFont.boldSystemFont(ofSize: 22.0)
        titleLabel.font = UIFont.boldSystemFont(ofSize: 38.0)
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
