//
//  AdTableViewController.m
//  d3storm
//
//  Created by Chen XueFeng on 16/6/23.
//  Copyright © 2016年 Chen XueFeng. All rights reserved.
//

#import "AdTableViewController.h"

@interface AdTableViewController ()

@property (nonatomic, strong, readwrite) GADBannerView *gAdBannerView;

@end

@implementation AdTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kUserDefaultIsAdRemoved]) {
        if (self.gAdBannerView && self.gAdBannerView.frame.size.width > 0.0f) {
            [self hideBanner:self.gAdBannerView];
        }
    } else {
        [self initgAdBanner];
    }
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initgAdBanner {
    if (!self.gAdBannerView) {
        
        self.gAdBannerView          = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerPortrait];
        self.gAdBannerView.adUnitID = kAdmobBannerID;
        self.gAdBannerView.rootViewController = self;
        self.gAdBannerView.delegate = self;
        self.gAdBannerView.hidden   = TRUE;
        self.view.clipsToBounds = YES;
        
        [self.view addSubview:self.gAdBannerView];
        
        GADRequest *request = [GADRequest request];
        request.testDevices = @[@"007ee895fbc5dca2f28e11feb0414433", @"45c243aa392382f9ed49a9e3617336fa", @"55d28e54f40dc98d245ad832e5c6aec897be7ac6", @"Simulator"];
        [self.gAdBannerView loadRequest:request];
    }
}

#pragma mark - Banner hide and show -

-(void)hideBanner:(UIView*)banner {
    if (banner && ![banner isHidden]) {
        self.gAdBannerView.frame = CGRectMake(0.0f,
                                              MainScreenHeight - banner.frame.size.height,
                                              0.0f,
                                              0.0f);
        banner.hidden = TRUE;
    }
}

-(void)showBanner:(UIView*)banner {
    
    if (banner && [banner isHidden]) {
        self.gAdBannerView.frame = CGRectMake(0.0,
                                              MainScreenHeight - banner.frame.size.height,
                                              banner.frame.size.width,
                                              banner.frame.size.height);
        banner.hidden = FALSE;
    }
}

#pragma mark - GADBanner delegate methods -
- (void)adViewDidReceiveAd:(GADBannerView *)view {
    
    NSLog(@"Admob load");
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:kUserDefaultIsAdRemoved]) {
        [self showBanner:self.gAdBannerView];
    }
    else {
        [self hideBanner:self.gAdBannerView];
    }
}

- (void)adView:(GADBannerView *)view didFailToReceiveAdWithError:(GADRequestError *)error {
    
    NSLog(@"Admob error: %@", error);
    [self hideBanner:self.gAdBannerView];
}

@end
