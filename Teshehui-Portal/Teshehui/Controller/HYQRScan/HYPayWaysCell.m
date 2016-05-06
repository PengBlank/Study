//
//  HYPayWaysCell.m
//  Teshehui
//
//  Created by Kris on 15/8/24.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYPayWaysCell.h"

@implementation HYPayWaysCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        CGRect bounds = [UIScreen mainScreen].bounds;
        
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightBtn setImage:[UIImage imageNamed:@"pay_icon_radio"] forState:UIControlStateNormal];
        [_rightBtn setImage:[UIImage imageNamed:@"pay_icon_radio_on"] forState:UIControlStateSelected];
        [_rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_rightBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
        _rightBtn.frame = CGRectMake(bounds.size.width - 60, 0, 50, 40);
        [_rightBtn setUserInteractionEnabled:NO];
//        [_rightBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_rightBtn];
    }
    return self;
}

-(void)setIsSelected:(BOOL)isSelected
{
    if (isSelected != _isSelected)
    {
        _isSelected = isSelected;
        _rightBtn.selected = isSelected;
    }
}

//- (void)btnClick:(UIButton *)sender
//{
//    if ([self.delegate respondsToSelector:@selector(choosePayment:)])
//    {
//        [self.delegate choosePayment:sender];
//    }
//}

@end
