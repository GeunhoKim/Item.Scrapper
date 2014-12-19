//
//  SharedInstance.m
//  Item Scrapper
//
//  Created by Geunho Khim on 12/16/14.
//  Copyright (c) 2014 com.ebay.kr.gkhim. All rights reserved.
//

#import "SharedInstance.h"

@implementation SharedInstance

+ (instancetype)singleton {
    static SharedInstance *sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[SharedInstance alloc] init];
    });
    
    return sharedInstance;
}

@end
