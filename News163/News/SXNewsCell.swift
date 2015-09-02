//
//  SXNewsCell.swift
//  News163
//
//  Created by panqiang on 15/8/18.
//  Copyright (c) 2015年 panqiang. All rights reserved.
//

import UIKit

class SXNewsCell: UITableViewCell {
    @IBOutlet weak var imgIcon: UIImageView! //图片
    
    @IBOutlet weak var libTitle: UILabel! //标题
    
    @IBOutlet weak var libReply: UILabel! //回复数
    
    @IBOutlet weak var libSubTitle: UILabel! //描述
    
    @IBOutlet weak var imgOther1: UIImageView! //第二张图片(如果有)
    
    @IBOutlet weak var imgOther2: UIImageView! //第三张图片(如果有)
    
    func setnewsModel(model:NewsModel) {
        self.imgIcon.setImageWithURL((NSURL(string: model.imgsrc!)),placeholderImage:UIImage(named: "302"))
        self.libTitle.text = model.title
        self.libSubTitle?.text = model.digest
        
        //如果回复太多就改成几点几万
        if (model.replyCount?.doubleValue >= 10000) {
            self.libReply?.text = String(format: "%.1f万跟帖", model.replyCount!.doubleValue/10000.0)
        } else if (model.replyCount != nil) {
            self.libReply?.text = "\(model.replyCount!)跟帖"
        } else {
            self.libReply?.text = "0跟帖"
        }
        
        //多图cell
        if (model.imgextra?.count > 1) {
            self.imgOther1?.setImageWithURL((NSURL(string: model.imgextra?[0]["imgsrc"] as! String)), placeholderImage: UIImage(named: "302"))
            self.imgOther2?.setImageWithURL((NSURL(string: model.imgextra?[1]["imgsrc"] as! String)), placeholderImage: UIImage(named: "302"))
        }
    }
    
    class func idForRow(model:NewsModel) ->String {
        if (model.hasHead != nil && model.photosetID != nil) {
            return "TopImageCell"
        }else if (model.hasHead != nil) {
            return "TopTxtCell"
        }else if (model.imgType != nil) {
            return "BigImageCell"
        }else if (model.imgextra != nil) {
            return "ImagesCell"
        }else {
            return "NewsCell"
        }
    }
    
    class func heightForRow(newsModel:NewsModel) -> CGFloat {
        if (newsModel.hasHead != nil && newsModel.photosetID != nil) {
            return 247 * mainWidth / 375
        }else if (newsModel.hasHead != nil) {
            return 247 * mainWidth / 375
        }else if (newsModel.imgType != nil) {
            return 170 * mainWidth / 375
        }else if (newsModel.imgextra != nil) {
            return 130 * mainWidth / 375
        }else {
            return 89 * mainWidth / 375
        }
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
