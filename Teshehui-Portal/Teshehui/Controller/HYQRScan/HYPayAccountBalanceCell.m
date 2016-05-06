//
//  HYAccountBalanceCell.m
//  Teshehui
//
//  Created by Kris on 15/8/24.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYPayAccountBalanceCell.h"
#import "HYUserCashAccountInfo.h"

@implementation HYPayAccountBalanceCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        CGRect bounds = [UIScreen mainScreen].bounds;
        
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightBtn setImage:[UIImage imageNamed:@"pay_icon_radio"] forState:UIControlStateNormal];
        [_rightBtn setImage:[UIImage imageNamed:@"pay_icon_radio_on"] forState:UIControlStateSelected];
        [_rightBtn setTitle:@"使用余额" forState:UIControlStateNormal];
        _rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_rightBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
        _rightBtn.frame = CGRectMake(bounds.size.width - 120, 3, 100, 40);
        [_rightBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        _rightBtn.userInteractionEnabled = NO;
        [self.contentView addSubview:_rightBtn];
        
    }
    return self;
}

- (void)btnClick:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(useAccountBalance:)])
    {
        [self.delegate useAccountBalance:sender];
    }
}

#pragma mark setter/getter

- (void)setData:(HYUserCashAccountInfo *)data
{
    if (data != _data)
    {
        _data = data;
        
        NSString *text = [NSString stringWithFormat:@"钱包余额:￥%.02f",[data.balance floatValue]];
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:text];
        [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(0, 4)];
        [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(4, text.length-4)];
        self.textLabel.attributedText = attrStr;
    }
}

-(void)setIsSelected:(BOOL )isSelected
{
    if (isSelected) {
        _rightBtn.selected = YES;
    }else _rightBtn.selected = NO;
    
}
@end
