//
//  MenuViewController.h
//  Item Scrapper
//
//  Created by Geunho Khim on 12/2/14.
//  Copyright (c) 2014 com.ebay.kr.gkhim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSDynamicsDrawerViewController.h"

@interface MenuViewController : UITableViewController
<UISearchBarDelegate, UISearchDisplayDelegate>

@property (nonatomic, weak) MSDynamicsDrawerViewController *dynamicsDrawerViewController;

@end
