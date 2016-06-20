//
//  TReaderChapterListViewController.m
//  wowradio
//
//  Created by Chen XueFeng on 16/2/24.
//  Copyright © 2016年 Chen XueFeng. All rights reserved.
//

#import "TReaderChapterListViewController.h"

@interface TReaderChapterListViewController ()

@end

@implementation TReaderChapterListViewController

static NSString * const reuseIdentifier = @"ChapterListCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _chapterList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    
    cell.textLabel.text = [_chapterList objectAtIndex:indexPath.row];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSNumber *chapterNumber = [NSNumber numberWithInteger:indexPath.row];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:TReaderChapterChangeNofication object:nil userInfo:@{@"chapter":chapterNumber}];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
