//
//  D3CGCell.h
//  
//
//  Created by Chen XueFeng on 16/2/22.
//
//

#import <UIKit/UIKit.h>

@interface D3CGCell : UICollectionViewCell

@property (nonatomic, weak) IBOutlet UIWebView *videoWebView;
@property (nonatomic, weak) IBOutlet UILabel *videoNameLabel;

@property(copy, nonatomic) NSDictionary *videoInfoDict;


@end
