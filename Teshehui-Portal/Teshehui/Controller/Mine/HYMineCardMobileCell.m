//
//  HYMineCardMobileCell.m
//  Teshehui
//
//  Created by HYZB on 14-10-15.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYMineCardMobileCell.h"

@implementation HYMineCardMobileCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(70, 0, 1, 44)];
        lineView.image = [UIImage imageNamed:@"tel_input_line"];
        [self.contentView addSubview:lineView];
        
        UIImage *indicator = [UIImage imageNamed:@"cell_indicator"];
        UIImageView *indicatorView = [[UIImageView alloc] initWithFrame:CGRectMake(57, 15, 7, 12)];
        indicatorView.image = indicator;
        [self.contentView addSubview:indicatorView];
        
        _setTypeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_setTypeBtn setTitleColor:[UIColor darkGrayColor]
                          forState:UIControlStateNormal];
        [_setTypeBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_setTypeBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 30)];
        [_setTypeBtn setFrame:CGRectMake(0, 0, 80, 44)];
        [_setTypeBtn addTarget:self
                        action:@selector(setNumberType:)
              forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_setTypeBtn];
        
        _textField = [[HYTextField alloc]initWithFrame:CGRectMake(80, 12, 200, 20)];
        _textField.font = [UIFont systemFontOfSize:14];
        _textField.borderStyle = UITextBorderStyleNone;
        _textField.textColor = [UIColor darkTextColor];
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textField.keyboardType = UIKeyboardTypePhonePad;
        _textField.returnKeyType = UIReturnKeyDone;
        _textField.autoSpace = YES;
        _textField.contentVerticalAlignment =  UIControlContentVerticalAlignmentCenter;
        [self.contentView addSubview:_textField];
    }
    
    return self;
}

#pragma mark setter/getter
- (void)setTelNumber:(HYTelNumberInfo *)telNumber
{
    if (telNumber != _telNumber)
    {
        _telNumber = telNumber;
    }
    
    [_setTypeBtn setTitle:telNumber.desc forState:UIControlStateNormal];
    self.textField.text = telNumber.number;
}

- (void)setFieldDelegate:(id<UITextFieldDelegate>)fieldDelegate
{
    _textField.delegate = fieldDelegate;
}

#pragma mark - private methods
- (void)setNumberType:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(didSelectSetTelNumberType:)])
    {
        [self.delegate didSelectSetTelNumberType:self.telNumber];
    }
}

@end
