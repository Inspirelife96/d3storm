//
//  CoinManager.m
//  wowstorm
//
//  Created by Chen XueFeng on 16/3/26.
//  Copyright © 2016年 Chen XueFeng. All rights reserved.
//

#import "CoinManager.h"

@implementation CoinManager

+ (NSInteger)getCoin {
    return [[NSUserDefaults standardUserDefaults] integerForKey:kUserDefaultCoin];
}

+ (void)changeCoin:(NSInteger) number {
    [[NSUserDefaults standardUserDefaults] setInteger:([self getCoin] + number) forKey:kUserDefaultCoin];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationCoinChanged object:nil];
}

@end
