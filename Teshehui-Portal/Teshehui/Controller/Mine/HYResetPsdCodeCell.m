//
//  HYResetPsdCodeCell.m
//  Teshehui
//
//  Created by Kris on 15/12/22.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYResetPsdCodeCell.h"
#import "HYForGetRequest.h"
#import "HYForGetResponse.h"
#import "HYNewPassWordRequest.h"
#import "HYNewPassWordResponse.h"
#import "METoast.h"

@interface HYResetPsdCodeCell ()
{
    HYForGetRequest* _forGetRequest;

}
@end

@implementation HYResetPsdCodeCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.textLabel.font = [UIFont systemFontOfSize:16.0];
        self.backgroundColor = [UIColor clearColor];
        self.backgroundView = nil;
        
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
        _textLab.numberOfLines = 2;
        _textLab.hidden = YES;
        _textLab.textColor = [UIColor darkTextColor];
        [self.contentView addSubview:_textLab];
        
        UIImage *normal = [UIImage imageNamed:@"btn_login_new"];
        self.codeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 160, 55)];
        [_codeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_codeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
        [_codeBtn setBackgroundImage:normal forState:UIControlStateNormal];
        [_codeBtn addTarget:self action:@selector(sendCheck:) forControlEvents:UIControlEventTouchDown];
        _codeBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
        [self.contentView addSubview:_codeBtn];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    _codeBtn.frame = CGRectMake(CGRectGetWidth(self.frame)-24-80,
                                10,
                                100,
                                CGRectGetHeight(self.frame)-18-4);
    
}

#pragma mark private methods
- (void)startTiming
{
    _count = 60;
    [_timer invalidate];
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
    _codeBtn.enabled = NO;
    [_codeBtn setTitle:[NSString stringWithFormat:@"%lu", (unsigned long)_count] forState:UIControlStateDisabled];
}

- (void)timerAction:(NSTimer *)timer
{
    _count --;
    [_codeBtn setTitle:[NSString stringWithFormat:@"%lu", (unsigned long)_count] forState:UIControlStateDisabled];
    
    if (_count == 0)
    {
        _codeBtn.enabled = YES;
        [_timer invalidate];
    }
}

-(void)sendCheck:(UIButton*)sender
{
    [self send];
}

-(void)send
{
    if (!_forGetRequest)
    {
        _forGetRequest = [[HYForGetRequest alloc] init];
    }
    [_forGetRequest cancel];
    
    _forGetRequest.phone_mob = _mobilePhone;
    
    [HYLoadHubView show];
    __weak typeof (self) b_self = self;
    [_forGetRequest sendReuqest:^(id result, NSError *error) {
        [HYLoadHubView dismiss];
        if ([result isKindOfClass:[HYForGetResponse class]])
        {
            HYForGetResponse *response = (HYForGetResponse *)result;

            if (response.status == 200)
            {
                [b_self startTiming];
                if ([b_self.delegate respondsToSelector:@selector(tellDelegateAuthStatus:)])
                {
                    [b_self.delegate tellDelegateAuthStatus:YES];
                }
            }
            else
            {
                UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                               message:response.rspDesc
                                                              delegate:nil
                                                     cancelButtonTitle:@"确定"
                                                     otherButtonTitles:nil];
                [alert show];
            }
        }else{
            [METoast toastWithMessage:@"网络出现问题,请稍后再试"];
        }
    }];
}

@end
