//
//  D3BookDetailViewController.h
//  wowradio
//
//  Created by Chen XueFeng on 16/2/26.
//  Copyright © 2016年 Chen XueFeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface D3BookDetailViewController : UITableViewController

@property(weak, nonatomic) IBOutlet UIImageView* bookImageView;
@property(weak, nonatomic) IBOutlet UIImageView* backgoundImageView;

@property(copy, nonatomic) NSDictionary *book;

@end
