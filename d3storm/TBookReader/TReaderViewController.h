//
//  TReaderPageViewController.h
//  TBookReader
//
//  Created by tanyang on 16/1/21.
//  Copyright © 2016年 Tany. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TReaderBook.h"
#import "AdViewController.h"

typedef NS_ENUM(NSUInteger, TReaderTransitionStyle) {
    TReaderTransitionStylePageCur,
    TReaderTransitionStyleScroll,
};

@interface TReaderViewController : AdViewController

@property (nonatomic, assign) TReaderTransitionStyle style;// 翻页样式
@property (nonatomic, strong) TReaderBook *readerBook;

@end
