//
//  D3TimeLineDetailViewController.h
//  d3storm
//
//  Created by Chen XueFeng on 16/6/13.
//  Copyright © 2016年 Chen XueFeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface D3TimeLineDetailViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property(weak, nonatomic) IBOutlet UITableView *timeLineTableView;

@property(copy, nonatomic) NSArray *timeLineArray;
@property(copy, nonatomic) NSString *titleString;

@end
