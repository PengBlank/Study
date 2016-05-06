//
//  HYAroundMallAddressCell.m
//  Teshehui
//
//  Created by apple on 15/4/2.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYAroundMallAddressCell.h"

@implementation HYAroundMallAddressCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _iconView = [[UIImageView alloc] initWithFrame:CGRectMake(14, 13, 18, 18)];
        [self.contentView addSubview:_iconView];
        
//        _accessaryView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame)-22, 14.5, 10, 15)];
//        _accessaryView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
//        [self.contentView addSubview:_accessaryView];
        
        self.textLabel.font = [UIFont systemFontOfSize:13];
        self.textLabel.textColor = [UIColor grayColor];
        self.textLabel.backgroundColor = [UIColor clearColor];
        
        self.detailTextLabel.font = [UIFont systemFontOfSize:13];
        self.detailTextLabel.textColor = [UIColor blackColor];
        self.detailTextLabel.textAlignment = NSTextAlignmentLeft;
        self.detailTextLabel.backgroundColor = [UIColor clearColor];
        
        UIButton *phoneBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(ScreenRect)-44, 0, 44, 49)];
        [phoneBtn setImage:[UIImage imageNamed:@"sp_phoe"] forState:UIControlStateNormal];
        [self.contentView addSubview:phoneBtn];
        self.telBtn = phoneBtn;
        
        UIView *sep = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(phoneBtn.frame)-2, 7, 2, 34)];
        sep.backgroundColor = [UIColor colorWithWhite:.93 alpha:1];
        [self.contentView addSubview:sep];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.textLabel.frame = CGRectMake(40, 0, CGRectGetWidth(self.frame)-40-50, CGRectGetHeight(self.frame));
    self.detailTextLabel.frame = CGRectMake(CGRectGetMaxX(self.textLabel.frame), 0, 30, CGRectGetHeight(self.frame));
    //self.detailTextLabel.frame = CGRectMake(265, 12, 35, 20);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
