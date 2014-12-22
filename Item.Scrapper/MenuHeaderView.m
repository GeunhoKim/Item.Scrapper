//
//  MenuHeaderView.m
//  Item Scrapper
//
//  Created by Geunho Khim on 12/4/14.
//  Copyright (c) 2014 com.ebay.kr.gkhim. All rights reserved.
//

#import "MenuHeaderView.h"


@implementation MenuHeaderView

#pragma mark - NSObject

+ (void)load {
    id labelAppearance = [UILabel appearanceWhenContainedIn:[self class], nil];
    [labelAppearance setFont:[UIFont systemFontOfSize:25.0]];
    [labelAppearance setTextColor:[UIColor colorWithRed:(87/255.0)
                                                  green:(87/255.0)
                                                   blue:(87/255.0)
                                                  alpha:1]];

}

#pragma mark - UIView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor colorWithRed:(247/255.0)
                                                           green:(247/255.0)
                                                            blue:(247/255.0)
                                                           alpha:0.6];
    }
    return self;
}

@end
