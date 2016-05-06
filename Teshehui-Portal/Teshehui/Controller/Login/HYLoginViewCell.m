//
//  HYLoginViewCell.m
//  Teshehui
//
//  Created by HYZB on 16/2/18.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYLoginViewCell.h"

@implementation HYLoginViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {

        UITextField *textField = [[UITextField alloc] init];
        textField.font = [UIFont systemFontOfSize:15.0];
        self.textField = textField;
        [self.contentView addSubview:self.textField];
        
        // 获取验证码按钮
        self.codeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_codeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _codeBtn.backgroundColor = [UIColor colorWithRed:223/255.0f green:58/255.0f blue:60/255.0f alpha:1.0f];
        _codeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_codeBtn];
    }
    return self;
}

+ (HYLoginViewCell *)cellWithTableView:(UITableView *)tableView
{
    
    static NSString *phoneCellID = @"phoneCellID";
    HYLoginViewCell *cell = [tableView dequeueReusableCellWithIdentifier:phoneCellID];
    
    if (!cell)
    {
        cell = [[HYLoginViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:phoneCellID];
        [cell.codeBtn setTitle:@"获取验证码"
                      forState:UIControlStateNormal];
    }
    
    cell.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    cell.textField.keyboardType = UIKeyboardTypeNumberPad;
    cell.textField.tag = 200;
    return cell;
}

- (void)setDataWithType:(LoginType)type phoneNum:(NSString *)phoneNum cardNum:(NSString *)cardNum
{
    switch (type)
    {
        case kLoginTypeQuicklyLogin:
            
            self.textField.frame = CGRectMake(TFScalePoint(20), CGRectGetMinY(self.lineView.frame)-30, TFScalePoint(280)-90, 20);
            _codeBtn.frame = CGRectMake(CGRectGetMaxX(self.textField.frame), CGRectGetMinY(self.lineView.frame)-40, 90, 35);
            [self.codeBtn addTarget:self action:@selector(goValidateAction:) forControlEvents:UIControlEventTouchUpInside];
            self.textField.placeholder = @"请输入您的手机号码";
            self.codeBtn.hidden = NO;
            self.textField.text = phoneNum;
            break;
        case kLoginTypeKeyLogin:
            
            self.textField.frame = CGRectMake(TFScalePoint(20), CGRectGetMinY(self.lineView.frame)-30, TFScalePoint(280), 20);
            self.textField.placeholder = @"请输入手机号或卡号";
            self.codeBtn.hidden = YES;
            self.textField.text = cardNum;
            break;
        default:
            break;
    }
}

- (void)startTiming
{
    _count = 60;
    [_timer invalidate];
    _timer = [NSTimer timerWithTimeInterval:1.0f target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    _codeBtn.enabled = NO;
    [_codeBtn setTitle:[NSString stringWithFormat:@"%lus重新获取", (unsigned long)_count] forState:UIControlStateDisabled];
    _codeBtn.backgroundColor = [UIColor colorWithWhite:0.85f alpha:1.0f];
}

- (void)timerAction:(NSTimer *)timer
{
    _count --;
    [_codeBtn setTitle:[NSString stringWithFormat:@"%lus重新获取", (unsigned long)_count] forState:UIControlStateDisabled];
    
    if (_count == 0)
    {
        _codeBtn.enabled = YES;
        [_timer invalidate];
        _codeBtn.backgroundColor = [UIColor colorWithRed:223/255.0f green:58/255.0f blue:60/255.0f alpha:1.0f];
        [_codeBtn setTitle:@"重新获取" forState:UIControlStateNormal];
    }
}

- (void)goValidateAction:(UIButton *)btn
{

    if ([self.delegate respondsToSelector:@selector(validateAction)])
    {
        [self.delegate validateAction];
    }
}

@end
