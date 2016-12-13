//
//  MemberTableViewCell.swift
//  RollCall
//
//  Created by ZhangLiangZhi on 2016/12/13.
//  Copyright © 2016年 xigk. All rights reserved.
//

import UIKit

class MemberTableViewCell: UITableViewCell {

    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var numLabel: UILabel!
    @IBOutlet weak var memLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
