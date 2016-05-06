//
//  HYCIConfirmCodeViewController.m
//  Teshehui
//
//  Created by Kris on 15/7/10.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYCIConfirmCodeViewController.h"
#import "HYGetCheckView.h"

#import "HYCheckInsuranceViewController.h"
#import "HYCISendCheckRequest.h"
#import "HYCISendCheckResponse.h"
#import "HYCICheckCodeRequest.h"
#import "HYCICheckCodeResponse.h"
#import "HYCIConfirmPaymentViewController.h"

#import "METoast.h"

@interface HYCIConfirmCodeViewController ()
{
    NSTimer* _timer;
    NSInteger _countdown;
    
    HYCISendCheckRequest* _sendCheckRequest;
    HYCICheckCodeRequest *_checkCodeRequest;
}


@property(nonatomic, strong) HYGetCheckView* getCheckView;
@property(nonatomic, strong) UIButton* sendCheck;
@end

@implementation HYCIConfirmCodeViewController

-(void)dealloc
{
    [HYLoadHubView dismiss];
    
    if ([_timer isValid])
    {
        [_timer invalidate];
        _timer = nil;
    }
    
    [_sendCheckRequest cancel];
    _sendCheckRequest = nil;
}

- (void)loadView
{
    CGRect frame = [[UIScreen mainScreen] bounds];
    frame.size.height -= 64.0;
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor whiteColor];
    self.view = view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"验证码";
    _countdown = 120;
    
    _getCheckView = [[HYGetCheckView alloc]initWithFrame:CGRectMake(0, 10, self.view.frame.size.width, 50)];
    _getCheckView.nameLab.frame = CGRectMake(12, 10, 80,30);
    _getCheckView.nameLab.text = @"验证码";
    _getCheckView.nameLab.font = [UIFont systemFontOfSize:16.0f];
    _getCheckView.textField.frame = CGRectMake(CGRectGetMaxX(_getCheckView.nameLab.frame), 10, TFScalePoint(110), 30);
    _getCheckView.textField.font = [UIFont systemFontOfSize:16.0f];
    _getCheckView.textField.keyboardType = UIKeyboardTypePhonePad;
    
    //下划线
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_getCheckView.nameLab.frame)-10, CGRectGetMaxY(_getCheckView.nameLab.frame), 110, 1)];
    line.backgroundColor = [UIColor grayColor];
    [_getCheckView addSubview:line];
    
    UIImage *submit = [UIImage imageNamed:@"ci_btn_on"];
    submit = [submit stretchableImageWithLeftCapWidth:2 topCapHeight:2];
    
    UIButton *sendCheck = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendCheck setBackgroundImage:submit forState:UIControlStateNormal];
    sendCheck.frame = CGRectMake(self.view.frame.size.width-110, 14, 100, 30);
    [sendCheck.titleLabel setFont:[UIFont boldSystemFontOfSize:16.0f]];
    [sendCheck setTitle:@"获取验证码" forState:UIControlStateNormal];
    [sendCheck addTarget:self
                                action:@selector(getAuthCode)
                      forControlEvents:UIControlEventTouchUpInside];
    self.sendCheck = sendCheck;
    [_getCheckView addSubview:sendCheck];
    
    [self.view addSubview:_getCheckView];
    
    UIButton *nextBtn = [[UIButton alloc] initWithFrame:
                         CGRectMake(CGRectGetMidX(self.view.bounds)-85, 100, 170, 35)];
    
    [nextBtn setBackgroundImage:submit forState:UIControlStateNormal];
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextBtn addTarget:self
                action:@selector(nextAction:)
      forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextBtn];
}

- (void)nextAction:(UIButton *)btn
{
    
    NSString *errMessage = nil;
    if ([_getCheckView.textField.text length] <= 0)
    {
        errMessage = @"请输入验证码";
    }
    
    
    if (errMessage)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:errMessage
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    [HYLoadHubView show];
    _checkCodeRequest = [[HYCICheckCodeRequest alloc] init];
    _checkCodeRequest.checkcode = _getCheckView.textField.text;
    _checkCodeRequest.sessionid = self.sessionid;
    __weak typeof(self) b_self = self;
    [_checkCodeRequest sendReuqest:^(HYCICheckCodeResponse* response, NSError *error)
    {
        [HYLoadHubView dismiss];
        if (response.status == 200)
        {
            HYCIConfirmPaymentViewController *confirmPayment = [[HYCIConfirmPaymentViewController alloc] init];
            confirmPayment.sessionid = b_self.sessionid;
            confirmPayment.order = b_self.order;
            [b_self.navigationController pushViewController:confirmPayment animated:YES];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:error.domain delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
    }];
    
    //    HYCIFillCarInfoViewController *vc = [[HYCIFillCarInfoViewController alloc] init];
    //    vc.ownerInfo = self.getCarFillInfoParam;
    //    [self.navigationController pushViewController:vc animated:YES];
}

-(void)getAuthCode
{
    _sendCheckRequest = [[HYCISendCheckRequest alloc] init];
    _sendCheckRequest.sessionId = self.sessionid;
    
    [HYLoadHubView show];
    __weak typeof (self) b_self = self;
    [ _sendCheckRequest sendReuqest:^(id result, NSError *error) {
        [HYLoadHubView dismiss];
        if ([result isKindOfClass:[HYCISendCheckResponse class]])
        {
            HYCISendCheckResponse *response = (HYCISendCheckResponse *)result;
            if (response.status == 200)
            {
                [b_self timerStart];
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
        }
        else
        {
            [METoast toastWithMessage:@"网络出现问题,请稍后再试"];
        }
    }];
}

#pragma mark private methods
- (void)timerStart
{
    if ([_timer isValid])
    {
        [_timer invalidate];
        _timer = nil;
    }
    
    _timer =  [NSTimer scheduledTimerWithTimeInterval:1.0
                                               target:self
                                             selector:@selector(updateTime)
                                             userInfo:nil
                                              repeats:YES];
    self.getCheckView.sendCheck.enabled = NO;
}

-(void)updateTime
{
    _countdown -- ;
    self.sendCheck.titleLabel.text = [NSString stringWithFormat:@"%lds后重发",_countdown];
    
    if (_countdown<=0)
    {
        self.sendCheck.enabled = YES;
        _countdown = 120;
        [self.sendCheck setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_timer invalidate];
    }
}


@end
