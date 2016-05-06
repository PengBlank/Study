//
//  HYAbroadBuyAlertView.m
//  Teshehui
//
//  Created by HYZB on 16/4/19.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYAbroadBuyAlertView.h"
#import "NSString+Addition.h"
#import "METoast.h"


@interface HYAbroadBuyAlertView ()
<UITextFieldDelegate>

@property (nonatomic, strong) UIView *contentV;
@property (nonatomic, strong) UIImageView *titleImgV;
@property (nonatomic, strong) UIImageView *leftIcon;
@property (nonatomic, strong) UILabel *declardLab;
@property (nonatomic, strong) UILabel *consigneeLab;

@property (nonatomic, strong) UILabel *consigneeDeclard;
@property (nonatomic, strong) UILabel *identificationLab;



@end

@implementation HYAbroadBuyAlertView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self setupUI];
    }
    
    return self;
}

- (void)setupUI
{
    self.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.7];
    
    UIView *contentV = [[UIView alloc] init];
    contentV.layer.cornerRadius = 10;
    _contentV = contentV;
    contentV.backgroundColor = [UIColor whiteColor];
    [self addSubview:contentV];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancelBtn = cancelBtn;
    [cancelBtn addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setBackgroundImage:[UIImage imageNamed:@"icon_cancel_abroadbuy"]
                         forState:UIControlStateNormal];
    [contentV addSubview:cancelBtn];
    
    UIImageView *titleImgV = [[UIImageView alloc] init];
    _titleImgV = titleImgV;
    titleImgV.image = [UIImage imageNamed:@"pic_title_abroadbuy"];
    [contentV addSubview:titleImgV];
    
    UIImageView *leftIcon = [[UIImageView alloc] init];
    _leftIcon = leftIcon;
    leftIcon.image = [UIImage imageNamed:@"icon_bulb_abroadbuy"];
    [contentV addSubview:leftIcon];
    
    NSString *str = @"您购买的商品含有海淘商品，据海关要求，需要认证收货人身份信息，认证成功后可以正常清关哦";
    UILabel *declardLab = [self setupLabelWithText:str font:14 textColor:[UIColor redColor]];
    _declardLab = declardLab;
    
    UILabel *consigneeLab = [self setupLabelWithText:@"收货人:" font:14 textColor:nil];
    _consigneeLab = consigneeLab;
    
    UITextField *consigneeTF = [self setupTextFieldWithPlaceholder:@"请填写收货人"];
    _consigneeTF = consigneeTF;
    NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
    _consigneeTF.text = [df objectForKey:kAbroadBuyConsignee];
    
    UILabel *consigneeDeclard = [self setupLabelWithText:@"收货人姓名与身份证姓名一致才行哦！"
                                                    font:13 textColor:[UIColor grayColor]];
    _consigneeDeclard = consigneeDeclard;
    
    UILabel *identificationLab = [self setupLabelWithText:@"身份证:" font:14 textColor:nil];
    _identificationLab = identificationLab;
    
    UITextField *identificationTF = [self setupTextFieldWithPlaceholder:@"填写后，我们将加密处理"];
    _identificationTF = identificationTF;
    _identificationTF.text = [df objectForKey:kAbroadBuyIdentification];
    
    UIButton *commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [commitBtn addTarget:self action:@selector(commitAction:) forControlEvents:UIControlEventTouchUpInside];
    _commitBtn = commitBtn;
    [commitBtn setTitle:@"提交" forState:UIControlStateNormal];
    // 53 147 255
    [commitBtn setBackgroundImage:[UIImage imageNamed:@"bgpic_bluebutton_abroadbuy"] forState:UIControlStateNormal];
    [commitBtn setBackgroundImage:[UIImage imageNamed:@"bgpic_graybutton_abroadbuy"] forState:UIControlStateDisabled];
    if (_consigneeTF.text.length > 0 && _identificationTF.text.length > 0)
    {
        commitBtn.enabled = YES;
    }
    else
    {
        commitBtn.enabled = NO;
    }
    [contentV addSubview:commitBtn];
}

- (void)layoutSubviews
{
    CGFloat contentVX = TFScalePoint(30);
    CGFloat contentVY = 120;
    CGFloat contentVWidth = TFScalePoint(260);
    CGFloat contentVHeight = 330;
    _contentV.frame = CGRectMake(contentVX, contentVY, contentVWidth, contentVHeight);
    
    _titleImgV.frame = CGRectMake(TFScalePoint(30), -30, TFScalePoint(200), 45);
    
    _cancelBtn.frame = CGRectMake(CGRectGetMaxX(_titleImgV.frame)+10, 10, 12, 12);
    
    CGFloat x = 10;
    _leftIcon.frame = CGRectMake(x, CGRectGetMaxY(_titleImgV.frame)+30, 15, 20);
    
    _declardLab.frame = CGRectMake(CGRectGetMaxX(_leftIcon.frame)+15,
                                   CGRectGetMinY(_leftIcon.frame)-5, contentVWidth-55, 60);
    
    _consigneeLab.frame = CGRectMake(x, CGRectGetMaxY(_declardLab.frame)+30, 50, 20);
    
    _consigneeTF.frame = CGRectMake(CGRectGetMaxX(_consigneeLab.frame),
                                    CGRectGetMaxY(_declardLab.frame)+25, TFScalePoint(180), 30);
    
    _consigneeDeclard.frame = CGRectMake(CGRectGetMinX(_consigneeTF.frame),
                                         CGRectGetMaxY(_consigneeTF.frame)+5, TFScalePoint(190), 20);
    
    _identificationLab.frame = CGRectMake(x, CGRectGetMaxY(_consigneeDeclard.frame)+25, 50, 20);
    
    _identificationTF.frame = CGRectMake(CGRectGetMinX(_consigneeTF.frame),
                                         CGRectGetMaxY(_consigneeDeclard.frame)+20, TFScalePoint(180), 30);
    
    _commitBtn.frame = CGRectMake(x, CGRectGetMaxY(_identificationTF.frame)+30, TFScalePoint(240), 40);
}

- (UITextField *)setupTextFieldWithPlaceholder:(NSString *)placeholder
{
    UITextField *tf = [[UITextField alloc] init];
    tf.delegate = self;
    [tf addTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventEditingChanged];
    tf.layer.borderWidth = 1;
    tf.layer.borderColor = [UIColor colorWithWhite:0.9 alpha:1.0].CGColor;
    tf.font = [UIFont systemFontOfSize:14];
    tf.placeholder = placeholder;
    [_contentV addSubview:tf];
    
    UIView *spaceV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    tf.leftViewMode = UITextFieldViewModeAlways;
    tf.leftView = spaceV;
    return tf;
}

- (UILabel *)setupLabelWithText:(NSString *)text font:(CGFloat)font textColor:(UIColor *)color
{
    UILabel *label = [[UILabel alloc] init];
    label.textColor = color;
    label.text = text;
    label.font = [UIFont systemFontOfSize:font];
    label.numberOfLines = 0;
    [_contentV addSubview:label];
    return label;
}

- (void)show
{
    UIWindow *window =  [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
}

- (void)dismiss
{
    [self removeFromSuperview];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self endEditing:YES];
}

- (void)cancelAction:(UIButton *)btn
{
    [self dismiss];
}

- (void)commitAction:(UIButton *)btn;
{
    if ([NSString validateIDCardNumber:_identificationTF.text])
    {
        NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
        [df setObject:_consigneeTF.text forKey:kAbroadBuyConsignee];
        [df setObject:_identificationTF.text forKey:kAbroadBuyIdentification];
        [df synchronize];
        
        if ([self.delegate respondsToSelector:@selector(commitBtnActionWithIdentification:realName:)])
        {
            [self.delegate commitBtnActionWithIdentification:_identificationTF.text
                                                    realName:_consigneeTF.text];
        }
    }
    else
    {
        [METoast toastWithMessage:@"身份证信息不正确"];
    }
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    // 119 159 216
    textField.layer.borderColor = [UIColor colorWithRed:119/255.0f green:159/255.0f
                                                   blue:216/255.0f alpha:1.0f].CGColor;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    textField.layer.borderColor = [UIColor colorWithWhite:0.9 alpha:1.0].CGColor;
}

- (void)valueChange:(UITextField *)tf
{
    if (_identificationTF.text.length > 0 && _consigneeTF.text.length > 0)
    {
        _commitBtn.enabled = YES;
    }
    else
    {
        _commitBtn.enabled = NO;
    }
}

@end
