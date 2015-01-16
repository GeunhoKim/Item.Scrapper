//
//  SharedInstance.h
//  Item Scrapper
//
//  Created by Geunho Khim on 12/16/14.
//  Copyright (c) 2014 com.ebay.kr.gkhim. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SharedInstance : NSObject

@property (strong, nonatomic) NSArray *fetchedItems;
@property (strong, nonatomic) NSNumber *totalAmount;
@property (strong, nonatomic) NSNumber *averageAmount;
@property (strong, nonatomic) NSString *detailUrl;

+ (instancetype)singleton;

@end
