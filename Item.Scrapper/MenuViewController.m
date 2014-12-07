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

#define MENU_VIEW_HEADER_IDENTIFIER @"MenuHeaderView"
#define MENU_VIEW_SUMMARIZATION_CELL_IDENTIFIER @"MenuSummarizationCell"

typedef NS_ENUM(NSUInteger, MenuViewControllerSectionType) {
    MenuViewControllerSectionTypeSummarization,
    MenuViewControllerSectionTypeFilter
};

@interface MenuViewController ()

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView setBackgroundColor:[UIColor whiteColor]];
    
    [self.tableView registerClass:[MenuHeaderView class] forHeaderFooterViewReuseIdentifier:MENU_VIEW_HEADER_IDENTIFIER];
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
    // Configure the cell...
    if(!cell) {
        cell = [MenuSummarizationCell cell];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewHeaderFooterView *headerView = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:MENU_VIEW_HEADER_IDENTIFIER];
    headerView.textLabel.text = @"Summarization";
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50.0f;
}


@end
