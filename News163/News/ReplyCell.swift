//
//  ReplyCell.swift
//  News163
//
//  Created by panqiang on 15/9/7.
//  Copyright (c) 2015年 panqiang. All rights reserved.
//

import UIKit

class ReplyCell: UITableViewCell {
    
    @IBOutlet weak var headImg: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locateLabel: UILabel!
    @IBOutlet weak var commendLabel: UILabel!
    @IBOutlet weak var replyCoutLabel: UILabel!

    @IBAction func zan(sender: AnyObject) {
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
