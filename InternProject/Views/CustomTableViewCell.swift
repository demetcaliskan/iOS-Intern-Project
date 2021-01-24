//
//  CustomTableViewCell.swift
//  InternProject
//
//  Created by Demet Çalışkan on 24.01.2021.
//

import UIKit
import SDWebImage

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override func prepareForReuse() {
        imgView.sd_cancelCurrentImageLoad()
        imgView.image = nil
    }

}
