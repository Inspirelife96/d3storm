//
//  ILUtilities.m
//  IOSSkillTree
//
//  Created by Chen XueFeng on 16/5/27.
//  Copyright © 2016年 Chen XueFeng. All rights reserved.
//

#import "ILUtilities.h"

#import "TAPromotee/TAPromotee.h"

@implementation ILUtilities

+ (void) presentAlertOnController:(UIViewController *)controller title:(NSString*)title message:(NSString*) message {

    
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:title
                                          message:message
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:@"OK"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                               }];
    
    [alertController addAction:okAction];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        UIPopoverPresentationController *popPresenter = [alertController popoverPresentationController];
        
        popPresenter.sourceView = controller.view;
        popPresenter.sourceRect = controller.view.bounds;
        [controller presentViewController:alertController animated:YES completion:nil];
    } else {
        [controller presentViewController:alertController animated:YES completion:nil];
    }
}

+ (void) promotionApp:(NSNumber *) appId onViewController:(UIViewController *) viewController {
    
    [TAPromotee showFromViewController:viewController
                                 appId:[appId integerValue]
                               caption:@""
                            completion:^(TAPromoteeUserAction userAction) {
                                switch (userAction) {
                                    case TAPromoteeUserActionDidClose:
                                        // The user just closed the add
                                        NSLog(@"User did click close");
                                        break;
                                    case TAPromoteeUserActionDidInstall:
                                        // The user did click on the Install button so here you can for example disable the ad for the future
                                        [ILUtilities updatePromationAppStatus:[appId integerValue]];
                                        break;
                                }
                            }];
    
    
}

+ (NSNumber *)getPromationAppInfo {
    NSMutableArray *tempArray = [[NSMutableArray alloc] initWithCapacity:3];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if (![userDefault boolForKey:kUserDefaultPromotionHealthyProgrammer]) {
        [tempArray addObject:[NSNumber numberWithInteger:1050051890]];
    }
    
    if (![userDefault boolForKey:kUserDefaultPromotionLearnPaint]) {
        [tempArray addObject:[NSNumber numberWithInteger:1062770103]];
    }
    
    if (![userDefault boolForKey:kUserDefaultPromotionWowRadio]) {
        [tempArray addObject:[NSNumber numberWithInteger:1086303564]];
    }
    
    if (tempArray.count == 0) {
        return nil;
    } else {
        NSInteger randomIndex = arc4random()%tempArray.count;
        return tempArray[randomIndex];
    }
}

+ (void)updatePromationAppStatus: (NSInteger) appId {
    switch (appId) {
        case 1050051890:
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kUserDefaultPromotionHealthyProgrammer];
            break;
        case 1062770103:
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kUserDefaultPromotionLearnPaint];
            break;
        case 1086303564:
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kUserDefaultPromotionWowRadio];
            break;
        default:
            break;
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)NSDateToNSString:(NSDate *)date withFormatter: (NSString *) nsFormatter {
    NSDateFormatter *dataFormatter = [[NSDateFormatter alloc] init];
    [dataFormatter setLocale:[NSLocale currentLocale]];
    [dataFormatter setDateFormat:nsFormatter];
    
    NSString *nsTime = [dataFormatter stringFromDate:date];
    return nsTime;
}

+ (NSDate *) NSStringToNSDate: (NSString *) nsString withFormatter: (NSString *) nsFormatter {
    NSDateFormatter *dataFormatter = [[NSDateFormatter alloc] init];
    [dataFormatter setLocale:[NSLocale currentLocale]];
    [dataFormatter setDateFormat:nsFormatter];
    NSDate *date = [dataFormatter dateFromString:nsString];
    return  date;
}


+ (NSString *) getAudioDirectory {
    NSString *documentsDirectory = GetDocumentDirectory;
    NSString *audioDirectory = [documentsDirectory stringByAppendingPathComponent:@"Audio"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:audioDirectory]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:audioDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return audioDirectory;
}

+ (NSString *) getInterviewHistoryDirectory {
    NSString *documentsDirectory = GetDocumentDirectory;
    NSString *interviewDirectory = [documentsDirectory stringByAppendingPathComponent:@"Interview"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:interviewDirectory]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:interviewDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return interviewDirectory;
}
+ (NSString *) getQuestionnaireHistoryDirectory {
    NSString *documentsDirectory = GetDocumentDirectory;
    NSString *paperDirectory =  [documentsDirectory stringByAppendingPathComponent:@"Questionnaire"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:paperDirectory]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:paperDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return paperDirectory;
}

+ (NSString *) getAudioFilePath {
    NSString *dateString = [self NSDateToNSString:[NSDate date] withFormatter:@"yyyy-MM-dd HH:mm:ss"];
    NSString *audioFileName = [NSString stringWithFormat:@"record_%@.aac", dateString];
    NSString *audioFileDirectory = [self getAudioDirectory];
    
    return [audioFileDirectory stringByAppendingPathComponent:audioFileName];
}

+ (NSString *) getInterviewHistoryFilePath {
    NSString *dateString = [self NSDateToNSString:[NSDate date] withFormatter:@"yyyy-MM-dd HH:mm:ss"];
    NSString *interviewFileName = [NSString stringWithFormat:@"interview_%@%@", dateString, @".archive"];
    NSString *interviewFileDirectory = [self getInterviewHistoryDirectory];
    
    return [interviewFileDirectory stringByAppendingPathComponent:interviewFileName];
}

+ (NSString *) getQuestionnaireHistoryFilePath {
    NSString *dateString = [self NSDateToNSString:[NSDate date] withFormatter:@"yyyy-MM-dd HH:mm:ss"];
    NSString *paperFileName = [NSString stringWithFormat:@"questionnaire_%@%@", dateString, @".archive"];
    NSString *paperFileDirectory = [self getQuestionnaireHistoryDirectory];
    
    return [paperFileDirectory stringByAppendingPathComponent:paperFileName];
}



@end
