//
//  MenuViewController.m
//  Item Scrapper
//
//  Created by Geunho Khim on 12/2/14.
//  Copyright (c) 2014 com.ebay.kr.gkhim. All rights reserved.
//

#import "MenuViewController.h"
#import "MenuHeaderView.h"
#import "MenuSummarizationCell.h"
#import "SharedInstance.h"

#define MENU_VIEW_HEADER_IDENTIFIER @"MenuHeaderView"
#define MENU_VIEW_SUMMARIZATION_CELL_IDENTIFIER @"MenuSummarizationCell"

typedef NS_ENUM(NSUInteger, MenuViewControllerSectionType) {
    MenuViewControllerCellTypeTotalAmount,
    MenuViewControllerCellTypeTotalCount,
    MenuViewControllerCellTypeAverageAmount
};

@interface MenuViewController ()

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView setBackgroundColor:[UIColor whiteColor]];
    
    [self.tableView registerClass:[MenuHeaderView class] forHeaderFooterViewReuseIdentifier:MENU_VIEW_HEADER_IDENTIFIER];
    
    [self updateSummarization];
}

- (void)updateSummarization {
    NSArray *items = [[SharedInstance singleton] fetchedItems];
    NSNumber *sum = [items valueForKeyPath: @"@sum.price"];
    NSNumber *average = [items valueForKeyPath: @"@avg.price"];
    [SharedInstance singleton].totalAmount = sum;
    [SharedInstance singleton].averageAmount = average;
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MenuSummarizationCell *cell = [tableView dequeueReusableCellWithIdentifier:MENU_VIEW_SUMMARIZATION_CELL_IDENTIFIER];
    
    if(!cell) {
        cell = [MenuSummarizationCell cell];
    }
    
    [self configureSummariationCell:cell index:indexPath.row];
    
    return cell;
}

- (NSString *)formatPriceFromNumber:(NSNumber *)number {
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    formatter.numberStyle = NSNumberFormatterCurrencyStyle;
    formatter.locale = [NSLocale currentLocale];
    
    NSString *formatPrice = [formatter stringFromNumber:number];
    
    return formatPrice;
}

- (void)configureSummariationCell:(MenuSummarizationCell *)cell index:(NSInteger)index {
    switch (index) {
        case MenuViewControllerCellTypeTotalAmount:
            cell.summaryLabel.text = @"▪︎ Total Amount :";
            cell.amountLabel.text = [self formatPriceFromNumber:[SharedInstance singleton].totalAmount];
            break;
            
        case MenuViewControllerCellTypeTotalCount:
            cell.summaryLabel.text = @"▪︎ Total Count :";
            NSLog(@"%lu", [SharedInstance singleton].fetchedItems.count);
            cell.amountLabel.text = [NSString stringWithFormat:@"%lu", [SharedInstance singleton].fetchedItems.count];
            break;
            
        case MenuViewControllerCellTypeAverageAmount:
            cell.summaryLabel.text = @"▪︎ Average Amount :";
            cell.amountLabel.text = [self formatPriceFromNumber:[SharedInstance singleton].averageAmount];
            break;
            
        default:
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewHeaderFooterView *headerView = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:MENU_VIEW_HEADER_IDENTIFIER];
    headerView.textLabel.text = @"{Item Scrapper : Summarization}";
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50.0f;
}


@end
