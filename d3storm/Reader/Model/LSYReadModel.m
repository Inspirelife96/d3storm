//
//  LSYReadModel.m
//  LSYReader
//
//  Created by Labanotation on 16/5/31.
//  Copyright © 2016年 okwei. All rights reserved.
//

#import "LSYReadModel.h"
#import "LSYReadConfig.h"

@implementation LSYReadModel
-(instancetype)initWithContent:(NSString *)content
{
    self = [super init];
    if (self) {
        _content = content;
        NSMutableArray *charpter = [NSMutableArray array];
        [LSYReadUtilites separateChapter:&charpter content:content];
        _chapters = charpter;
        _notes = [NSMutableArray array];
        _marks = [NSMutableArray array];
        _record = [[LSYRecordModel alloc] init];
        _record.chapterModel = charpter.firstObject;
        _record.chapterCount = _chapters.count;
        _marksRecord = [NSMutableDictionary dictionary];
        _font = [NSNumber numberWithFloat:[LSYReadConfig shareInstance].fontSize];
    }
    return self;
}
-(instancetype)initWithePub:(NSString *)ePubPath;
{
    self = [super init];
    if (self) {
        _chapters = [LSYReadUtilites ePubFileHandle:ePubPath];;
        _notes = [NSMutableArray array];
        _marks = [NSMutableArray array];
        _record = [[LSYRecordModel alloc] init];
        _record.chapterModel = _chapters.firstObject;
        _record.chapterCount = _chapters.count;
        _marksRecord = [NSMutableDictionary dictionary];
        _font = [NSNumber numberWithFloat:[LSYReadConfig shareInstance].fontSize];
    }
    return self;
}
-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.content forKey:@"content"];
    [aCoder encodeObject:self.marks forKey:@"marks"];
    [aCoder encodeObject:self.notes forKey:@"notes"];
    [aCoder encodeObject:self.chapters forKey:@"chapters"];
    [aCoder encodeObject:self.record forKey:@"record"];
    [aCoder encodeObject:self.resource forKey:@"resource"];
    [aCoder encodeObject:self.marksRecord forKey:@"marksRecord"];
    [aCoder encodeObject:self.font forKey:@"font"];
}
-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        self.content = [aDecoder decodeObjectForKey:@"content"];
        self.marks = [aDecoder decodeObjectForKey:@"marks"];
        self.notes = [aDecoder decodeObjectForKey:@"notes"];
        self.chapters = [aDecoder decodeObjectForKey:@"chapters"];
        self.record = [aDecoder decodeObjectForKey:@"record"];
        self.resource = [aDecoder decodeObjectForKey:@"resource"];
        self.marksRecord = [aDecoder decodeObjectForKey:@"marksRecord"];
        self.font = [aDecoder decodeObjectForKey:@"font"];
    }
    return self;
}
+(void)updateLocalModel:(LSYReadModel *)readModel url:(NSURL *)url
{
    
    NSString *key = [url.path lastPathComponent];
    NSMutableData *data=[[NSMutableData alloc]init];
    NSKeyedArchiver *archiver=[[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
    [archiver encodeObject:readModel forKey:key];
    [archiver finishEncoding];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:key];
}
+(id)getLocalModelWithURL:(NSURL *)url
{
    NSString *key = [url.path lastPathComponent];
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if (!data) {
        if ([[key pathExtension] isEqualToString:@"txt"]) {
            LSYReadModel *model = [[LSYReadModel alloc] initWithContent:[LSYReadUtilites encodeWithURL:url]];
            model.resource = url;
            [LSYReadModel updateLocalModel:model url:url];
            return model;
        }
        else if ([[key pathExtension] isEqualToString:@"epub"]){
            NSLog(@"this is epub");
            LSYReadModel *model = [[LSYReadModel alloc] initWithePub:url.path];
            model.resource = url;
            [LSYReadModel updateLocalModel:model url:url];
            return model;
        }
        else{
            @throw [NSException exceptionWithName:@"FileException" reason:@"文件格式错误" userInfo:nil];
        }
        
    }
    NSKeyedUnarchiver *unarchive = [[NSKeyedUnarchiver alloc]initForReadingWithData:data];
    LSYReadModel *model = [unarchive decodeObjectForKey:key];
    
    if ([model.font floatValue] != [LSYReadConfig shareInstance].fontSize) {
        if ([[key pathExtension] isEqualToString:@"txt"]) {
            LSYReadModel *model = [[LSYReadModel alloc] initWithContent:[LSYReadUtilites encodeWithURL:url]];
            model.resource = url;
            [LSYReadModel updateLocalModel:model url:url];
            return model;
        }
    }
    
    return model;
}

-(void)removeMarksAndNotes {
    [_notes removeAllObjects];
    [_marks removeAllObjects];
    [_marksRecord removeAllObjects];
    
    [LSYReadModel updateLocalModel:self url:self.resource];
}

- (NSUInteger)getPageIndexByOffset:(NSUInteger)offset Chapter:(NSUInteger)chapterIndex {
    LSYChapterModel *chapterModel = _chapters[chapterIndex];
    NSArray *pageArray = chapterModel.pageArray;
    
    for (int i = 0; i < pageArray.count - 1; i++) {
        if (offset >= [pageArray[i] integerValue] && offset < [pageArray[i + 1] integerValue]) {
            return i;
        }
    }
    
    if (offset >= [pageArray[pageArray.count - 1] integerValue]) {
        return pageArray.count - 1;
    } else {
        return 0;
    }
}
@end
