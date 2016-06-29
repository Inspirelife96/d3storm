//
//  ViewController.m
//  PageViewDemo
//
//  Created by Simon on 24/11/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import "D3CartoonViewController.h"
#import "VIPhotoView.h"
#import <SDWebImage/SDWebImageManager.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import "UIViewController+Alert.h"

@interface D3CartoonViewController ()

@end

@implementation D3CartoonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.tabBarController) {
        self.tabBarController.tabBar.hidden = YES;
    }
    
    // Create page view controller
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"D3CartoonPageViewController"];
    self.pageViewController.dataSource = self;
    
    D3CartoonPageContentViewController *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    // Change the size of page view controller
    if (IsVip) {
        self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    } else {
        self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - BottomBarHeight);
    }
    
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    self.view.backgroundColor = FlatGrayDark;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (D3CartoonPageContentViewController *)viewControllerAtIndex:(NSUInteger)index {
    if (([_cartoonArray count] == 0) || (index >= [_cartoonArray count])) {
        return nil;
    }
    
    // Create a new view controller and pass suitable data.
    D3CartoonPageContentViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"D3CartoonPageContentViewController"];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    NSString *cartoonLinkString = [_cartoonArray objectAtIndex:index];
    [manager downloadImageWithURL:[NSURL URLWithString:cartoonLinkString]
                          options:0
                         progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                             // progression tracking code
                         }
                        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                            [MBProgressHUD hideHUDForView:self.view animated:YES];
                            if (image) {
                                VIPhotoView *photoView = [[VIPhotoView alloc] initWithFrame:self.view.bounds andImage:image];
                                [photoView setBackgroundColor:FlatBlackDark];
                                photoView.autoresizingMask = (1 << 6) - 1;
                                [pageContentViewController.view addSubview:photoView];
                            } else {
                                [self presentAlertTitle:@"漫画下载失败" message:@"貌似您的网络有点故障，请确认网络状态后再次尝试！"];
                                return;
                            }
                        }];
    
    pageContentViewController.pageIndex = index;
    
    return pageContentViewController;
}

#pragma mark - Page View Controller Data Source
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSUInteger index = ((D3CartoonPageContentViewController*) viewController).pageIndex;
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSUInteger index = ((D3CartoonPageContentViewController*) viewController).pageIndex;
    
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [_cartoonArray count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    return [_cartoonArray count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    return 0;
}

@end
