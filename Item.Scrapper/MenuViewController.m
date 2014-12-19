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
    MenuViewControllerSectionTypeAll,
    MenuViewControllerSectionTypeEbay,
    MenuViewControllerSectionTypeAuction,
    MenuViewControllerSectionTypeGmarket,
    MenuViewControllerSectionTypeCount
};

typedef NS_ENUM(NSUInteger, MenuViewControllerCellType) {
    MenuViewControllerCellTypeTotalAmount,
    MenuViewControllerCellTypeTotalCount,
    MenuViewControllerCellTypeAverageAmount,
    MenuViewControllerCellTypeCount
};

@interface MenuViewController ()

@property (nonatomic, strong) NSMutableArray *sumArray;
@property (nonatomic, strong) NSMutableArray *averageArray;
@property (nonatomic, strong) NSMutableArray *countArray;
@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.sumArray = [NSMutableArray array];
    self.averageArray = [NSMutableArray array];
    self.countArray = [NSMutableArray array];
    
    [self.tableView setBackgroundColor:[UIColor whiteColor]];
    
    [self.tableView registerClass:[MenuHeaderView class] forHeaderFooterViewReuseIdentifier:MENU_VIEW_HEADER_IDENTIFIER];
    
    [self updateSummarization];
}

- (void)updateSummarization {
    NSPredicate *ebayPredicate = [NSPredicate predicateWithFormat:@"kindOf = 'ebay'"];
    NSPredicate *auctionPredicate = [NSPredicate predicateWithFormat:@"kindOf = 'auction'"];
    NSPredicate *gmarketPredicate = [NSPredicate predicateWithFormat:@"kindOf = 'gmarket'"];
    
    NSArray *allItems = [[SharedInstance singleton] fetchedItems];
    NSArray *ebayItems = [allItems filteredArrayUsingPredicate:ebayPredicate];
    NSArray *auctionItems = [allItems filteredArrayUsingPredicate:auctionPredicate];
    NSArray *gmarketItems = [allItems filteredArrayUsingPredicate:gmarketPredicate];
    
    [self updateSummarizationType:MenuViewControllerSectionTypeAll items:allItems];
    [self updateSummarizationType:MenuViewControllerSectionTypeEbay items:ebayItems];
    [self updateSummarizationType:MenuViewControllerSectionTypeAuction items:auctionItems];
    [self updateSummarizationType:MenuViewControllerSectionTypeGmarket items:gmarketItems];

    [self.tableView reloadData];
}

- (BOOL)isEmpty:(NSArray *)array {
    return (array == nil || [array count] == 0);
}

- (void)updateSummarizationType:(MenuViewControllerSectionType)type items:(NSArray *)items {
    if (![self isEmpty:items]) {
        NSNumber *sum = [items valueForKeyPath: @"@sum.price"];
        NSNumber *average = [items valueForKeyPath: @"@avg.price"];
    
        [self.sumArray setObject:sum atIndexedSubscript:type];
        [self.averageArray setObject:average atIndexedSubscript:type];
        [self.countArray setObject:[NSNumber numberWithLong:items.count] atIndexedSubscript:type];
    } else {
        [self.sumArray setObject:@0 atIndexedSubscript:type];
        [self.averageArray setObject:@0 atIndexedSubscript:type];
        [self.countArray setObject:@0 atIndexedSubscript:type];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return MenuViewControllerSectionTypeCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(![[self.countArray objectAtIndex:section] isEqual:@0]) {
        return MenuViewControllerCellTypeCount;
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MenuSummarizationCell *cell = [tableView dequeueReusableCellWithIdentifier:MENU_VIEW_SUMMARIZATION_CELL_IDENTIFIER];
    
    if(!cell) {
        cell = [MenuSummarizationCell cell];
    }
    
    if(![[self.countArray objectAtIndex:indexPath.section] isEqual:@0]) {
        [self configureSummariationCell:cell indexPath:indexPath];
        return cell;
    } else {
        return nil;
    }
}

- (NSString *)formatPriceFromNumber:(NSNumber *)number {
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    formatter.numberStyle = NSNumberFormatterCurrencyStyle;
    formatter.locale = [NSLocale currentLocale];
    
    NSString *formatPrice = [formatter stringFromNumber:number];
    
    return formatPrice;
}

- (void)configureSummariationCell:(MenuSummarizationCell *)cell indexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    switch (indexPath.row) {
        case MenuViewControllerCellTypeTotalAmount:
            cell.summaryLabel.text = @"▪︎ Total Amount :";
            cell.amountLabel.text = [self formatPriceFromNumber:[self.sumArray objectAtIndex:section]];
            break;
            
        case MenuViewControllerCellTypeTotalCount:
            cell.summaryLabel.text = @"▪︎ Total Count :";
            cell.amountLabel.text = [[self.countArray objectAtIndex:section] stringValue];
            break;
            
        case MenuViewControllerCellTypeAverageAmount:
            cell.summaryLabel.text = @"▪︎ Average Amount :";
            cell.amountLabel.text = [self formatPriceFromNumber:[self.averageArray objectAtIndex:section]];
            break;
            
        default:
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(![[self.countArray objectAtIndex:indexPath.section] isEqual:@0]) {
        return 45.0f;
    } else {
        return 0.0f;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if([[self.countArray objectAtIndex:section] isEqual:@0]) {
        return nil;
    }
    
    UITableViewHeaderFooterView *headerView = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:MENU_VIEW_HEADER_IDENTIFIER];
    
    headerView.contentView.backgroundColor = [UIColor colorWithRed:(247/255.0) green:(247/255.0) blue:(247/255.0) alpha:1];
    
    NSString *text = @"";
    switch (section) {
        case MenuViewControllerSectionTypeAll:
            text = @"{Total : Summarization}";
            break;
            
        case MenuViewControllerSectionTypeEbay:
            text = @"{eBay : Summarization}";
            break;
            
        case MenuViewControllerSectionTypeAuction:
            text = @"{Auction : Summarization}";
            break;
            
        case MenuViewControllerSectionTypeGmarket:
            text = @"{Gmarket : Summarization}";
            break;
            
        default:
            return nil;
    }
    headerView.textLabel.text = text;

    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(![[self.countArray objectAtIndex:section] isEqual:@0]) {
        return 50.0f;
    } else {
        return 0.0f;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 12.0f)];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 12.0f;
}



@end
