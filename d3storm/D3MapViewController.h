//
//  D3MapViewController.h
//  d3storm
//
//  Created by Chen XueFeng on 16/6/16.
//  Copyright © 2016年 Chen XueFeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface D3MapViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property(weak, nonatomic) IBOutlet UITableView *mapTableView;
@property(weak, nonatomic) IBOutlet UIImageView *mapView;

@end
