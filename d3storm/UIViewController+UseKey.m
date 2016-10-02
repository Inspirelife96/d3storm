//
//  UIViewController+UseKey.m
//  wowstorm
//
//  Created by Chen XueFeng on 16/8/13.
//  Copyright © 2016年 Chen XueFeng. All rights reserved.
//

#import "UIViewController+UseKey.h"
#import "UIViewController+VIPPromotion.h"
#import "Reachability.h"
#import "UIViewController+Alert.h"
#import "CoinManager.h"

@implementation UIViewController (UseKey)

- (void)userKeyOn:(UIView*)view actionBlock:(void (^)())actionBlock {
    NetworkStatus currentStatus = [[Reachability reachabilityForInternetConnection] currentReachabilityStatus];
    
    if (currentStatus == NotReachable) {
        [self presentAlertTitle:@"无法访问网络" message:@"请确认网络连接状况并再次尝试"];
        return;
    }
    
    if (!IsVip && [CoinManager getCoin] <= 0) {
        [self showVIPPromotion:@"您没有足够的🔑" message:@"观看CG会消耗金钥匙，每天首次开启APP会免费获得3把，您可以通过以下方式获得额外的金钥匙。" cancelTitle:@"再看看" sender:view];
        return;
    }
    
    if (currentStatus == ReachableViaWWAN) {
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"高流量使用警告" message:@"您当前处于2/3/4G网络，观看视频/漫画/收听有声小说会消耗流量，是否继续？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:@"继续"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                       actionBlock();
                                   }];
        UIAlertAction *cancelAction = [UIAlertAction
                                       actionWithTitle:@"取消"
                                       style:UIAlertActionStyleCancel
                                       handler:^(UIAlertAction *action)
                                       {
                                       }];
        
        [alertVC addAction:okAction];
        [alertVC addAction:cancelAction];
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            UIPopoverPresentationController *popPresenter = [alertVC popoverPresentationController];
            
            popPresenter.sourceView = self.view;
            popPresenter.sourceRect = self.view.bounds;
            [self presentViewController:alertVC animated:YES completion:nil];
        } else {
            
            [self presentViewController:alertVC animated:YES completion:nil];
        }
    } else {
        actionBlock();
    }
}

@end
