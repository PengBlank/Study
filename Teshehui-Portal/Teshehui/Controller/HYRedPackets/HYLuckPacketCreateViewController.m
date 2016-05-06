//
//  HYLuckPacketCreateViewController.m
//  Teshehui
//
//  Created by apple on 15/3/9.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYLuckPacketCreateViewController.h"
#import "UIImage+Addition.h"
#import "HYSendLuckPacketViewController.h"
#import "UIView+ScreenTransform.h"
#import "SAMTextView.h"
#import "HYSendRedpacketReq.h"
#import "METoast.h"
#import "HYUserInfo.h"
#import "NSString+Addition.h"
#import "HYRPCompleteAnimationView.h"
#import "HYGetUserInfoRequest.h"
#import "HYGetPersonResponse.h"
#import "HYNormalLeakViewController.h"
#import "HYShareRedpacketReq.h"
#import "UMSocial.h"

@interface HYLuckPacketCreateViewController ()
<
UIScrollViewDelegate,
UITextFieldDelegate,
UITextViewDelegate,
UMSocialUIDelegate
>
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UIView *inputView;
@property (nonatomic, weak) IBOutlet UITextField *numField;
@property (nonatomic, weak) IBOutlet UITextField *totalField;
@property (nonatomic, weak) IBOutlet SAMTextView *grayView;
@property (nonatomic, weak) IBOutlet UIButton *commitBtn;
@property (nonatomic, weak) IBOutlet UILabel *balanceLab;
@property (nonatomic, weak) IBOutlet UILabel *descLab;

@property (nonatomic, strong) HYSendRedpacketReq *sendRequest;
@property (nonatomic, strong) HYRedpacketInfo *sendedPacketInfo;

@property (nonatomic, strong) HYGetUserInfoRequest *infoRequest;

@property (nonatomic, strong) HYShareRedpacketReq *shareReq;

@property (nonatomic, assign) BOOL isShare;

@end

@implementation HYLuckPacketCreateViewController

- (void)dealloc
{
    [_sendRequest cancel];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.view endEditing:YES];
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"PageHYLuckPacketCreateViewController"];
    
    METoastAttribute *attr = [METoast toastAttribute];
    attr.location = METoastLocationBottom;
    [METoast setToastAttribute:attr];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect frame = [[UIScreen mainScreen] bounds];
    frame.size.height -= 64.0;
    _scrollView.contentSize = CGSizeMake(frame.size.width, frame.size.height+1);
    
    self.numField.layer.masksToBounds = YES;
    self.numField.layer.cornerRadius = 4.0;
    self.totalField.layer.masksToBounds = YES;
    self.totalField.layer.cornerRadius = 4.0;
    self.grayView.layer.masksToBounds = YES;
    self.grayView.layer.cornerRadius = 4.0;
    self.grayView.placeholder = @"恭喜发财！万事如意！";
    self.inputView.layer.masksToBounds = YES;
    self.inputView.layer.cornerRadius = 2.0;
    UIView *empty = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];
    self.totalField.rightView = empty;
    self.totalField.rightViewMode = UITextFieldViewModeAlways;
    self.totalField.leftView = empty;
    self.totalField.leftViewMode = UITextFieldViewModeAlways;
    empty = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];
    self.numField.rightView = empty;
    self.numField.rightViewMode = UITextFieldViewModeAlways;
    self.numField.leftView = empty;
    self.numField.leftViewMode = UITextFieldViewModeAlways;
    
    UIImage *btn = [[UIImage imageNamed:@"redpacket_index_btn.png"] utilResizableImageWithCapInsets:UIEdgeInsetsMake(0, 20, 0, 20)];
    UIImage *btn_d = [[UIImage imageNamed:@"redpacket_index_btn_d.png"] utilResizableImageWithCapInsets:UIEdgeInsetsMake(0, 20, 0, 20)];
    [self.commitBtn setBackgroundImage:btn forState:UIControlStateNormal];
    [self.commitBtn setBackgroundImage:btn_d forState:UIControlStateHighlighted];
    
    [self.scrollView transformSubviewFrame:NO];
    
    //帐户可用现金券
    NSInteger balance = [[[HYUserInfo getUserInfo] points] integerValue];
    self.balanceLab.text = [NSString stringWithFormat:@"账户可用现金券:%ld", balance];
    
    NSString *desc = self.randomLucky ? @"每人限领一个，现金券数随机" : @"每人限领一个，现金券数相同";
    self.descLab.text = desc;
    
    self.commitBtn.enabled = NO;
    
    METoastAttribute *attr = [METoast toastAttribute];
    attr.location = METoastLocationMiddle;
    [METoast setToastAttribute:attr];
}

- (void)backToRootViewController:(id)sender
{
    [self.view endEditing:YES];
    if ([self checkIsFilled])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"是否放弃正在编辑的红包?"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确定", nil];
        [alert show];
    }
    else
    {
        [super backToRootViewController:sender];
    }
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        [self.view endEditing:YES];
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        [self.view endEditing:YES];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (BOOL)checkIsFilled
{
    NSString *total = self.totalField.text;
    NSString *num = self.numField.text;
    if (total.length > 0)
    {
        return YES;
    }
    if (num.length > 0)
    {
        return YES;
    }
    return NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateInfo
{
    HYUserInfo *userinfo = [HYUserInfo getUserInfo];
    self.infoRequest = [[HYGetUserInfoRequest alloc] init];
    _infoRequest.userId = userinfo.userId;
    [HYLoadHubView show];
    [_infoRequest sendReuqest:^(id result, NSError *error)
     {
         [HYLoadHubView dismiss];
         if (error)
         {
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                             message:@"获取用户信息失败"
                                                            delegate:nil
                                                   cancelButtonTitle:@"确定"
                                                   otherButtonTitles:nil];
             [alert show];
         }
         else
         {
             
             HYGetPersonResponse *response = (HYGetPersonResponse *)result;
             [response.userInfo updateUserInfo];
             
             NSInteger balance = [userinfo.points integerValue];
             self.balanceLab.text = [NSString stringWithFormat:@"账户可用现金券:%ld", balance];
         }
     }];
}

#pragma mark - actions
- (IBAction)createPacket:(id)sender
{
    if ([self.title isEqualToString:@"普通红包"])
    {
        [MobClick event:kNormalRedPacketPutIntoClick];
    }
    else if ([self.title isEqualToString:@"拼手气红包"])
    {
        [MobClick event:kPKLuckPutIntoRedPacketClick];
    }

    [self.view endEditing:YES];
    
    NSString *error = nil;
    NSString *money = self.totalField.text;
    NSString *quantity = self.numField.text;
    
    if (money.floatValue <= 0)
    {
        error = @"现金券数必须大于零";
    }
    
    if (quantity.integerValue == 0)
    {
        error = @"红包数必须大于0";
    }
    
    NSString *grating = _grayView.text;
    if ([grating calculateUnicharCount] > 50)
    {
        error = @"祝福语长度过长，请重新输入！";
    }
    if (grating.length <= 0)
    {
        grating = @"恭喜发财！万事如意！";
    }
    
    if (error)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:error delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    if (!_shareReq)
    {
        _shareReq = [[HYShareRedpacketReq alloc] init];
    }
    _shareReq.total_amount = money.integerValue;
    _shareReq.luck_qunatity = quantity.integerValue;
    _shareReq.packet_type = _randomLucky ? 2 : 1;
    _shareReq.greetings = grating;
    _shareReq.userId = [HYUserInfo getUserInfo].userId;
    
//    _sendRequest = [[HYSendRedpacketReq alloc] init];
//    _sendRequest.total_amount = money.intValue;
//    _sendRequest.packet_type = _randomLucky ? 3 : 1;
//    _sendRequest.luck_quantity = quantity.integerValue;
//    _sendRequest.greetings = grating;
//    _sendRequest.phone_num = [HYUserInfo getUserInfo].mobilePhone;
    [HYRPCompleteAnimationView show];
    __weak typeof(self) b_self = self;
    NSDate *now = [NSDate date];
    [_shareReq sendReuqest:^(id result, NSError *error)
     {
         if (error)
         {
             [b_self updateWithRespone:result error:error];
         }
         else
         {
             NSDate *then = [NSDate date];
             NSTimeInterval piece = [then timeIntervalSinceDate:now];
             if (piece >= 2)
             {
                 [b_self updateWithRespone:result error:error];
             }
             else
             {
                 dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((2-piece) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
                                {
                                    [b_self updateWithRespone:result error:error];
                                });
             }
         }
     }];
}

- (void)updateWithRespone:(id)result error:(NSError *)error
{
    [HYRPCompleteAnimationView dismiss];
    if (!error && [result isKindOfClass:[HYShareRedpacketResp class]])
    {
        if ([self.title isEqualToString:@"普通红包"])
        {
            [MobClick event:kNormalRedPacketPutIntoAndShareClick];
        }
        else if ([self.title isEqualToString:@"拼手气红包"])
        {
            [MobClick event:kPutIntoRedPacketToShareClick];
        }
        
        
        HYShareRedpacketResp *resp = (HYShareRedpacketResp *)result;
        HYSendLuckPacketViewController *send = [[HYSendLuckPacketViewController alloc] initWithNibName:@"HYSendLuckPacketViewController" bundle:nil];
        send.sendedPacketInfo = resp;
        send.type = self.title;
        [self.navigationController pushViewController:send animated:YES];
        
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:error.domain
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
    }
}



//-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
//{
//    
//}

#pragma mark - text

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *result = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"1234567890"];
    for (int i = 0; i < result.length; i++)
    {
        unichar ch = [result characterAtIndex:i];
        if (![set characterIsMember:ch])
        {
            return NO;
        }
    }
    
    if (result.length > 6)
    {
        return NO;
    }
    
    if (textField == self.totalField)
    {
        //判断是否可以提交
        NSInteger balance = [[[HYUserInfo getUserInfo] points] integerValue];
        NSInteger input = result.integerValue;
        NSInteger old = [textField.text integerValue];
        NSInteger num = [self.numField.text integerValue];
        if (input > 0 && input <= balance)
        {
            if (num > 0 && num <= 50)
            {
                self.commitBtn.enabled = YES;
            }
        }
        else
        {
            self.commitBtn.enabled = NO;
            if (input > balance)
            {
                if (old <= balance)
                {
                    [METoast toastWithMessage:@"您的现金券账户余额不足，请重新输入！"];
//                    HYNormalLeakViewController *vc = [[HYNormalLeakViewController alloc] init];
//                    [self.navigationController pushViewController:vc animated:YES];
                 }
            }
        }
    }
    else if (textField == self.numField)
    {
        NSInteger balance = [[[HYUserInfo getUserInfo] points] integerValue];
        NSInteger total = [self.totalField.text integerValue];
        NSInteger num = result.integerValue;
        NSInteger old = [textField.text integerValue];
        if (num <= 0)
        {
            self.commitBtn.enabled = NO;
        }
        else if (num > 50)
        {
            if (old <= 50)
            {
                [METoast toastWithMessage:@"您选择的红包个数不能超过50个！"];
            }
            self.commitBtn.enabled = NO;
        }
        else
        {
            if (total > 0 && total < balance)
            {
                self.commitBtn.enabled = YES;
            }
        }
    }
    
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSString *result = [textView.text stringByReplacingCharactersInRange:range withString:text];
    if ([result calculateUnicharCount] > 50 && ![text isEqualToString:@""])
    {
        return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self.scrollView setContentOffset:CGPointMake(0, textField.frame.origin.y)];
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    [self.scrollView setContentOffset:CGPointMake(0, textView.frame.origin.y)];
    return YES;
}

#pragma mark - scroll
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    [self.view endEditing:YES];
//}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.view endEditing:YES];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
