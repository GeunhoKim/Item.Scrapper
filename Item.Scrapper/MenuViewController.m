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
    MenuViewControllerSectionTypeG9,
    MenuViewControllerSectionType11st,
    MenuViewControllerSectionTypeCoupang,
    MenuViewControllerSectionTypeTmon,
    MenuViewControllerSectionTypeCount
};

typedef NS_ENUM(NSUInteger, MenuViewControllerCellType) {
    MenuViewControllerCellTypeTotalAmount,
    MenuViewControllerCellTypeTotalCount,
    MenuViewControllerCellTypeAverageAmount,
    MenuViewControllerCellTypeCount
};

@interface MenuViewController ()

@property (nonatomic, strong) NSArray *domainArray;
@property (nonatomic, strong) NSMutableArray *sumArray;
@property (nonatomic, strong) NSMutableArray *averageArray;
@property (nonatomic, strong) NSMutableArray *countArray;

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.domainArray = @[@"", @"ebay", @"auction", @"gmarket", @"g9", @"11st", @"coupang", @"tmon"];
    self.sumArray = [NSMutableArray array];
    self.averageArray = [NSMutableArray array];
    self.countArray = [NSMutableArray array];
    
    [self.tableView setBackgroundColor:[UIColor whiteColor]];
    
    [self.tableView registerClass:[MenuHeaderView class] forHeaderFooterViewReuseIdentifier:MENU_VIEW_HEADER_IDENTIFIER];
    
    [self updateSummarization];
}

- (void)updateSummarization {

    NSArray *allItems = [[SharedInstance singleton] fetchedItems];
    
    [self updateSummarizationType:MenuViewControllerSectionTypeAll items:allItems];
    [self updateSummarizationType:MenuViewControllerSectionTypeEbay items:allItems];
    [self updateSummarizationType:MenuViewControllerSectionTypeAuction items:allItems];
    [self updateSummarizationType:MenuViewControllerSectionTypeGmarket items:allItems];
    [self updateSummarizationType:MenuViewControllerSectionTypeG9 items:allItems];
    [self updateSummarizationType:MenuViewControllerSectionType11st items:allItems];
    [self updateSummarizationType:MenuViewControllerSectionTypeCoupang items:allItems];
    [self updateSummarizationType:MenuViewControllerSectionTypeTmon items:allItems];

    [self.tableView reloadData];
}

- (BOOL)isEmpty:(NSArray *)array {
    return (array == nil || [array count] == 0);
}

- (void)updateSummarizationType:(MenuViewControllerSectionType)type items:(NSArray *)items {
    NSArray *filteredItems;
    
    if (type != MenuViewControllerSectionTypeAll) {
        NSString *domain = [self.domainArray objectAtIndex:type];
        NSString *predicateString = [NSString stringWithFormat:@"kindOf = '%@'", domain];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateString];
        filteredItems = [items filteredArrayUsingPredicate:predicate];
    } else {
        filteredItems = items;
    }
    
    if (![self isEmpty:filteredItems]) {
        NSNumber *sum = [filteredItems valueForKeyPath: @"@sum.price"];
        NSNumber *average = [filteredItems valueForKeyPath: @"@avg.price"];
        
        if (type == MenuViewControllerSectionTypeAll) {
            [SharedInstance singleton].totalAmount = sum;
        }
    
        [self.sumArray setObject:sum atIndexedSubscript:type];
        [self.averageArray setObject:average atIndexedSubscript:type];
        [self.countArray setObject:[NSNumber numberWithLong:filteredItems.count] atIndexedSubscript:type];
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
            
        case MenuViewControllerSectionTypeG9:
            text = @"{G9 : Summarization}";
            break;
            
        case MenuViewControllerSectionType11st:
            text = @"{11st : Summarization}";
            break;
            
        case MenuViewControllerSectionTypeCoupang:
            text = @"{Coupang : Summarization}";
            break;
            
        case MenuViewControllerSectionTypeTmon:
            text = @"{Tmon : Summarization}";
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
    return [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 17.0f)];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 17.0f;
}



@end
