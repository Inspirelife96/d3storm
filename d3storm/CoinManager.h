//
//  CoinManager.h
//  wowstorm
//
//  Created by Chen XueFeng on 16/3/26.
//  Copyright © 2016年 Chen XueFeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoinManager : NSObject

+ (NSInteger)getCoin;

+ (void)changeCoin:(NSInteger)number;

@end
