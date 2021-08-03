//
//  TVShowTableViewCell.swift
//  TV Shows
//
//  Created by Infinum on 27.07.2021..
//

import UIKit
import Kingfisher

class TVShowTableViewCell: UITableViewCell {
    
    @IBOutlet private var showNameLabel: UILabel!
    @IBOutlet private var iconImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(with show: Show) {
        showNameLabel.text = show.title
        iconImageView.kf.setImage(
            with: show.imageUrl,
            placeholder: UIImage(named: "ic-show-placeholder-rectangle")
           )
    }

}
