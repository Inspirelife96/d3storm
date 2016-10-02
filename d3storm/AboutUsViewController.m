//
//  AboutUsViewController.m
//  wowstorm
//
//  Created by Chen XueFeng on 15/11/12.
//  Copyright © 2015年 Chen XueFeng. All rights reserved.
//

#import "AboutUsViewController.h"

@interface AboutUsViewController () {
    NSString *content;
}

@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"关于[大图书馆 For 暗黑破坏神]";
    content = @"\n\n\t一直非常喜欢暴雪的游戏，接触暗黑系列最早是在大一的时候，那时候去学校图书馆机房，正好有暗黑1的游戏，那时候就被这个游戏深深的迷住了，后来又有了暗黑2，几乎陪伴了我大二的整个暑假。\n\n\t暴雪出品，必属精品，这不光是因为游戏本身，更在于他背后强大的游戏世界观。暗黑系列从1开始到现在的3，经历了10多年，暗黑破坏神的背景故事也发展的非常丰满。官方的各种小说，动画，CG配合上周边产品，暗黑破坏神就是一个美轮美奂的魔幻世界\n\n\t这个应用的内容都来源于网络，主要搜集于凯恩之角，暗黑历史吧，以及优酷。感谢孔却等各位翻译大神，将小说翻译为中文，以及各位暗黑历史研究者的分析整理，以及暴雪，网易的内容。所以，如果有任何意见，建议，或者版权问题，请联系inspirelife@hotmail.com，我们会立即进行处理。\n\n\t希望大家喜欢这次的暗黑之旅。";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc] init];
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
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AboutUsCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AboutUsCell"];
    }
    
    UITextView *tvDescription = [[UITextView alloc] init];
    tvDescription.font = GetFontAvenirNext(14.0);
    tvDescription.textColor = FlatGray;
    tvDescription.delegate = nil;
    tvDescription.editable = NO;
    [tvDescription setScrollEnabled:YES];
    tvDescription.text = content;
    CGSize sizeOfDetail = [tvDescription sizeThatFits:CGSizeMake(self.view.frame.size.width - 20.0f, MAXFLOAT)];
    
    [tvDescription setFrame:CGRectMake(10, 0, sizeOfDetail.width, sizeOfDetail.height)];
    
    [tvDescription sizeToFit];
    [tvDescription setScrollEnabled:NO];
    
    [cell.contentView addSubview:tvDescription];
    
    return cell;
}


- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    UITextView *tvDescription = [[UITextView alloc] init];
    tvDescription.delegate = nil;
    tvDescription.font = GetFontAvenirNext(14.0);
    tvDescription.editable = NO;
    [tvDescription setScrollEnabled:YES];
    tvDescription.text = content;
    CGSize sizeOfDetail = [tvDescription sizeThatFits:CGSizeMake(self.view.frame.size.width - 20.0f, MAXFLOAT)];
    
    return sizeOfDetail.height;
}

@end
