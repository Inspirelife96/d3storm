//
//  ILUtilities.h
//  IOSSkillTree
//
//  Created by Chen XueFeng on 16/5/27.
//  Copyright © 2016年 Chen XueFeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define DailyLocalNotificationID  @"daily.local.notification.id"
#define DailyLocalNotificationKey @"daily.local.notification.key"
#define DateFormtHHmmss           @"HH:mm:ss"
#define GetDocumentDirectory      [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

@interface ILUtilities : NSObject

+ (void) presentAlertOnController:(UIViewController *)controller title:(NSString*)title message:(NSString*) message;
+ (NSString *)NSDateToNSString:(NSDate *)date withFormatter: (NSString *) nsFormatter;
+ (NSDate *)NSStringToNSDate: (NSString *) nsString withFormatter: (NSString *) nsFormatter;

+ (NSString *) getAudioDirectory;
+ (NSString *) getInterviewHistoryDirectory;
+ (NSString *) getQuestionnaireHistoryDirectory;

+ (NSString *) getAudioFilePath;
+ (NSString *) getInterviewHistoryFilePath;
+ (NSString *) getQuestionnaireHistoryFilePath;

@end
