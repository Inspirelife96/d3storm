//
//  LSYReadPageViewController.m
//  LSYReader
//
//  Created by Labanotation on 16/5/30.
//  Copyright © 2016年 okwei. All rights reserved.
//

#import "LSYReadPageViewController.h"
#import "LSYReadViewController.h"
#import "LSYChapterModel.h"
#import "LSYMenuView.h"
#import "LSYCatalogViewController.h"
#import "UIImage+ImageEffects.h"
#import "LSYNoteModel.h"
#import "LSYMarkModel.h"
#import <objc/runtime.h>

@import GoogleMobileAds;

#define AnimationDelay 0.3

@interface LSYReadPageViewController ()<UIPageViewControllerDelegate,UIPageViewControllerDataSource,LSYMenuViewDelegate,UIGestureRecognizerDelegate,LSYCatalogViewControllerDelegate,LSYReadViewControllerDelegate, GADBannerViewDelegate>
{
    NSUInteger _chapter;    //当前显示的章节
    NSUInteger _page;       //当前显示的页数
    NSUInteger _chapterChange;  //将要变化的章节
    NSUInteger _pageChange;     //将要变化的页数
    BOOL _isTransition;     //是否开始翻页
}
@property (nonatomic,strong) UIPageViewController *pageViewController;
@property (nonatomic,getter=isShowBar) BOOL showBar; //是否显示状态栏
@property (nonatomic,strong) LSYMenuView *menuView; //菜单栏
@property (nonatomic,strong) LSYCatalogViewController *catalogVC;   //侧边栏
@property (nonatomic,strong) UIView * catalogView;  //侧边栏背景
@property (nonatomic,strong) LSYReadViewController *readView;   //当前阅读视图
@property (nonatomic,strong) GADBannerView *gadBannerView;

@end

@implementation LSYReadPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addChildViewController:self.pageViewController];
    [_pageViewController setViewControllers:@[[self readViewWithChapter:_model.record.chapter page:_model.record.page]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    _chapter = _model.record.chapter;
    _page = _model.record.page;
    [self.view addGestureRecognizer:({
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showToolMenu)];
        tap.delegate = self;
        tap;
    })];
    [self.view addSubview:self.menuView];
    
    [self addChildViewController:self.catalogVC];
    [self.view addSubview:self.catalogView];
    [self.catalogView addSubview:self.catalogVC.view];
    //添加笔记
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addNotes:) name:LSYNoteNotification object:nil];

    if (IsAdRemoved) {
        //
    } else {
        [self initGADBanner];
    }
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
}

-(void)addNotes:(NSNotification *)no
{
    LSYNoteModel *noteModel = no.object;
    LSYChapterModel *chapterModel = _model.record.chapterModel;
    noteModel.location += [chapterModel.pageArray[_model.record.page] integerValue];
    noteModel.chapter = chapterModel.chapterIndex;
    noteModel.recordModel = [_model.record copy];
    [[_model mutableArrayValueForKey:@"notes"] addObject:noteModel];    //这样写才能KVO数组变化
    [LSYReadUtilites showAlertTitle:nil content:@"保存笔记成功"];
}

-(BOOL)prefersStatusBarHidden
{
    return !_showBar;
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
-(void)showToolMenu
{
    /*
    [_readView.readView cancelSelected];
    NSString * key = [NSString stringWithFormat:@"%d_%d",(int)_model.record.chapter,(int)_model.record.page];
    
    id state = _model.marksRecord[key];
     */
    
    BOOL isMarked = FALSE;
    
    LSYRecordModel *recordModel = _model.record;
    LSYChapterModel *chapterModel = recordModel.chapterModel;
    
    NSUInteger startIndex = [chapterModel.pageArray[recordModel.page] integerValue];
    
    NSUInteger endIndex = NSUIntegerMax;
    NSUInteger chapter = recordModel.chapter;
    
    if (recordModel.page < chapterModel.pageCount - 1) {
        endIndex = [chapterModel.pageArray[recordModel.page + 1] integerValue];
    }
    
    for (int i = 0; i < _model.marks.count; i++) {
        LSYMarkModel *markModel = _model.marks[i];
        if (markModel.chapter == chapter && markModel.location >= startIndex && markModel.location < endIndex) {
            isMarked = YES;
            break;
        }
    }
    
    isMarked?(_menuView.topView.state=1): (_menuView.topView.state=0);
    [self.menuView showAnimation:YES];
}

#pragma mark - init
-(LSYMenuView *)menuView
{
    if (!_menuView) {
        _menuView = [[LSYMenuView alloc] init];
        _menuView.hidden = YES;
        _menuView.delegate = self;
        _menuView.recordModel = _model.record;
    }
    return _menuView;
}
-(UIPageViewController *)pageViewController
{
    if (!_pageViewController) {
        _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
        _pageViewController.delegate = self;
        _pageViewController.dataSource = self;
        [self.view addSubview:_pageViewController.view];
    }
    return _pageViewController;
}
-(LSYCatalogViewController *)catalogVC
{
    if (!_catalogVC) {
        _catalogVC = [[LSYCatalogViewController alloc] init];
        _catalogVC.readModel = _model;
        _catalogVC.catalogDelegate = self;
    }
    return _catalogVC;
}
-(UIView *)catalogView
{
    if (!_catalogView) {
        _catalogView = [[UIView alloc] init];
        _catalogView.backgroundColor = [UIColor clearColor];
        _catalogView.hidden = YES;
        [_catalogView addGestureRecognizer:({
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenCatalog)];
            tap.delegate = self;
            tap;
        })];
    }
    return _catalogView;
}
#pragma mark - CatalogViewController Delegate
-(void)catalog:(LSYCatalogViewController *)catalog didSelectChapter:(NSUInteger)chapter page:(NSUInteger)page
{
     [_pageViewController setViewControllers:@[[self readViewWithChapter:chapter page:page]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    [self updateReadModelWithChapter:chapter page:page];
    [self hiddenCatalog];
    
}
#pragma mark -  UIGestureRecognizer Delegate
//解决TabView与Tap手势冲突
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return  YES;
}
#pragma mark - Privite Method
-(void)catalogShowState:(BOOL)show
{
    show?({
        _catalogView.hidden = !show;
        [UIView animateWithDuration:AnimationDelay animations:^{
            _catalogView.frame = CGRectMake(0, 0,2*ViewSize(self.view).width, ViewSize(self.view).height);
            
        } completion:^(BOOL finished) {
            [_catalogView insertSubview:[[UIImageView alloc] initWithImage:[self blurredSnapshot]] atIndex:0];
        }];
    }):({
        if ([_catalogView.subviews.firstObject isKindOfClass:[UIImageView class]]) {
            [_catalogView.subviews.firstObject removeFromSuperview];
        }
        [UIView animateWithDuration:AnimationDelay animations:^{
             _catalogView.frame = CGRectMake(-ViewSize(self.view).width, 0, 2*ViewSize(self.view).width, ViewSize(self.view).height);
        } completion:^(BOOL finished) {
            _catalogView.hidden = !show;
            
        }];
    });
}
-(void)hiddenCatalog
{
    [self catalogShowState:NO];
}
- (UIImage *)blurredSnapshot {
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)), NO, 1.0f);
    [self.view drawViewHierarchyInRect:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)) afterScreenUpdates:NO];
    UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIImage *blurredSnapshotImage = [snapshotImage applyLightEffect];
    UIGraphicsEndImageContext();
    return blurredSnapshotImage;
}
#pragma mark - Menu View Delegate
-(void)menuViewDidHidden:(LSYMenuView *)menu
{
     _showBar = NO;
    [self setNeedsStatusBarAppearanceUpdate];
}
-(void)menuViewDidAppear:(LSYMenuView *)menu
{
    _showBar = YES;
    [self setNeedsStatusBarAppearanceUpdate];
    
}
-(void)menuViewInvokeCatalog:(LSYBottomMenuView *)bottomMenu
{
    [_menuView hiddenAnimation:NO];
    [self catalogShowState:YES];
    
}

-(void)menuViewJumpChapter:(NSUInteger)chapter page:(NSUInteger)page
{
    [_pageViewController setViewControllers:@[[self readViewWithChapter:chapter page:page]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    [self updateReadModelWithChapter:chapter page:page];
}
-(void)menuViewFontSize:(LSYBottomMenuView *)bottomMenu
{
    [_model.record.chapterModel updateFont];
    
    for (int i = 0; i < _model.chapters.count; i++) {
        [_model.chapters[i] updateFont];
    }
    
    [_pageViewController setViewControllers:@[[self readViewWithChapter:_model.record.chapter page:(_model.record.page>_model.record.chapterModel.pageCount-1)?_model.record.chapterModel.pageCount-1:_model.record.page]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    [self updateReadModelWithChapter:_model.record.chapter page:(_model.record.page>_model.record.chapterModel.pageCount-1)?_model.record.chapterModel.pageCount-1:_model.record.page];
}

-(void)menuViewMark:(LSYTopMenuView *)topMenu
{
    /*
    NSString * key = [NSString stringWithFormat:@"%d_%d",(int)_model.record.chapter,(int)_model.record.page];
    id state = _model.marksRecord[key];
     */
    
    BOOL isMarked = FALSE;
    
    LSYRecordModel *recordModel = _model.record;
    LSYChapterModel *chapterModel = recordModel.chapterModel;
    
    NSUInteger startIndex = [chapterModel.pageArray[recordModel.page] integerValue];
    
    NSUInteger endIndex = NSUIntegerMax;
    
    if (recordModel.page < chapterModel.pageCount - 1) {
        endIndex = [chapterModel.pageArray[recordModel.page + 1] integerValue];
    }
    
    NSMutableArray *markedArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < _model.marks.count; i++) {
        LSYMarkModel *markModel = _model.marks[i];
        if (markModel.location >= startIndex && markModel.location <= endIndex) {
            isMarked = YES;
            [markedArray addObject:markModel];
        }
    }
    
    if (isMarked) {
        [[_model mutableArrayValueForKey:@"marks"] removeObjectsInArray:markedArray];
    } else {
        LSYRecordModel *recordModel = _model.record;
        LSYMarkModel *markModel = [[LSYMarkModel alloc] init];
        markModel.date = [NSDate date];
        markModel.location = [recordModel.chapterModel.pageArray[recordModel.page] integerValue];
        markModel.length = 0;
        markModel.chapter = recordModel.chapter;
        markModel.recordModel = [_model.record copy];
        [[_model mutableArrayValueForKey:@"marks"] addObject:markModel];
        //[_model.marksRecord setObject:markModel forKey:key];
    }
    
    _menuView.topView.state = !isMarked;
}
#pragma mark - Create Read View Controller

-(LSYReadViewController *)readViewWithChapter:(NSUInteger)chapter page:(NSUInteger)page{

    
    if (_model.record.chapter != chapter) {
        [self updateReadModelWithChapter:chapter page:page];
        [_model.record.chapterModel updateFont];
    }
    _readView = [[LSYReadViewController alloc] init];
    _readView.recordModel = _model.record;
    _readView.content = [_model.chapters[chapter] stringOfPage:page];
    _readView.delegate = self;
    NSLog(@"_readGreate");
    
    return _readView;
}
-(void)updateReadModelWithChapter:(NSUInteger)chapter page:(NSUInteger)page
{
    _chapter = chapter;
    _page = page;
    _model.record.chapterModel = _model.chapters[chapter];
    _model.record.chapter = chapter;
    _model.record.page = page;
    _model.font = [NSNumber numberWithFloat:[LSYReadConfig shareInstance].fontSize];
    [LSYReadModel updateLocalModel:_model url:_resourceURL];
}
#pragma mark - Read View Controller Delegate
-(void)readViewEndEdit:(LSYReadViewController *)readView
{
    for (UIGestureRecognizer *ges in self.pageViewController.view.gestureRecognizers) {
        if ([ges isKindOfClass:[UIPanGestureRecognizer class]]) {
            ges.enabled = YES;
            break;
        }
    }
}
-(void)readViewEditeding:(LSYReadViewController *)readView
{
    for (UIGestureRecognizer *ges in self.pageViewController.view.gestureRecognizers) {
        if ([ges isKindOfClass:[UIPanGestureRecognizer class]]) {
            ges.enabled = NO;
            break;
        }
    }
}
#pragma mark -PageViewController DataSource
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{

    _pageChange = _page;
    _chapterChange = _chapter;

    if (_chapterChange==0 &&_pageChange == 0) {
        return nil;
    }
    if (_pageChange==0) {
        _chapterChange--;
        _pageChange = _model.chapters[_chapterChange].pageCount-1;
    }
    else{
        _pageChange--;
    }
    
    return [self readViewWithChapter:_chapterChange page:_pageChange];
    
}
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{

    _pageChange = _page;
    _chapterChange = _chapter;
    if (_pageChange == _model.chapters.lastObject.pageCount-1 && _chapterChange == _model.chapters.count-1) {
        return nil;
    }
    if (_pageChange == _model.chapters[_chapterChange].pageCount-1) {
        _chapterChange++;
        _pageChange = 0;
    }
    else{
        _pageChange++;
    }
    return [self readViewWithChapter:_chapterChange page:_pageChange];
}
#pragma mark -PageViewController Delegate
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    if (!completed) {
        LSYReadViewController *readView = previousViewControllers.firstObject;
        _readView = readView;
        _page = readView.recordModel.page;
        _chapter = readView.recordModel.chapter;
    }
    else{
        [self updateReadModelWithChapter:_chapter page:_page];
    }
}
- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers
{
    _chapter = _chapterChange;
    _page = _pageChange;
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    CGFloat bannerHeight = 50.0f;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        bannerHeight = 90.0f;
    }
    
    _pageViewController.view.frame = CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height - bannerHeight);
    _menuView.frame = CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height - bannerHeight);
    _catalogView.frame = CGRectMake(-ViewSize(self.view).width, 0, 2*ViewSize(self.view).width, ViewSize(self.view).height);
    _catalogVC.view.frame = CGRectMake(0, 0, ViewSize(self.view).width-100, ViewSize(self.view).height);
    [_catalogVC reload];

}

-(void)initGADBanner {
    if (!_gadBannerView) {
        
        _gadBannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerPortrait];
        _gadBannerView.adUnitID = kAdmobBannerID;
        _gadBannerView.rootViewController = self;
        _gadBannerView.delegate = self;
        _gadBannerView.hidden   = YES;
        
        self.view.clipsToBounds = YES;
        [self.view addSubview:_gadBannerView];
        
        GADRequest *request = [GADRequest request];
        request.testDevices = @[@"007ee895fbc5dca2f28e11feb0414433", @"45c243aa392382f9ed49a9e3617336fa", @"55d28e54f40dc98d245ad832e5c6aec897be7ac6", @"Simulator"];
        [_gadBannerView loadRequest:request];
    }
}

-(void)hideBanner:(UIView*)banner {
    if (banner && ![banner isHidden]) {
        _gadBannerView.frame = CGRectMake(0.0f,
                                          MainScreenHeight - banner.frame.size.height,
                                          0.0f,
                                          0.0f);
        banner.hidden = TRUE;
    }
}

-(void)showBanner:(UIView*)banner {
    
    if (banner && [banner isHidden]) {
        _gadBannerView.frame = CGRectMake(0.0,
                                          MainScreenHeight - banner.frame.size.height,
                                          banner.frame.size.width,
                                          banner.frame.size.height);
        banner.hidden = FALSE;
    }
}

#pragma mark - GADBanner delegate methods -
- (void)adViewDidReceiveAd:(GADBannerView *)view {
    NSLog(@"Admob load");
    [self showBanner:_gadBannerView];
}

- (void)adView:(GADBannerView *)view didFailToReceiveAdWithError:(GADRequestError *)error {
    NSLog(@"Admob error: %@", error);
    [self hideBanner:_gadBannerView];
}

@end
