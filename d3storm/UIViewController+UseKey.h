//
//  UIViewController+UseKey.h
//  wowstorm
//
//  Created by Chen XueFeng on 16/8/13.
//  Copyright © 2016年 Chen XueFeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (UseKey)

- (void)userKeyOn:(UIView*)view actionBlock:(void (^)())actionBlock;

@end
