//
//  HYInputCell.m
//  Teshehui
//
//  Created by ichina on 14-3-5.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYInputCell.h"

@implementation HYInputCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _nameLab = [[UILabel alloc]initWithFrame:CGRectZero];
        _nameLab.backgroundColor = [UIColor clearColor];
        _nameLab.textColor = [UIColor darkTextColor];
        [self.contentView addSubview:_nameLab];
        
        _textField = [[HYTextField alloc]initWithFrame:CGRectZero];
        _textField.borderStyle = UITextBorderStyleNone;
        _textField.textColor = [UIColor darkTextColor];
        _textField.contentVerticalAlignment =  UIControlContentVerticalAlignmentCenter;
        [self.contentView addSubview:_textField];
        
        _textLab = [[UILabel alloc]initWithFrame:CGRectZero];
        _textLab.backgroundColor = [UIColor clearColor];
        _textLab.hidden = YES;
        _textLab.textColor = [UIColor darkTextColor];
        [self.contentView addSubview:_textLab];
        
        _setDefaultBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _setDefaultBtn.hidden = YES;
//        [_setDefaultBtn addTarget:self action:@selector(setDefaultBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_setDefaultBtn];

    }
    return self;
}

//- (void)setDefaultBtnAction:(UIButton *)btn
//{
//    if ([self.delegate respondsToSelector:@selector(setDefaultAction)])
//    {
//        [_setDefaultBtn setBackgroundImage:[UIImage imageNamed:@"iocn_address_seclect"] forState:UIControlStateNormal];
//        [self.delegate setDefaultAction];
//    }
//}

@end
