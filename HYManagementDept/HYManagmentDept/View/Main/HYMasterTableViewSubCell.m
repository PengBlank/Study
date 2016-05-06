//
//  HYMasterTableViewSubCell.m
//  HYManagmentDept
//
//  Created by RayXiang on 14-5-21.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYMasterTableViewSubCell.h"
#include "HYStyleConst.h"

@implementation HYMasterTableViewSubCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _contentLabel.backgroundColor = [UIColor clearColor];
        _contentLabel.textColor = [UIColor whiteColor];
        _contentLabel.font = [UIFont systemFontOfSize:14];
        _contentLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.contentView addSubview:_contentLabel];
        self.clipsToBounds = YES;

        self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.bounds];
        self.selectedBackgroundView.backgroundColor = kTableBackColor;
        
        self.separatorLeftInset = 36;
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
//    [super setSelected:selected animated:animated];
    self.hiddenLine = NO;
    if (selected)
    {
        self.backgroundColor = kTableSubcontentSelectColor;
    }
    else
    {
        self.backgroundColor = kTableBackColor;
    }
    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect frame;
    frame = CGRectMake(36, 0, CGRectGetWidth(self.frame)-40, CGRectGetHeight(self.frame));
    _contentLabel.frame = frame;
}

@end
