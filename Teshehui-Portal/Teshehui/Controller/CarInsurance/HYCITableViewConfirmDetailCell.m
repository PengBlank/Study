//
//  HYCITableViewDetailCell.m
//  Teshehui
//
//  Created by 成才 向 on 15/7/1.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYCITableViewConfirmDetailCell.h"

@implementation HYCITableViewConfirmDetailCell

- (void)awakeFromNib {
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.textLabel.font = [UIFont systemFontOfSize:14.0];
        self.detailTextLabel.font = [UIFont systemFontOfSize:14.0];
        self.detailTextLabel.textAlignment = NSTextAlignmentRight;
        self.textLabel.numberOfLines = 0;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.detailTextLabel.frame = CGRectMake(210, 0, CGRectGetWidth(self.frame) - 8 - 210, CGRectGetHeight(self.frame));
    self.textLabel.frame = CGRectMake(8, 0, 200, CGRectGetHeight(self.frame));
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
