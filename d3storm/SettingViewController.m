//
//  SettingViewController.m
//  
//
//  Created by Chen XueFeng on 16/5/27.
//
//

#import "SettingViewController.h"

#import "IAPViewController.h"
#import "ILUtilities.h"
#import "UIViewController+Share.h"
#import "UIViewController+SendEmailInApp.h"
#import "AboutUsViewController.h"

@interface SettingViewController ()

@property(copy, nonatomic) NSArray *sectionArray;
@property(copy, nonatomic) NSArray *rowArray;
@property(strong, nonatomic) UISwitch *dailyNotificationSwitch;
@property(strong, nonatomic) UILabel *timeLabel;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"设置";
    
    NSArray *row1Array = [NSArray arrayWithObjects:@"意见与反馈", nil];
    NSArray *row2Array = [NSArray arrayWithObjects:@"去评分啦", @"分享给好友", nil];
    NSArray *row3Array = [NSArray arrayWithObjects:@"购买", nil];
    NSArray *row4Array = [NSArray arrayWithObjects:@"关于[小说，CG合集 For 暗黑破坏神]", nil];
    
    _rowArray = [NSArray arrayWithObjects:row1Array, row2Array, row3Array, row4Array, nil];
    _sectionArray = [NSArray arrayWithObjects:@"", @"", @"", @"", nil];
    self.tableView.tableFooterView = [[UIView alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _sectionArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *rowArray = (NSArray *)_rowArray[section];
    return rowArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DefaultSettingCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DefaultSettingCell"];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = _rowArray[indexPath.section][indexPath.row];
    cell.textLabel.font = GetFontAvenirNext(14);
    cell.textLabel.textColor = FlatGrayDark;
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    UITableViewCell *currentCell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (section == 0) {
        NSString *subject = @"小说，CG合集 For 暗黑破坏神 用户反馈";
        NSArray *recipientArray = [NSArray arrayWithObject: @"inspirelife@hotmail.com"];
        NSString *body = @"";
        
        NSDictionary *emaidContentDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                          subject, @"subject",
                                          recipientArray, @"recipients",
                                          body, @"body",
                                          nil];
        
        [self sendMailInApp:emaidContentDict];
    } else if (section == 1) {
        if (row == 0) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kAppReviewURL]];
        } else {
            [self shareMessage:@"我正在用［小说，CG合集 For 暗黑破坏神］看暗黑破坏神的故事，快来和我一起体验史诗故事吧！下载地址：http://itunes.apple.com/app/id1125770301" onView:currentCell];
        }
    } else if (section == 2) {
        IAPViewController *IAPVC = [[IAPViewController alloc] initWithStyle:UITableViewStyleGrouped];
        [self.navigationController pushViewController:IAPVC animated:YES];
    } else if (section == 3) {
        AboutUsViewController *aboutUsVC = [[AboutUsViewController alloc] initWithStyle:UITableViewStylePlain];
        [self.navigationController pushViewController:aboutUsVC animated:YES];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [_sectionArray objectAtIndex:section];
}

@end
