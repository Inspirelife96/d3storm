//
//  TReaderChapterListViewController.h
//  wowradio
//
//  Created by Chen XueFeng on 16/2/24.
//  Copyright © 2016年 Chen XueFeng. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *const TReaderChapterChangeNofication = @"TReaderChapterChangeNofication";

@interface TReaderChapterListViewController : UITableViewController

@property(nonatomic, strong) NSArray *chapterList;

@end
