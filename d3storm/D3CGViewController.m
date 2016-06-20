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

@interface D3CGViewController ()


@property(copy, nonatomic) NSArray *cgArray;

@end

@implementation D3CGViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _cgArray = [D3SharedResource sharedInstance].cgArray;
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void) dealloc {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
    //
}



@end
