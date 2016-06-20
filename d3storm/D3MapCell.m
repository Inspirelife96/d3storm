//
//  D3MapCell.m
//  d3storm
//
//  Created by Chen XueFeng on 16/6/16.
//  Copyright © 2016年 Chen XueFeng. All rights reserved.
//

#import "D3MapCell.h"

@implementation D3MapCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setMapData:(D3MapDataModel *)mapData {
    _mapData = mapData;
    
    self.mapLabel.text = mapData.mapString;
    self.contentLabel.text = mapData.contentString;
}

@end
