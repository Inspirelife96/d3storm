//
//  D3MapDataModel.h
//  d3storm
//
//  Created by Chen XueFeng on 16/6/16.
//  Copyright © 2016年 Chen XueFeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface D3MapDataModel : NSObject

@property(copy, nonatomic) NSString *mapString;
@property(copy, nonatomic) NSString *contentString;

- (instancetype)initWithDictionary:(NSDictionary *)mapDict;
+ (instancetype)initWithDictionary:(NSDictionary *)mapDict;

@end
