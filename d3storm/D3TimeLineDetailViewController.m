//
//  D3TimeLineDetailViewController.m
//  d3storm
//
//  Created by Chen XueFeng on 16/6/13.
//  Copyright © 2016年 Chen XueFeng. All rights reserved.
//

#import "D3TimeLineDetailViewController.h"
#import "D3SharedResource.h"
#import "D3TimeLineCell.h"
#import "D3TimeLineDataModel.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "AdManager.h"
#import "UIViewController+AppPromotion.h"

@interface D3TimeLineDetailViewController ()

@end

@implementation D3TimeLineDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _timeLineTableView.delegate = self;
    _timeLineTableView.dataSource = self;
    _timeLineTableView.tableFooterView = [[UIView alloc] init];
    
    self.navigationItem.title = _titleString;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.tabBarController) {
        self.tabBarController.tabBar.hidden = YES;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kUserDefaultIsAdRemoved]) {
        return;
    } else {
        [self promotion];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _timeLineArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    D3TimeLineCell *timeLineCell = [tableView dequeueReusableCellWithIdentifier:@"D3TimeLineCell"];
    [self configureCell:timeLineCell atIndexPath:indexPath];
    return timeLineCell;
}

- (void)configureCell:(D3TimeLineCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    cell.fd_enforceFrameLayout = NO; // Enable to use "-sizeThatFits:"
    
    D3TimeLineDataModel *timeLineData = [D3TimeLineDataModel initWithDictionary:_timeLineArray[indexPath.row]];
    
    cell.timeLineData = timeLineData;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView fd_heightForCellWithIdentifier:@"D3TimeLineCell" configuration:^(D3TimeLineCell *cell) {
        [self configureCell:cell atIndexPath:indexPath];
    }];
}

@end
