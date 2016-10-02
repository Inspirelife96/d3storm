//
//  UIViewController+VIPPromotion.m
//  d3storm
//
//  Created by Chen XueFeng on 16/6/23.
//  Copyright © 2016年 Chen XueFeng. All rights reserved.
//

#import "UIViewController+VIPPromotion.h"
#import "UIViewController+Share.h"
#import "UIViewController+IAPNotification.h"
#import "StoreManager.h"

@implementation UIViewController (VIPPromotion)

- (void) showVIPPromotion:(NSString*) title message:(NSString*) message cancelTitle:(NSString*) cancelTitle sender:(id) sender {
    
    UIAlertController *promotionAC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:@"取消"
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action)
                                   {
                                       NSLog(@"Cancel action");
                                   }];
    
    if (!IsSharedToday) {
        UIAlertAction *shareAction = [UIAlertAction
                                      actionWithTitle:@"分享给好友（＋2🔑）"
                                      style:UIAlertActionStyleDefault
                                      handler:^(UIAlertAction *action)
                                      {
                                          [self shareMessage:@"我正在用［大图书馆 For 暗黑破坏神］看暗黑破坏神的故事，快来和我一起体验史诗故事吧！下载地址：http://itunes.apple.com/app/id1125770301" onView:sender];
                                      }];
        [promotionAC addAction:shareAction];
    }
    
    if ([StoreManager sharedInstance].availableProducts.count > 0) {
        
        NSString *price = [[StoreManager sharedInstance] priceMatchingProductIdentifier:kIAPVip];
        NSString *priceMessage = [NSString stringWithFormat:@"%@购买VIP（所有内容任意观看）", price];
        
        UIAlertAction *buyAction = [UIAlertAction
                                    actionWithTitle:priceMessage
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction *action)
                                    {
                                        [self buyVip];
                                    }];
        
        
        [promotionAC addAction:buyAction];
    }
    
    [promotionAC addAction:cancelAction];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        
        if ([sender isKindOfClass:[UIBarButtonItem class]]) {
            promotionAC.popoverPresentationController.barButtonItem = (UIBarButtonItem*)sender;
        } else {
            promotionAC.popoverPresentationController.sourceView = (UIView*)sender;
            promotionAC.popoverPresentationController.sourceRect = ((UIView*)sender).bounds;
        }
        
        [self presentViewController: promotionAC animated:YES completion:nil];
        
    } else {
        
        [self presentViewController:promotionAC animated:YES completion:nil];
    }
}

- (void) showVipAlert:(NSString*) title message:(NSString*) message cancelTitle:(NSString*) cancelTitle sender:(id) sender {
    
    UIAlertController *promotionAC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *shareAction = [UIAlertAction
                                  actionWithTitle:@"分享给好友"
                                  style:UIAlertActionStyleDefault
                                  handler:^(UIAlertAction *action)
                                  {
                                      [self shareMessage:@"我正在用［大图书馆 For 暗黑破坏神］看暗黑破坏神的故事，快来和我一起体验史诗故事吧！下载地址：http://itunes.apple.com/app/id1125770301" onView:sender];
                                  }];
    
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:@"取消"
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action)
                                   {
                                       NSLog(@"Cancel action");
                                   }];
    
    
    [promotionAC addAction:shareAction];
    [promotionAC addAction:cancelAction];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        
        if ([sender isKindOfClass:[UIBarButtonItem class]]) {
            promotionAC.popoverPresentationController.barButtonItem = (UIBarButtonItem*)sender;
        } else {
            promotionAC.popoverPresentationController.sourceView = (UIView*)sender;
            promotionAC.popoverPresentationController.sourceRect = ((UIView*)sender).bounds;
        }
        
        [self presentViewController: promotionAC animated:YES completion:nil];
        
    } else {
        
        [self presentViewController:promotionAC animated:YES completion:nil];
    }
}


@end
