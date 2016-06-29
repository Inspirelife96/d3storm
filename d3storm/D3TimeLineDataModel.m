//
//  D3TimeLineDataModel.m
//  d3storm
//
//  Created by Chen XueFeng on 16/6/13.
//  Copyright © 2016年 Chen XueFeng. All rights reserved.
//

#import "D3TimeLineDataModel.h"

@implementation D3TimeLineDataModel

- (instancetype)initWithDictionary:(NSDictionary *)timeLineDict {
    if (self = [super init]) {
        _timeString    = [timeLineDict objectForKey:@"time"];
        _contentString = [timeLineDict objectForKey:@"content"];
        _imageString   = [timeLineDict objectForKey:@"image"];

        return self;
    }
    
    return nil;
}

+ (instancetype)initWithDictionary:(NSDictionary *)timeLineDict {
    return [[self alloc] initWithDictionary:timeLineDict];
}

@end
