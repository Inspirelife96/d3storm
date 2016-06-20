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
    
    self.navigationItem.title = @"关于我们";
    content = @"\n\n\t学iOS一年多了，很想对自己的知识进行一个梳理，而最近又陆陆续续看到了不少iOS面试题，所以想整理下这些问题，同时写一个iOS面试题应用，所以就有了这个应用。 \n\n\t面试题所有的内容大部分来自于网络的搜集，所以我不是一个创造者，而是一个搬运工。我尽量把题目，尤其是参考答案的出处列明。若有任何疑问，建议，意见，请联系 inspirelife@hotmail.com。\n\n\t您也可以访问http://www.jianshu.com/p/403ee06a584e 来浏览这些面试题以及答案。\n\n\t这个应用的源码以及制作过程也会陆续在简书中发布，欢迎大家关注我的简书http://www.jianshu.com/users/6dad13dfc23e 来获得最新动态。";
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
