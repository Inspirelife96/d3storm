//
//  D3TimeLineCell.m
//  d3storm
//
//  Created by Chen XueFeng on 16/6/13.
//  Copyright © 2016年 Chen XueFeng. All rights reserved.
//

#import "D3TimeLineCell.h"


@interface D3TimeLineCell ()



@end

@implementation D3TimeLineCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.bounds = [UIScreen mainScreen].bounds;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setTimeLineData:(D3TimeLineDataModel *)timeLineData {
    _timeLineData = timeLineData;
    
    self.timeLabel.text = timeLineData.timeString;
    self.contentLabel.text = timeLineData.contentString;
}


@end
