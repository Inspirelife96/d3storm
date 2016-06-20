//
//  D3MapCell.h
//  d3storm
//
//  Created by Chen XueFeng on 16/6/16.
//  Copyright © 2016年 Chen XueFeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "D3MapDataModel.h"

@interface D3MapCell : UITableViewCell

@property(nonatomic, weak) IBOutlet UILabel *mapLabel;
@property(nonatomic, weak) IBOutlet UILabel *contentLabel;

@property (nonatomic, strong) D3MapDataModel *mapData;

@end
