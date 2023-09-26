//
//  PlanTableViewCell.swift
//  TravelMaker
//
//  Created by 정태영 on 2023/09/25.
//

import UIKit

class PlanTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imgFirstPhoto: UIImageView!
    
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblTagList: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
