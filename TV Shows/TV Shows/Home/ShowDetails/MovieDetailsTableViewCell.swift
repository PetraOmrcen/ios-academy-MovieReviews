//
//  Cell1TableViewCell.swift
//  TV Shows
//
//  Created by Infinum on 28.07.2021..
//

import UIKit
import Kingfisher

class MovieDetailsTableViewCell: UITableViewCell {

    @IBOutlet private weak var decriptionLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var reviwAndRatingLabel: UILabel!
    @IBOutlet private weak var rewiewNameLabel: UILabel!
    @IBOutlet private weak var detailsPictureUIImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        rewiewNameLabel.font = UIFont.boldSystemFont(ofSize: 22.0)
        titleLabel.font = UIFont.boldSystemFont(ofSize: 38.0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(showData: Show, numberOfReviews: Int){
        decriptionLabel.text = showData.description
        titleLabel.text = showData.title
        reviwAndRatingLabel.text = "\(numberOfReviews) REVIEWS, \(showData.averageRating) AVERAGE"
        detailsPictureUIImage.kf.setImage(
            with: showData.imageUrl,
            placeholder: UIImage(named: "ic-show-placeholder-vertical")
           )
    }
}
