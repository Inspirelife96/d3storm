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
