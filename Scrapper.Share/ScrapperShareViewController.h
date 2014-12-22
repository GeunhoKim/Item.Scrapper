//
//  ScrapperShareViewController.h
//  Item Scrapper
//
//  Created by Geunho Khim on 12/18/14.
//  Copyright (c) 2014 com.ebay.kr.gkhim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>
#import <CoreData/CoreData.h>

#import "ASIHTTPRequest.h"
#import "ItemEntity.h"

//#define SCRAPPER_HOST @"http://172.30.136.38"
#define SCRAPPER_HOST @"http://172.20.10.5"

@interface ScrapperShareViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;


@end
