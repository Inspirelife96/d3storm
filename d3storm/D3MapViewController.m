//
//  D3MapViewController.m
//  d3storm
//
//  Created by Chen XueFeng on 16/6/16.
//  Copyright © 2016年 Chen XueFeng. All rights reserved.
//

#import "D3MapViewController.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "D3MapCell.h"
#import "D3MapDataModel.h"
#import "VIPhotoView.h"

@interface D3MapViewController ()

@property(copy, nonatomic) NSArray *mapArray;
@property(strong, nonatomic) UIImageView *mapImageView;

@end

@implementation D3MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    _mapArray = [D3SharedResource sharedInstance].mapArray;
    _mapTableView.delegate = self;
    _mapTableView.dataSource = self;
    _mapTableView.tableFooterView = [[UIView alloc] init];
    
    self.navigationItem.title = @"世界地图";


    
}


- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    
    UIImage *mapImage = [UIImage imageNamed:@"worldmap"];
    VIPhotoView *photoView = [[VIPhotoView alloc] initWithFrame:_mapView.bounds andImage:mapImage];
    photoView.autoresizingMask = (1 << 6) - 1;
    
    [_mapView addSubview:photoView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _mapArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    D3MapCell *mapCell = [tableView dequeueReusableCellWithIdentifier:@"D3MapCell"];
    [self configureCell:mapCell atIndexPath:indexPath];
    return mapCell;
}

- (void)configureCell:(D3MapCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    cell.fd_enforceFrameLayout = NO; // Enable to use "-sizeThatFits:"
    
    D3MapDataModel *mapData = [D3MapDataModel initWithDictionary:_mapArray[indexPath.row]];
    
    cell.mapData = mapData;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView fd_heightForCellWithIdentifier:@"D3MapCell" configuration:^(D3MapCell *cell) {
        [self configureCell:cell atIndexPath:indexPath];
    }];
}

@end
