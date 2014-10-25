//
//  ShareViewController.h
//  Scrapper.Share
//
//  Created by Geunho Khim on 2014. 10. 20..
//  Copyright (c) 2014년 com.ebay.kr.gkhim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>

#import "ASIHTTPRequest.h"

#define SCRAPPER_HOST @"http://localhost"

@interface ShareViewController : SLComposeServiceViewController
<ASIHTTPRequestDelegate>


@end


@interface ScrapperItem : NSObject

@property (retain, nonatomic) NSString *title;
@property (retain, nonatomic) NSString *imageUrl;
@property (retain, nonatomic) NSString *formatPrice;
@property (retain, nonatomic) NSNumber *price;
@property (retain, nonatomic) NSDate *scrapDate;

+ (ScrapperItem *)item;

@end
