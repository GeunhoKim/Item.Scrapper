//
//  MenuSummarizationCell.h
//  Item Scrapper
//
//  Created by Geunho Khim on 12/4/14.
//  Copyright (c) 2014 com.ebay.kr.gkhim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuSummarizationCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;


+ (MenuSummarizationCell *)cell;

@end
