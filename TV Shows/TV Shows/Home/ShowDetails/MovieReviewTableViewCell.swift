//
//  Cell2TableViewCell.swift
//  TV Shows
//
//  Created by Infinum on 28.07.2021..
//

import UIKit
import Kingfisher

class MovieReviewTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var reviewLabel: UILabel!
    @IBOutlet private weak var emailLabel: UILabel!
    @IBOutlet private weak var ratingView: RatingView!
    @IBOutlet private weak var profilePictureImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        ratingView.configure(withStyle: .small)
        ratingView.isEnabled = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(reviews: [Review], index: Int) {
        reviewLabel.text = reviews[index].comment
        emailLabel.text = reviews[index].user.email
        ratingView.setRoundedRating(Double(reviews[index].rating))
        profilePictureImage.kf.setImage(
            with: reviews[index].user.imageUrl,
            placeholder: UIImage(named: "ic-profile-placeholder")
           )
    }

}
