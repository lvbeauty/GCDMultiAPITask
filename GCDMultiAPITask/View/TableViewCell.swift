//
//  TableViewCell.swift
//  GCDMultiAPITask
//
//  Created by Tong Yi on 6/20/20.
//  Copyright © 2020 Tong Yi. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(user: User)
    {
        self.nameLabel.text = "\(user.first_name) \(user.last_name)"
        self.emailLabel.text = user.email
    }
    
    func updateCellImage(image: UIImage?)
    {
        self.photoView.roundedCornerImage()
        self.photoView.image = image ?? UIImage(systemName: "photo")
    }

}
