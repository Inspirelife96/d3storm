//
//  UIViewController+AppPromotion.m
//  d3storm
//
//  Created by Chen XueFeng on 16/6/23.
//  Copyright © 2016年 Chen XueFeng. All rights reserved.
//

#import "UIViewController+AppPromotion.h"
#import "TAPromotee/TAPromotee.h"

@implementation UIViewController (AppPromotion)

- (void) promotionApp:(NSNumber *) appId {
    [TAPromotee showFromViewController:self.navigationController
                                 appId:[appId integerValue]
                               caption:@""
                            completion:^(TAPromoteeUserAction userAction) {
                                switch (userAction) {
                                    case TAPromoteeUserActionDidClose:
                                        // The user just closed the add
                                        break;
                                    case TAPromoteeUserActionDidInstall:
                                        // The user did click on the Install button so here you can for example disable the ad for the future
                                        [self updatePromationAppStatus:[appId integerValue]];
                                        break;
                                }
                            }];
    
    
}

- (NSNumber *)getPromationAppInfo {
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
    
    if (![userDefault boolForKey:kUserDefaultPromotioniOSSkillTree]) {
        [tempArray addObject:[NSNumber numberWithInteger:1099674518]];
    }
    
    if (![userDefault boolForKey:kUserDefaultPromotionWowRadio]) {
        [tempArray addObject:[NSNumber numberWithInteger:1125770301]];
    }
    
    if (tempArray.count == 0) {
        return nil;
    } else {
        NSInteger randomIndex = arc4random()%tempArray.count;
        return tempArray[randomIndex];
    }
}

- (void)updatePromationAppStatus: (NSInteger) appId {
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
        case 1099674518:
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kUserDefaultPromotioniOSSkillTree];
            break;
        case 1125770301:
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kUserDefaultPromotionWowRadio];
            break;
        default:
            break;
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
