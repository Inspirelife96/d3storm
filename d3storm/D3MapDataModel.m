//
//  D3MapDataModel.m
//  d3storm
//
//  Created by Chen XueFeng on 16/6/16.
//  Copyright © 2016年 Chen XueFeng. All rights reserved.
//

#import "D3MapDataModel.h"

@implementation D3MapDataModel

- (instancetype)initWithDictionary:(NSDictionary *)mapDict {
    if (self = [super init]) {
        _mapString = [mapDict objectForKey:@"name"];
        _contentString = [mapDict objectForKey:@"description"];
        return self;
    }
    
    return nil;
}

+ (instancetype)initWithDictionary:(NSDictionary *)mapDict {
    return [[self alloc] initWithDictionary:mapDict];
}

@end
