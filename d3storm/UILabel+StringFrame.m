//
//  UILabel+StringFrame.m
//  wowradio
//
//  Created by Chen XueFeng on 16/3/22.
//  Copyright © 2016年 Chen XueFeng. All rights reserved.
//

#import "UILabel+StringFrame.h"

@implementation UILabel (StringFrame)

- (CGSize)boundingRectWithSize:(CGSize)size
{
    NSDictionary *attribute = @{NSFontAttributeName: self.font};
    
    CGSize actualSize = [self.text boundingRectWithSize:size
                                                options:\
                         NSStringDrawingTruncatesLastVisibleLine |
                         NSStringDrawingUsesLineFragmentOrigin |
                         NSStringDrawingUsesFontLeading
                                             attributes:attribute
                                                context:nil].size;
    
    return actualSize;
}

@end
