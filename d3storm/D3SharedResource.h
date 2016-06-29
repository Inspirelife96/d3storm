//
//  D3SharedResource.h
//  d3storm
//
//  Created by Chen XueFeng on 16/6/13.
//  Copyright © 2016年 Chen XueFeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface D3SharedResource : NSObject

@property(copy, nonatomic, readonly) NSArray *timeLineArray;
@property(copy, nonatomic, readonly) NSArray *mapArray;
@property(copy, nonatomic, readonly) NSArray *cgArray;
@property(copy, nonatomic, readonly) NSArray *bookArray;
@property(copy, nonatomic, readonly) NSDictionary *cartoonDict;

+ (instancetype)sharedInstance;

@end
