//
//  D3TimeLineViewController.m
//  d3storm
//
//  Created by Chen XueFeng on 16/6/13.
//  Copyright © 2016年 Chen XueFeng. All rights reserved.
//

#import "D3TimeLineViewController.h"
#import "D3SharedResource.h"
#import "D3TimeLIneDetailViewController.h"
#import <BHInfiniteScrollView/BHInfiniteScrollView.h>

@interface D3TimeLineViewController () <BHInfiniteScrollViewDelegate>

@property(copy, nonatomic) NSArray *timeLineArray;

@end

@implementation D3TimeLineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    _timeLineArray = [D3SharedResource sharedInstance].timeLineArray;
    _timeLineTableView.delegate = self;
    _timeLineTableView.dataSource = self;
    _timeLineTableView.tableFooterView = [[UIView alloc] init];
    
    self.navigationItem.title = @"时间线";
    
    NSArray *imageArray = [NSArray arrayWithObjects:
                           [UIImage imageNamed:@"d3image1"],
                           [UIImage imageNamed:@"d3image2"],
                           [UIImage imageNamed:@"d3image3"],
                           [UIImage imageNamed:@"d3image4"],
                           [UIImage imageNamed:@"d3image5"],
                           [UIImage imageNamed:@"d3image6"],
                           nil];
    
    
    [_timeLineView setNeedsLayout];
    [_timeLineView layoutIfNeeded];
    
    BHInfiniteScrollView* infinitePageView = [BHInfiniteScrollView
                                              infiniteScrollViewWithFrame:CGRectMake(0, 0, _timeLineView.frame.size.width, _timeLineView.frame.size.height) Delegate:self ImagesArray:imageArray];
    
    infinitePageView.imagesArray = imageArray;
    infinitePageView.pageControlAlignmentOffset = CGSizeMake(0, 20);
    infinitePageView.titleView.textColor = [UIColor whiteColor];
    infinitePageView.titleView.margin = 30;
    infinitePageView.titleView.hidden = YES;
    infinitePageView.scrollTimeInterval = 5;
    infinitePageView.autoScrollToNextPage = YES;
    infinitePageView.delegate = self;
    
    [_timeLineView addSubview:infinitePageView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.tabBarController) {
        self.tabBarController.tabBar.hidden = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _timeLineArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"D3TimeLineCell"];
    cell.textLabel.text = [_timeLineArray[indexPath.row] objectForKey:@"name"];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    D3TimeLineDetailViewController *timeLineDetailVC = [storyboard instantiateViewControllerWithIdentifier:@"D3TimeLineDetailViewController"];
    timeLineDetailVC.timeLineArray = [_timeLineArray[indexPath.row] objectForKey:@"content"];
    timeLineDetailVC.titleString = [_timeLineArray[indexPath.row] objectForKey:@"name"];
    [self.navigationController pushViewController:timeLineDetailVC animated:YES];
}

@end
