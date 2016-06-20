//
//  D3TimeLineDataModel.h
//  d3storm
//
//  Created by Chen XueFeng on 16/6/13.
//  Copyright © 2016年 Chen XueFeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface D3TimeLineDataModel : NSObject

@property(copy, nonatomic) NSString *timeString;
@property(copy, nonatomic) NSString *contentString;

- (instancetype)initWithString:(NSString *)timeLineString;
+ (instancetype)initWithString:(NSString *)timeLineString;

@end
