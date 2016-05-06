//
//  O2OOrderCell.m
//  Teshehui
//
//  Created by wufeilinMacmini on 16/4/1.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "O2OOrderCell.h"

#import "UIColor+expanded.h"

@interface O2OOrderCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageVIew;  // 图标

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;         // 标题

@property (weak, nonatomic) IBOutlet UIView *lineView; // 线

@end

@implementation O2OOrderCell

- (void)refreshUIWithImage:(NSString *)image Title:(NSString *)title IndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        [self.lineView setBackgroundColor:[UIColor colorWithHexString:@"f1f1f1"]];
    }
    [self.iconImageVIew setImage:[UIImage imageNamed:image]];
    self.titleLabel.text = title;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
