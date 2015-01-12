//
//  MenuHeaderView.m
//  Item Scrapper
//
//  Created by Geunho Khim on 12/4/14.
//  Copyright (c) 2014 com.ebay.kr.gkhim. All rights reserved.
//

#import "MenuHeaderView.h"


@implementation MenuHeaderView

#pragma mark - UIView

+ (MenuHeaderView *)view {
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"MenuHeaderView"
                                                  owner:self
                                                options:nil];
    MenuHeaderView *cell = [nibs firstObject];
    
    return cell;
}


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

@end
