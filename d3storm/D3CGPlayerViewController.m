//
//  D3CGPlayerViewController.m
//  d3storm
//
//  Created by Chen XueFeng on 16/6/22.
//  Copyright © 2016年 Chen XueFeng. All rights reserved.
//

#import "D3CGPlayerViewController.h"

@interface D3CGPlayerViewController ()

@end

@implementation D3CGPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    CGFloat width = self.view.frame.size.width;
    CGFloat height = (self.view.frame.size.width/16)*10;
    
    NSString *htmlString = [NSString stringWithFormat:[_videoInfoDict objectForKey:@"cglink"], (NSInteger)height*4, (NSInteger)width*4];
    _videoWebView.mediaPlaybackRequiresUserAction = NO;
    
    _videoWebView.scrollView.bounces = NO;
    _videoWebView.scrollView.showsHorizontalScrollIndicator = NO;
    _videoWebView.scrollView.scrollEnabled = NO;
    
    [_videoWebView loadHTMLString:htmlString baseURL:nil];
    
    self.navigationItem.title =  [_videoInfoDict objectForKey:@"cgname"];
    _videoTextView.text = [_videoInfoDict objectForKey:@"cgdescription"];
    _videoTextView.textColor = FlatGrayDark;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
