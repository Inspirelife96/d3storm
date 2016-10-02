//
//  AppDelegate.m
//  d3storm
//
//  Created by Chen XueFeng on 16/6/11.
//  Copyright © 2016年 Chen XueFeng. All rights reserved.
//

#import "AppDelegate.h"
#import <AVOSCloud/AVOSCloud.h>
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import "WXApi.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <StoreKit/StoreKit.h>
#import "StoreObserver.h"
#import "StoreManager.h"
#import "AdManager.h"
#import "iRate.h"
#import "D3SharedResource.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

+ (void)initialize {
    //configure iRate
    [iRate sharedInstance].daysUntilPrompt = 5;
    [iRate sharedInstance].usesUntilPrompt = 15;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [Chameleon customizeNavigationBarWithPrimaryColor:FlatBlackDark withContentStyle:UIContentStyleContrast];
    [Chameleon customizeTabBarWithBarTintColor:FlatBlackDark andTintColor:FlatOrange];
    
    UIPageControl *pageControl = [UIPageControl appearance];
    pageControl.pageIndicatorTintColor = FlatWhite;
    pageControl.currentPageIndicatorTintColor = FlatBlueDark;
    pageControl.backgroundColor = FlatBlackDark;
    
    // init IAP products
    NSArray *productIdentifiers = [NSArray arrayWithObjects:
                                   kIAPVip,
                                   kIAPAdRemoved,
                                   nil];
    [[StoreManager sharedInstance] fetchProductInformationForIds:productIdentifiers];
    
    // add payment observer
    [[SKPaymentQueue defaultQueue] addTransactionObserver:[StoreObserver sharedInstance]];
    
    // init rewarded ad and institial ad
    [AdManager sharedInstance];
    
    // init leancloud
    [AVOSCloud setApplicationId:kLeanCloudApplicationId
                      clientKey:kLeanClientKey];
    [AVAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    // init sharesdk ()
    [ShareSDK registerApp:kShareSDKApplicationId
          activePlatforms:@[
                            @(SSDKPlatformTypeMail),
                            @(SSDKPlatformTypeSMS),
                            @(SSDKPlatformTypeWechat),
                            @(SSDKPlatformTypeQQ),
                            ]
                 onImport:^(SSDKPlatformType platformType) {
                     switch (platformType)
                     {
                         case SSDKPlatformTypeWechat:
                             [ShareSDKConnector connectWeChat:[WXApi class] delegate:self];
                             break;
                         case SSDKPlatformTypeQQ:
                             [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                             break;
                         default:
                             break;
                     }
                     
                 }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
              switch (platformType)
              {
                  case SSDKPlatformTypeWechat:
                      [appInfo SSDKSetupWeChatByAppId:kWXApplicationId
                                            appSecret:kWXApplicationSecret];
                      break;
                  case SSDKPlatformTypeQQ:
                      [appInfo SSDKSetupQQByAppId:kQQApplicationId
                                           appKey:kQQApplicationSecret
                                         authType:SSDKAuthTypeBoth];
                  default:
                      break;
              }
          }];
    
    
    NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
    if (![userDefault boolForKey:kUserDefaultFirstLaunch]) {
        [userDefault setBool:YES forKey:kUserDefaultFirstLaunch];
        [userDefault setBool:NO  forKey:kUserDefaultIsVip];
        [userDefault setBool:NO  forKey:kUserDefaultIsAdRemoved];
        [userDefault setInteger:0 forKey:kUserDefaultCoin];
        
        [userDefault synchronize];
    }
    
    if (![userDefault boolForKey:kUserDefaultVersion12]) {
        NSArray *bookArray = [D3SharedResource sharedInstance].bookArray;
        
        for (int i = 0; i < bookArray.count; i++) {
            NSDictionary *bookSectionDict = bookArray[i];
            NSArray *booksArray = [bookSectionDict objectForKey:@"books"];
            for (int j = 0; j < booksArray.count; j++) {
                NSString *bookCodeString = [booksArray[j] objectForKey:@"bookcode"];
                NSNumber *bookId = [booksArray[j] objectForKey:@"bookid"];
                if ([bookId integerValue] > 0 && [bookId integerValue] < 5000) {
                    NSString *bookNameKey = [NSString stringWithFormat:@"%@.txt",bookCodeString];
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:bookNameKey];
                }
            }
        }
        
        [userDefault setBool:YES forKey:kUserDefaultVersion12];
        [userDefault synchronize];
    }
    
    return YES;
}

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    id presentedViewController = [window.rootViewController presentedViewController];
    NSString *className = presentedViewController ? NSStringFromClass([presentedViewController class]) : nil;
    
    if (window && ([className isEqualToString:@"MPInlineVideoFullscreenViewController"] || [className isEqualToString:@"AVFullScreenViewController"])) {
        return UIInterfaceOrientationMaskAll;
    } else {
        return UIInterfaceOrientationMaskPortrait;
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSDate *lastLoginDate = [userDefault objectForKey:kUserDefaultLastLoginDate];
    
    if (lastLoginDate) {
        NSDate *dateToday = [NSDate date];
        
        CGFloat timezoneFix = [NSTimeZone localTimeZone].secondsFromGMT;
        if ((int)(([lastLoginDate timeIntervalSince1970] + timezoneFix)/(24*3600)) ==
            (int)(([dateToday timeIntervalSince1970] + timezoneFix)/(24*3600))) {
            // Do Nothing;
        } else {
            NSInteger coin = [userDefault integerForKey:kUserDefaultCoin];
            [userDefault setObject:dateToday forKey:kUserDefaultLastLoginDate];
            [userDefault setInteger:(coin + 3) forKey:kUserDefaultCoin];
            [userDefault setBool:NO forKey:kUserDefaultIsSharedToday];
            [userDefault synchronize];
        }
    } else {
        [userDefault setObject:[NSDate date] forKey:kUserDefaultLastLoginDate];
        [userDefault setInteger:3 forKey:kUserDefaultCoin];
        [userDefault setBool:NO forKey:kUserDefaultIsSharedToday];
        [userDefault synchronize];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:[StoreObserver sharedInstance]];
}

@end
