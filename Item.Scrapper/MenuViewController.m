//
//  MenuViewController.m
//  Item Scrapper
//
//  Created by Geunho Khim on 12/2/14.
//  Copyright (c) 2014 com.ebay.kr.gkhim. All rights reserved.
//

#import "MenuViewController.h"

typedef NS_ENUM(NSUInteger, MenuViewControllerSectionType) {
    MenuViewControllerSectionTypeSummarization,
    MenuViewControllerSectionTypeFilter
};

@interface MenuViewController ()

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Drawer cell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Drawer cell" forIndexPath:indexPath];
    // Configure the cell...
    if(!cell) {
        cell = [UITableViewCell new];
    }
    
    return cell;
}

@end
