//
//  Cell2TableViewCell.swift
//  TV Shows
//
//  Created by Infinum on 28.07.2021..
//

import UIKit

class Cell2TableViewCell: UITableViewCell {
    
    @IBOutlet weak var reviewLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet private weak var ratingView: RatingView!

    override func awakeFromNib() {
        super.awakeFromNib()
        ratingView.configure(withStyle: .small)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
