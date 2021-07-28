//
//  TVShowTableViewCell.swift
//  TV Shows
//
//  Created by Infinum on 27.07.2021..
//

import UIKit

class TVShowTableViewCell: UITableViewCell {
    
    //@IBOutlet private var showNameLabel: UILabel!
    @IBOutlet var showNameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with showName: String){
        showNameLabel.text = showName
    }

}
