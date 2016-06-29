//
//  D3BookDetailViewController.h
//  wowradio
//
//  Created by Chen XueFeng on 16/2/26.
//  Copyright © 2016年 Chen XueFeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdViewController.h"

@interface D3BookDetailViewController : AdViewController <UITableViewDelegate, UITableViewDataSource>

@property(weak, nonatomic) IBOutlet UIImageView *bookImageView;
@property(weak, nonatomic) IBOutlet UIImageView *backgoundImageView;
@property(weak, nonatomic) IBOutlet UITableView *bookDetailTableView;

@property(copy, nonatomic) NSDictionary *book;

@end
