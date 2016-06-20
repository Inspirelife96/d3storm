//
//  D3CGPlayerViewController.m
//  d3storm
//
//  Created by Chen XueFeng on 16/6/14.
//  Copyright © 2016年 Chen XueFeng. All rights reserved.
//

#import "D3CGPlayerViewController.h"

@interface D3CGPlayerViewController ()

@end

@implementation D3CGPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIWebView *youkuVideoWebView = [[UIWebView alloc] initWithFrame:self.view.frame];
    NSString *htmlString = @"<iframe height=498 width=510 src='http://player.youku.com/embed/XMTEwNDUwMDIw' frameborder=0 allowfullscreen></iframe>";
    [youkuVideoWebView loadHTMLString:htmlString baseURL:nil];
    [self.view addSubview:youkuVideoWebView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
