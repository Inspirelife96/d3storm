//
//  D3BookDetailViewController.m
//  wowradio
//
//  Created by Chen XueFeng on 16/2/26.
//  Copyright © 2016年 Chen XueFeng. All rights reserved.
//

#import "D3BookDetailViewController.h"
#import "UIImage+ImageEffects.h"
#import "UILabel+StringFrame.h"
#import "D3CartoonViewController.h"
#import "UIViewController+AppPromotion.h"
#import "AdManager.h"

#import "LSYReadViewController.h"
#import "LSYReadPageViewController.h"
#import "LSYReadUtilites.h"
#import "LSYReadModel.h"

@interface D3BookDetailViewController ()

@property(strong, nonatomic) UILabel *bookDescriptionLabel;

@end

@implementation D3BookDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = [_book objectForKey:@"bookname"];
    
    _bookDetailTableView.delegate = self;
    _bookDetailTableView.dataSource = self;
    _bookDetailTableView.tableFooterView = [[UIView alloc] init];
    
    _bookDescriptionLabel = [[UILabel alloc] init];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.tabBarController) {
        self.tabBarController.tabBar.hidden = YES;
    }
    
    if (self.navigationController) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kUserDefaultIsAdRemoved]) {
        return;
    } else {
        NSInteger randomValue = arc4random()%10;
        NSNumber *appId = [self getPromationAppInfo];
        
        if (randomValue == 9) {
            if (appId) {
                [self promotionApp:appId];
            } else {
                if ([[AdManager sharedInstance] isInterstitialReady]) {
                    [[AdManager sharedInstance] presentInterstitialAdFromRootViewController:self.navigationController];
                } else {
                    [[AdManager sharedInstance] createInterstitial];
                }
            }
        } else if (randomValue == 8) {
            if ([[AdManager sharedInstance] isInterstitialReady]) {
                [[AdManager sharedInstance] presentInterstitialAdFromRootViewController:self.navigationController];
            } else {
                [[AdManager sharedInstance] createInterstitial];
                if (appId) {
                    [self promotionApp:appId];
                }
            }
        }
    }
}

- (void) viewWillLayoutSubviews {
    // description
    _bookDescriptionLabel.font = GetFontAvenirNext(14.0f);
    _bookDescriptionLabel.numberOfLines = 0;
    _bookDescriptionLabel.textColor = FlatGray;
    _bookDescriptionLabel.text = [_book objectForKey:@"bookdescription"];
    CGSize size = [_bookDescriptionLabel boundingRectWithSize:CGSizeMake(self.view.frame.size.width - 20.0f, MAXFLOAT)];
    [_bookDescriptionLabel setFrame:CGRectMake(10.0f, 38.0f, size.width, size.height)];
    
    // images
    UIImage *bookImage = [UIImage imageNamed:[_book objectForKey:@"bookimage"]];;
    _bookImageView.image = bookImage;

    UIImage *blurImage = [bookImage applyBlurWithRadius:5 tintColor:[UIColor colorWithWhite:0.6 alpha:0.2] saturationDeltaFactor:1.0 maskImage:nil];
    _backgoundImageView.image = blurImage;
    _backgoundImageView.alpha = 1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 0) {
        [cell.contentView addSubview:_bookDescriptionLabel];
    } else {
        CGFloat btWidth = (self.view.frame.size.width - 20.0f);
        CGFloat btHeight = 30.0f;
        UIButton *btReadBook = [[UIButton alloc] initWithFrame:CGRectMake(10.0f, 4.0f, btWidth, btHeight)];
        NSInteger bookID = [[_book objectForKey:@"bookid"] integerValue];
        [btReadBook addTarget:self action:@selector(btReadBookClicked:) forControlEvents:UIControlEventTouchUpInside];
        btReadBook.titleLabel.font = GetFontAvenirNext(14.0f);
        [btReadBook setBackgroundImage:[UIImage imageNamed:@"button_large_blue_bg.png"] forState:UIControlStateNormal];
        if (bookID > 100) {
            [btReadBook setTitle:@"开始阅读" forState:UIControlStateNormal];
            [btReadBook setEnabled:YES];
        } else {
            [btReadBook setTitle:@"暂无" forState:UIControlStateNormal];
            [btReadBook setEnabled:NO];
        }
        
        [cell.contentView addSubview:btReadBook];
    }
    
    return cell;
}

- (void) btReadBookClicked:(UIButton*)sender {

    if ([[_book objectForKey:@"bookid"] integerValue] >= 5000) {
        D3CartoonViewController *cartoonVC = [self.storyboard instantiateViewControllerWithIdentifier:@"D3CartoonViewController"];
        NSDictionary *cartoonDict = [D3SharedResource sharedInstance].cartoonDict;
        NSString *cartoonNameString = [_book objectForKey:@"bookname"];
        cartoonVC.cartoonArray = [cartoonDict objectForKey:cartoonNameString];
        [self.navigationController pushViewController:cartoonVC animated:YES];
    } else {
        LSYReadPageViewController *pageView = [[LSYReadPageViewController alloc] init];
        NSURL *fileURL = [[NSBundle mainBundle] URLForResource:[_book objectForKey:@"bookcode"] withExtension:@"txt"];
        pageView.resourceURL = fileURL;    //文件位置
        pageView.model = [LSYReadModel getLocalModelWithURL:fileURL];  //阅读模型
        [self presentViewController:pageView animated:YES completion:nil];
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return _bookDescriptionLabel.frame.size.height + 50.0f;
    } else {
        return 44.0f;
    }
}

@end
