//
//  D3TimeLineDataModel.m
//  d3storm
//
//  Created by Chen XueFeng on 16/6/13.
//  Copyright © 2016年 Chen XueFeng. All rights reserved.
//

#import "D3TimeLineDataModel.h"

@implementation D3TimeLineDataModel

- (instancetype)initWithString:(NSString *)timeLineString {
    if (self = [super init]) {
        NSRange range = [timeLineString rangeOfString:@"]"];
        if (range.location == NSNotFound) {
            _timeString = @"";
            _contentString = timeLineString;
        } else {
            NSRange timeRange = NSMakeRange(1, range.location - 1);
            _timeString = [timeLineString substringWithRange:timeRange];
            _contentString = [timeLineString substringFromIndex:range.location + 1];
        }

        return self;
    }
    
    return nil;
}

+ (instancetype)initWithString:(NSString *)timeLineString {
    return [[self alloc] initWithString:timeLineString];
}

@end
