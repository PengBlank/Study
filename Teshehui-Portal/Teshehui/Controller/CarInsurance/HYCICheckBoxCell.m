//
//  HYCICheckBoxCell.m
//  Teshehui
//
//  Created by HYZB on 15/6/30.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYCICheckBoxCell.h"

@implementation HYCICheckBoxCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.textLabel.font = [UIFont systemFontOfSize:17.0];
        self.detailTextLabel.font = [UIFont systemFontOfSize:17.0];
        self.detailTextLabel.textAlignment = NSTextAlignmentRight;
        self.separatorLeftInset = 0;
        
        _checkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_checkBtn setFrame:CGRectMake(TFScalePoint(280), 0, 44, 44)];
        [_checkBtn setImage:[UIImage imageNamed:@"icon_check"]
                  forState:UIControlStateNormal];
        [_checkBtn setImage:[UIImage imageNamed:@"icon_check_on"]
                  forState:UIControlStateSelected];
        [_checkBtn addTarget:self
                     action:@selector(checkEvent:)
           forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_checkBtn];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.textLabel.frame = CGRectMake(8, 0, 170, CGRectGetHeight(self.frame));
    self.detailTextLabel.frame = CGRectMake(180, 0,
                                            CGRectGetMinX(_checkBtn.frame)-180,
                                            CGRectGetHeight(self.frame));
}


#pragma mark private methods
- (void)checkEvent:(id)sender
{
    [_checkBtn setSelected:!_checkBtn.isSelected];
    _isChecked = _checkBtn.isSelected;
    if ([self.delegate respondsToSelector:@selector(checkBoxCellIsChecked:)])
    {
        [self.delegate checkBoxCellIsChecked:self];
    }
}

#pragma mark setter/getter
- (void)setIsChecked:(BOOL)isChecked
{
    if (isChecked != _isChecked)
    {
        _isChecked = isChecked;
        [_checkBtn setSelected:_isChecked];
    }
}

@end
