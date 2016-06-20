//
//  D3CGCell.m
//  
//
//  Created by Chen XueFeng on 16/2/22.
//
//

#import "D3CGCell.h"

@implementation D3CGCell

- (void)setVideoInfoDict:(NSDictionary *)videoInfoDict {
    
    CGFloat width = ([[UIScreen mainScreen] bounds].size.width - 20.0f)/2.0f - 8.0;
    CGFloat height = (width/8.0f)*5.0f - 8.0;
    
    NSString *htmlString = [NSString stringWithFormat:[videoInfoDict objectForKey:@"cglink"], (NSInteger)height*4, (NSInteger)width*4];
    
    _videoWebView.scrollView.bounces = NO;
    _videoWebView.scrollView.showsHorizontalScrollIndicator = NO;
    _videoWebView.scrollView.scrollEnabled = NO;
    
    [_videoWebView loadHTMLString:htmlString baseURL:nil];
    
    NSString *videoNameString = [videoInfoDict objectForKey:@"cgname"];
    _videoNameLabel.text = videoNameString;
}

@end
