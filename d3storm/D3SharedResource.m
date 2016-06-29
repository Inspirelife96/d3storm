//
//  D3SharedResource.m
//  d3storm
//
//  Created by Chen XueFeng on 16/6/13.
//  Copyright © 2016年 Chen XueFeng. All rights reserved.
//

#import "D3SharedResource.h"

@interface D3SharedResource()

@property(copy, nonatomic, readwrite) NSArray *timeLineArray;
@property(copy, nonatomic, readwrite) NSArray *mapArray;
@property(copy, nonatomic, readwrite) NSArray *cgArray;

@end

static D3SharedResource *instance = nil;

@implementation D3SharedResource

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[super allocWithZone:NULL] init];
    });
    
    return instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [D3SharedResource sharedInstance];
}

- (D3SharedResource *)init {
    self = [super init];
    
    if (self) {
        NSString *historyPathString = [[NSBundle mainBundle] pathForResource:@"d3timeline" ofType:@"plist"];
        NSDictionary *historyDict   = [NSDictionary dictionaryWithContentsOfFile:historyPathString];
        _timeLineArray              = [historyDict objectForKey:@"d3timeline"];

        NSString *mapPathString     = [[NSBundle mainBundle] pathForResource:@"d3worldmap" ofType:@"plist"];
        NSDictionary *mapDict       = [NSDictionary dictionaryWithContentsOfFile:mapPathString];
        _mapArray                   = [mapDict objectForKey:@"d3worldmap"];

        NSString *cgPathString      = [[NSBundle mainBundle] pathForResource:@"d3cg" ofType:@"plist"];
        NSDictionary *cgDict        = [NSDictionary dictionaryWithContentsOfFile:cgPathString];
        _cgArray                    = [cgDict objectForKey:@"d3cg"];

        NSString *bookPathString    = [[NSBundle mainBundle] pathForResource:@"d3book" ofType:@"plist"];
        NSDictionary *bookDict      = [NSDictionary dictionaryWithContentsOfFile:bookPathString];
        _bookArray                  = [bookDict objectForKey:@"d3book"];

        NSString *cartoonPathString = [[NSBundle mainBundle] pathForResource:@"d3cartoon" ofType:@"plist"];
        NSDictionary *cartoonDict   = [NSDictionary dictionaryWithContentsOfFile:cartoonPathString];
        _cartoonDict                = [cartoonDict objectForKey:@"d3cartoon"];
    }
    
    return self;
}


@end
