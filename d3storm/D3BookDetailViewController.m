//
//  D3BookDetailViewController.m
//  wowradio
//
//  Created by Chen XueFeng on 16/2/26.
//  Copyright © 2016年 Chen XueFeng. All rights reserved.
//

#import "D3BookDetailViewController.h"
#import "TReaderViewController.h"
#import "TReaderBook.h"
#import "UIImage+ImageEffects.h"
#import "UILabel+StringFrame.h"

@interface D3BookDetailViewController ()

@property(strong, nonatomic) UILabel *bookDescriptionLabel;

@end

@implementation D3BookDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = [_book objectForKey:@"bookname"];
    
    _bookDescriptionLabel = [[UILabel alloc] init];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.tabBarController) {
        self.tabBarController.tabBar.hidden = NO;
    }
    
    if (self.navigationController) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
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
        [btReadBook setTitle:@"开始阅读" forState:UIControlStateNormal];
        [btReadBook addTarget:self action:@selector(btReadBookClicked:) forControlEvents:UIControlEventTouchUpInside];
        [btReadBook setBackgroundImage:[UIImage imageNamed:@"button_large_blue_bg.png"] forState:UIControlStateNormal];
        
        [cell.contentView addSubview:btReadBook];
    }
    
    return cell;
}

- (void) btReadBookClicked:(UIButton*)sender {

    TReaderViewController *readerVC = [[TReaderViewController alloc]init];
    TReaderBook *book = [[TReaderBook alloc] init];
    book.bookId = [[_book objectForKey:@"bookid"] integerValue];
    book.bookName = [_book objectForKey:@"bookcode"];
    [book initChapterList];
    readerVC.style = TReaderTransitionStyleScroll;
    readerVC.readerBook = book;
    [self.navigationController pushViewController:readerVC animated:YES];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return _bookDescriptionLabel.frame.size.height + 50.0f;
    } else {
        return 44.0f;
    }
}

@end
