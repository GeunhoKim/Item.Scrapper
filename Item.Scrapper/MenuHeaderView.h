//
//  MenuHeaderView.h
//  Item Scrapper
//
//  Created by Geunho Khim on 12/4/14.
//  Copyright (c) 2014 com.ebay.kr.gkhim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuHeaderView : UITableViewHeaderFooterView

@property (weak, nonatomic) IBOutlet UILabel *headerLabel;
+ (MenuHeaderView *)view;

@end
