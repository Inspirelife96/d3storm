//
//  D3CGCell.m
//  
//
//  Created by Chen XueFeng on 16/2/22.
//
//

#import "D3CGCell.h"

@implementation D3CGCell

- (void)setVideoInfoDict:(NSDictionary *)videoInfoDict {
    
    _videoImageView.image = [UIImage imageNamed:[videoInfoDict objectForKey:@"cgimage"]];
    _videoNameLabel.text = [NSString stringWithFormat:@"🔑%@", [videoInfoDict objectForKey:@"cgname"]];
}

@end
