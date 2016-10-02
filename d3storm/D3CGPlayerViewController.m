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
    _videoWebView.allowsInlineMediaPlayback = YES;
    
    _videoWebView.scrollView.bounces = NO;
    _videoWebView.scrollView.showsHorizontalScrollIndicator = NO;
    _videoWebView.scrollView.scrollEnabled = NO;
    
    [_videoWebView loadHTMLString:htmlString baseURL:nil];
    
    self.navigationItem.title =  [_videoInfoDict objectForKey:@"cgname"];
    _videoTextView.text = [_videoInfoDict objectForKey:@"cgdescription"];
    _videoTextView.textColor = FlatGrayDark;
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(windowNowVisible:)
     name:UIWindowDidBecomeVisibleNotification
     object:self.view.window
     ];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(windowNowHidden:)
     name:UIWindowDidBecomeHiddenNotification
     object:self.view.window
     ];
}

- (void)windowNowVisible:(NSNotification *)notification
{
    NSLog(@"Youtube/ Media window appears");
}


- (void)windowNowHidden:(NSNotification *)notification
{
    NSLog(@"Youtube/ Media window disappears.");
}


@end
