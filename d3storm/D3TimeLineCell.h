//
//  D3TimeLineCell.h
//  d3storm
//
//  Created by Chen XueFeng on 16/6/13.
//  Copyright © 2016年 Chen XueFeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "D3TimeLineDataModel.h"

@interface D3TimeLineCell : UITableViewCell

@property(nonatomic, weak) IBOutlet UILabel *timeLabel;
@property(nonatomic, weak) IBOutlet UILabel *contentLabel;

@property (nonatomic, strong) D3TimeLineDataModel *timeLineData;

@end
