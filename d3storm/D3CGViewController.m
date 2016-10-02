//
//  D3CGViewController.m
//  
//
//  Created by Chen XueFeng on 16/2/22.
//
//
@import GoogleMobileAds;

#import "D3CGViewController.h"

#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>

#import "D3CGCell.h"
#import "D3CGHeaderView.h"
#import "D3CGPlayerViewController.h"
#import "Reachability.h"
#import "UIViewController+Alert.h"
#import "UIViewController+VIPPromotion.h"
#import "CoinManager.h"
#import "UIViewController+IAPNotification.h"
#import "UIViewController+UseKey.h"

@interface D3CGViewController ()

@property (copy,   nonatomic) NSArray  *cgArray;
@property (strong, nonatomic) UIButton *navRightButton;

@end

@implementation D3CGViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _navRightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    [_navRightButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    _navRightButton.titleLabel.font = GetFontAvenirNext(15.0);
    _navRightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [_navRightButton addTarget:self action:@selector(barButtonKeyClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_navRightButton];
    
    _cgArray = [D3SharedResource sharedInstance].cgArray;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleCoinChangedNotification) name:kNotificationCoinChanged object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleVIPChangedNotification) name:kNotificationVIPChanged object:nil];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self addIAPNotification];
    
    if (IsVip) {
        [_navRightButton setTitle:@"VIP" forState:UIControlStateNormal];
    } else {
        [_navRightButton setTitle:[NSString stringWithFormat:@"%ld🔑", (long)[CoinManager getCoin]] forState:UIControlStateNormal];
    }
}

- (void) viewWillDisappear:(BOOL)animated {
    
    [self removeIAPNotification];
    [super viewWillDisappear:animated];
}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationCoinChanged object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationVIPChanged object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)handleCoinChangedNotification {
    if (!IsVip) {
        NSInteger currentCoin = [CoinManager getCoin];
        NSString *currentCoinString = [NSString stringWithFormat:@"%ld🔑", (long)currentCoin];
        [_navRightButton setTitle:currentCoinString forState:UIControlStateNormal];
    }
}

- (void)handleVIPChangedNotification {
    if (IsVip) {
        [_navRightButton setTitle:@"VIP" forState:UIControlStateNormal];
    } else {
        [_navRightButton setTitle:[NSString stringWithFormat:@"%ld🔑", (long)[CoinManager getCoin]] forState:UIControlStateNormal];
    }
}

- (void)barButtonKeyClicked :(UIButton*) sender {
    
    if (IsVip) {
        [self showVipAlert:@"VIP有什么特权" message:@"VIP可以观看任何CG。" cancelTitle:@"知道了" sender:sender];
    } else {
        [self showVIPPromotion:@"🔑有什么用？" message:@"观看CG会消耗金钥匙，每天首次开启APP会免费获得3把，您可以通过以下方式获得额外的金钥匙。" cancelTitle:@"知道了" sender:sender];
    }
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return _cgArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    NSDictionary *cgDict = _cgArray[section];
    NSArray *currentSectionArray = [cgDict objectForKey:@"cgs"];
    return currentSectionArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    D3CGCell *cell = (D3CGCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"D3CGCell" forIndexPath:indexPath];
    
    NSDictionary *cgDict = _cgArray[indexPath.section];
    NSArray *currentSectionArray = [cgDict objectForKey:@"cgs"];
    
    cell.videoInfoDict = currentSectionArray[indexPath.row];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = (self.view.bounds.size.width - 20.0f)/2.0f;
    CGFloat height = (width/8.0f)*5.0f + 25.0f;
    
    return CGSizeMake(width, height);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    D3CGHeaderView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader){
        
        D3CGHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"D3CGHeaderView" forIndexPath:indexPath];
        
        NSDictionary *cgDict = _cgArray[indexPath.section];
        headerView.sectionTitleLabel.text = [cgDict objectForKey:@"name"];
        reusableview = headerView;
        
    }
    
    return reusableview;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *cgDict = _cgArray[indexPath.section];
    NSArray *currentSectionArray = [cgDict objectForKey:@"cgs"];
    D3CGCell *cgCell = (D3CGCell*)[collectionView cellForItemAtIndexPath:indexPath];
    
    [self userKeyOn:cgCell actionBlock:^{
        [self playVideo:currentSectionArray[indexPath.row]];
    }];
}

- (void)playVideo:(NSDictionary*)videoInfoDict {
    if (!IsVip) {
        [CoinManager changeCoin:-1];
    }
    
    D3CGPlayerViewController *cgPlayerVC = [self.storyboard instantiateViewControllerWithIdentifier:@"D3CGPlayerViewController"];
    cgPlayerVC.videoInfoDict = videoInfoDict;
    [self.navigationController pushViewController:cgPlayerVC animated:YES];
    
}

@end
