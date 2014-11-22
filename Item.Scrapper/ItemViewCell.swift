//
//  ItemViewCell.swift
//  Item Scrapper
//
//  Created by Geunho Khim on 11/19/14.
//  Copyright (c) 2014 com.ebay.kr.gkhim. All rights reserved.
//

import UIKit

class ItemViewCell: UITableViewCell {
    @IBOutlet var mainImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    var linkUrl: String!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
//        var url: NSURL = NSURL(string: linkUrl)!
//        UIApplication.sharedApplication().openURL(url)
    }
    
}
