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
    [labelAppearance setTextColor:[UIColor grayColor]];
}

#pragma mark - UIView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIView *backgoundView = [UIView new];
        backgoundView.backgroundColor = [UIColor whiteColor];
        self.backgroundView = backgoundView;
    }
    return self;
}

@end
