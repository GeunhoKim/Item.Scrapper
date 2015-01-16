//
//  MasterTitleView.swift
//  Item Scrapper
//
//  Created by ebaymobile on 1/12/15.
//  Copyright (c) 2015 com.ebay.kr.gkhim. All rights reserved.
//

import UIKit

class MasterTitleView: UIView {

    class func view() -> MasterTitleView {
        return UINib(nibName: "MasterTitleView", bundle: nil).instantiateWithOwner(nil, options: nil).first as MasterTitleView
    }
    
}
