//
//  D3CGPlayerViewController.h
//  d3storm
//
//  Created by Chen XueFeng on 16/6/22.
//  Copyright © 2016年 Chen XueFeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface D3CGPlayerViewController : UIViewController

@property(weak, nonatomic) IBOutlet UIWebView *videoWebView;
@property(weak, nonatomic) IBOutlet UITextView *videoTextView;

@property(copy, nonatomic) NSDictionary *videoInfoDict;

@end
