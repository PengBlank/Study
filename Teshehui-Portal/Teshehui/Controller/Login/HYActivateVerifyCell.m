//
//  HYActivateVerifyCell.m
//  Teshehui
//
//  Created by apple on 15/4/8.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYActivateVerifyCell.h"

@implementation HYActivateVerifyCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        CGFloat width = CGRectGetWidth(ScreenRect);
        self.textLabel.frame = CGRectMake(10, 0, 60, 44);
        self.textLabel.text = @"手机号";
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(width-10-83, 13, 83, 30)];
        [btn setBackgroundImage:[UIImage imageNamed:@"person_buttom_orange2_normal"]
                              forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"person_buttom_orange2_press"]
                              forState:UIControlStateHighlighted];
        [btn setTitleColor:[UIColor whiteColor]
                         forState:UIControlStateNormal];
        [btn setTitle:@"获取验证码" forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [self.contentView addSubview:btn];
        self.sendBtn = btn;
        
        UITextField *field = [[UITextField alloc] initWithFrame:CGRectMake(90, 0, width-90 - 93, 54)];
        field.placeholder = @"请输入手机号码";
        field.clearButtonMode = UITextFieldViewModeWhileEditing;
        field.keyboardType = UIKeyboardTypeNumberPad;
        [self.contentView addSubview:field];
        self.phoneField = field;
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
