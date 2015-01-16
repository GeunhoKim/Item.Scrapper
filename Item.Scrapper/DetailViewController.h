//
//  DetailViewController.h
//  Item Scrapper
//
//  Created by ebaymobile on 1/16/15.
//  Copyright (c) 2015 com.ebay.kr.gkhim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSDynamicsDrawerViewController.h"
#import "SharedInstance.h"

@interface DetailViewController : UIViewController
<UIWebViewDelegate>

@property (nonatomic, weak) MSDynamicsDrawerViewController *dynamicsDrawerViewController;

+ (DetailViewController *)getViewController;

- (void)request;

@end
