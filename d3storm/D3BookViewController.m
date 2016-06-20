//
//  D3BookViewController.m
//  wowradio
//
//  Created by Chen XueFeng on 16/2/23.
//  Copyright © 2016年 Chen XueFeng. All rights reserved.
//

#import "D3BookViewController.h"
#import "D3BookCell.h"
#import "D3BookHeaderView.h"

#import "D3BookDetailViewController.h"

@interface D3BookViewController ()

@property(copy, nonatomic) NSArray *bookArray;

@end

@implementation D3BookViewController

static NSString * const reuseIdentifier = @"D3BookCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _bookArray = [D3SharedResource sharedInstance].bookArray;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.tabBarController) {
        self.tabBarController.tabBar.hidden = NO;
    }
    
    if (self.navigationController) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return _bookArray.count;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSDictionary *dict = _bookArray[section];
    NSArray *books = [dict objectForKey:@"books"];
    return books.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    D3BookCell *cell = (D3BookCell*)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    NSDictionary *dict = _bookArray[indexPath.section];
    NSArray *books = [dict objectForKey:@"books"];
    NSDictionary *book = books[indexPath.row];
    
    UIImage *image = [UIImage imageNamed:[book objectForKey:@"bookimage"]];
    
    cell.bookImageView.image = image;
    cell.bookImageView.layer.cornerRadius = 5.0f;
    cell.bookImageView.layer.masksToBounds = YES;
    cell.bookNameLabel.text = [book objectForKey:@"bookname"];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = (self.view.bounds.size.width - 30.0f)/3.0f;
    CGFloat height = (width/10.0f)*16.0f + 25.0f;
    return CGSizeMake(width, height);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    D3BookHeaderView *reusableview = nil;
    if (kind == UICollectionElementKindSectionHeader){
        D3BookHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"D3BookHeaderView" forIndexPath:indexPath];
        
        NSDictionary *dict = _bookArray[indexPath.section];
        
        headerView.titleLabel.text = [dict objectForKey:@"name"];
        reusableview = headerView;
    }
    
    return reusableview;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *dict = _bookArray[indexPath.section];
    NSArray *books = [dict objectForKey:@"books"];
    NSDictionary *book = books[indexPath.row];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    D3BookDetailViewController *bookDetailVC = [storyboard instantiateViewControllerWithIdentifier:@"D3BookDetailViewController"];
    bookDetailVC.book = book;
    
    [self.navigationController pushViewController:bookDetailVC animated:YES];
    
}

@end
