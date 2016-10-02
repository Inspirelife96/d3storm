//
//  UIViewController+Share.m
//  IOSSkillTree
//
//  Created by Chen XueFeng on 16/6/6.
//  Copyright © 2016年 Chen XueFeng. All rights reserved.
//

#import "UIViewController+Share.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKExtension/SSEShareHelper.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
#import <ShareSDKUI/SSUIShareActionSheetCustomItem.h>
#import <ShareSDK/ShareSDK+Base.h>

#import <MBProgressHUD/MBProgressHUD.h>
#import "UIViewController+Alert.h"
#import "CoinManager.h"

@implementation UIViewController (Share)

- (void)shareMessage:(NSString *)message onView:(UIView *)view {
    //1、创建分享参数（必要）
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    NSArray* imageArray = @[[UIImage imageNamed:@"Icon-share.png"]];
    [shareParams SSDKSetupShareParamsByText:message
                                     images:imageArray
                                        url:[NSURL URLWithString:kAppURL]
                                      title:@"大图书馆 For 星际争霸"
                                       type:SSDKContentTypeAuto];
    
    [shareParams SSDKSetupWeChatParamsByText:@"" title:message url:[NSURL URLWithString:kAppURL] thumbImage:[UIImage imageNamed:@"Icon-share.png"] image:[UIImage imageNamed:@"Icon-share.png"] musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil type:SSDKContentTypeAuto forPlatformSubType:SSDKPlatformSubTypeWechatTimeline];
    
    //2、分享
    [ShareSDK showShareActionSheet:view
                             items:nil
                       shareParams:shareParams
               onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                   
                   switch (state) {
                       case SSDKResponseStateBegin:
                       {
                           [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                           break;
                       }
                       case SSDKResponseStateSuccess:
                       {
                           if (!IsVip && !IsSharedToday) {
                               [CoinManager changeCoin:2];
                               [self presentAlertTitle:@"分享成功（＋2🔑）" message:@""];
                               [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kUserDefaultIsSharedToday];
                           } else {
                               [self presentAlertTitle:@"分享成功" message:@""];
                           }
                           
                           [self presentAlertTitle:@"分享成功" message:@""];
                           break;
                       }
                       case SSDKResponseStateFail:
                       {
                           if (platformType == SSDKPlatformTypeSMS && [error code] == 201)
                           {
                               [self presentAlertTitle:@"分享失败" message:@"失败原因可能是：1、短信应用没有设置帐号；2、设备不支持短信应用；3、短信应用在iOS 7以上才能发送带附件的短信。"];
                               break;
                           }
                           else if(platformType == SSDKPlatformTypeMail && [error code] == 201)
                           {
                               [self presentAlertTitle:@"分享失败" message:@"失败原因可能是：1、邮件应用没有设置帐号；2、设备不支持邮件应用；"];
                               break;
                           }
                           else
                           {
                               [self presentAlertTitle:@"分享失败" message:[NSString stringWithFormat:@"%@",error]];
                               break;
                           }
                           break;
                       }
                       case SSDKResponseStateCancel:
                       {
                           [self presentAlertTitle:@"分享已取消" message:@""];
                           break;
                       }
                       default:
                           break;
                   }
                   
                   if (state != SSDKResponseStateBegin) {
                       [MBProgressHUD hideHUDForView:self.view animated:YES];
                   }
               }];
}

@end
