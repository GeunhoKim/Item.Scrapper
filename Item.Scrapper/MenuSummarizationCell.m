//
//  MenuSummarizationCell.m
//  Item Scrapper
//
//  Created by Geunho Khim on 12/4/14.
//  Copyright (c) 2014 com.ebay.kr.gkhim. All rights reserved.
//

#import "MenuSummarizationCell.h"

@implementation MenuSummarizationCell

+ (MenuSummarizationCell *)cell {
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"MenuSummarizationCell"
                                                  owner:self
                                                options:nil];
    MenuSummarizationCell *cell = [nibs firstObject];
    
    return cell;
}

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
