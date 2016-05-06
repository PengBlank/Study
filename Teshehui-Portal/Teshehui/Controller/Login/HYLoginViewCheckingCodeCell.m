//
//  HYLoginViewCheckingCodeCell.m
//  Teshehui
//
//  Created by HYZB on 16/2/18.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYLoginViewCheckingCodeCell.h"

@interface HYLoginViewCheckingCodeCell ()
{
    CGRect originalFrame;
}

@end

@implementation HYLoginViewCheckingCodeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        UITextField *textField = [[UITextField alloc] init];
        textField.font = [UIFont systemFontOfSize:15.0];
        self.codeTextField = textField;
        [self.contentView addSubview:_codeTextField];
        
        //忘记密码
//        UIButton *forget = [UIButton buttonWithType:UIButtonTypeCustom];
//        [forget setTitle:@"忘记密码?" forState:UIControlStateNormal];
//        [forget setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//        forget.titleLabel.font = [UIFont systemFontOfSize:11.0];
//        [self.contentView addSubview:forget];
//        self.forgetBtn = forget;
    }
    return self;
}

+ (HYLoginViewCheckingCodeCell *)cellWithTableView:(UITableView *)tableView
{
    static NSString *checkingCodeCellID = @"checkingCodeCellID";
    
    HYLoginViewCheckingCodeCell *checkingCodeCell = [tableView dequeueReusableCellWithIdentifier:checkingCodeCellID];
    
    if (!checkingCodeCell)
    {
        checkingCodeCell = [[HYLoginViewCheckingCodeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:checkingCodeCellID];
    }
    
    checkingCodeCell.codeTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    checkingCodeCell.codeTextField.tag = 201;
    return checkingCodeCell;
}

- (void)setDataWithType:(LoginType)type checkingCode:(NSString *)checkingCode password:(NSString *)password
{
    originalFrame = self.lineView.frame;
    
    switch (type)
    {
        case kLoginTypeQuicklyLogin:
            
            self.lineView.frame = originalFrame;
            self.codeTextField.frame = CGRectMake(TFScalePoint(20), CGRectGetMinY(self.lineView.frame)-30, TFScalePoint(280), 20);
            self.codeTextField.placeholder = @"请输入短信验证码";
//            self.forgetBtn.hidden = YES;
            self.codeTextField.keyboardType = UIKeyboardTypeNumberPad;
            self.codeTextField.secureTextEntry = NO;
            self.codeTextField.text = checkingCode;
            break;
        case kLoginTypeKeyLogin:
            
//            self.lineView.frame = CGRectMake(TFScalePoint(20), originalFrame.origin.y-20, TFScalePoint(280), 0.5);
//            self.codeTextField.frame = CGRectMake(TFScalePoint(20), CGRectGetMinY(self.lineView.frame)-30, TFScalePoint(280), 20);
//            self.forgetBtn.frame = CGRectMake(CGRectGetMaxX(self.codeTextField.frame)-TFScalePoint(60), self.lineView.frame.origin.y+5, 75, 20);
            self.codeTextField.placeholder = @"请输入密码";
//            self.forgetBtn.hidden = NO;
            self.codeTextField.keyboardType = UIKeyboardTypeDefault;
            self.codeTextField.returnKeyType = UIReturnKeyDone;
            self.codeTextField.secureTextEntry = YES;
            self.codeTextField.text = password;
            break;
        default:
            break;
    }
}

@end
