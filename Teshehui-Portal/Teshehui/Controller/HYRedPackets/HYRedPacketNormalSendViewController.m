//
//  HYRedPacketNormalSendViewController.m
//  Teshehui
//
//  Created by HYZB on 15/3/10.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYRedPacketNormalSendViewController.h"
#import "UIImage+Addition.h"
#import "HYRPNormalCompleteViewController.h"
#import "HYRPPreparingViewController.h"
#import "UIView+ScreenTransform.h"
#import "HYKeyboardHandler.h"
#import "SAMTextView.h"
#import "HYSendRedpacketReq.h"
#import "HYUserInfo.h"
#import "METoast.h"
#import "NSString+Addition.h"
#import "HYRPCompleteAnimationView.h"
#import "HYGetUserInfoRequest.h"
#import "HYGetPersonResponse.h"

@interface HYRedPacketNormalSendViewController ()
<
UIScrollViewDelegate,
UITextFieldDelegate,
UITextViewDelegate,
HYKeyboardHandlerDelegate
>

@property (nonatomic, weak) IBOutlet UIScrollView *contentView;
@property (nonatomic, weak) IBOutlet UIView *inputView;
@property (nonatomic, weak) IBOutlet UITextField *totalField;
@property (nonatomic, weak) IBOutlet SAMTextView *grayView;
@property (nonatomic, weak) IBOutlet UIButton *commitBtn;
@property (nonatomic, weak) IBOutlet UILabel *nameLab;
@property (nonatomic, weak) IBOutlet UILabel *balanceLab;

@property (nonatomic, strong) HYSendRedpacketReq *sendRequest;

@property (nonatomic, strong) HYGetUserInfoRequest *infoRequest;

@end

@implementation HYRedPacketNormalSendViewController

- (void)dealloc
{
    [_sendRequest cancel];
    _sendRequest = nil;
    [_infoRequest cancel];
}

- (void)loadView
{
    NSArray *views = [[UINib nibWithNibName:self.nibName bundle:self.nibBundle] instantiateWithOwner:self options:nil];
    self.view = [views objectAtIndex:0];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"普通红包";
    
    _contentView.backgroundColor = [UIColor colorWithRed:255.0/255.0
                                                   green:253.0/255.0
                                                    blue:244.0/255.0
                                                   alpha:1.0];
    CGRect frame = [[UIScreen mainScreen] bounds];
    frame.size.height -= 64.0;
    _contentView.contentSize = CGSizeMake(frame.size.width, frame.size.height+1);
    
    self.totalField.layer.masksToBounds = YES;
    self.totalField.layer.cornerRadius = 4.0;
    self.grayView.layer.masksToBounds = YES;
    self.grayView.layer.cornerRadius = 4.0;
    self.grayView.placeholder = @"吉祥如意！恭喜发财！";
    self.inputView.layer.masksToBounds = YES;
    self.inputView.layer.cornerRadius = 2.0;
    UIView *empty = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];
    self.totalField.rightView = empty;
    self.totalField.rightViewMode = UITextFieldViewModeAlways;
    self.totalField.leftView = empty;
    self.totalField.leftViewMode = UITextFieldViewModeAlways;
    
    UIImage *btn = [[UIImage imageNamed:@"redpacket_index_btn.png"] utilResizableImageWithCapInsets:UIEdgeInsetsMake(0, 20, 0, 20)];
    UIImage *btn_d = [[UIImage imageNamed:@"redpacket_index_btn_d.png"] utilResizableImageWithCapInsets:UIEdgeInsetsMake(0, 20, 0, 20)];
    [self.commitBtn setBackgroundImage:btn forState:UIControlStateNormal];
    [self.commitBtn setBackgroundImage:btn_d forState:UIControlStateHighlighted];
    self.commitBtn.enabled = NO;
    
    [self.contentView transformSubviewFrame:NO];
    
    //准备发送给...
    NSString *displayName = (self.name.length > 0) ? self.name : self.mob_phone;
    NSString *nameStr = [NSString stringWithFormat:@"准备发送给%@", displayName];
    NSMutableAttributedString *nameAttr = [[NSMutableAttributedString alloc] initWithString:nameStr];
    [nameAttr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(5, displayName.length)];
    self.nameLab.attributedText = nameAttr;
    
    /// 4.4.0
    self.nameLab.text = nil;
    
    //帐户可用现金券
    NSInteger balance = [[[HYUserInfo getUserInfo] points] integerValue];
    self.balanceLab.text = [NSString stringWithFormat:@"账户可用现金券:%ld", balance];
    
    if (!_mob_phone)
    {
        //不可用！
    }
    
}

- (void)backToRootViewController:(id)sender
{
    if ([self checkIsFilled])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否放弃正在编辑的红包?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }
    else
    {
        [super backToRootViewController:sender];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (BOOL)checkIsFilled
{
    NSString *total = self.totalField.text;
    if (total.length > 0)
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
- (IBAction)completeAction:(id)sender
{
    [self.view endEditing:YES];
    
    NSString *error = nil;
    NSString *money = self.totalField.text;
    
    if (money.integerValue <= 0)
    {
        error = @"现金券数不能为零！";
    }
    
    NSString *grating = _grayView.text;
    if ([grating calculateUnicharCount] > 50)
    {
        error = @"祝福语长度过长，请重新输入！";
    }
    if (grating.length <= 0)
    {
        grating = @"吉祥如意！恭喜发财！";
    }
    
    if (error)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:error delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    _sendRequest = [[HYSendRedpacketReq alloc] init];
    _sendRequest.total_amount = money.intValue;
    _sendRequest.packet_type = 1;
    _sendRequest.greetings = grating;
    if (self.mob_phone)
    {
        _sendRequest.phone_num = self.mob_phone;
        _sendRequest.type = 1;
    }
    else
    {
        _sendRequest.phone_num = self.name;
        _sendRequest.type = 3;
    }

    
    [HYRPCompleteAnimationView show];
    __weak typeof(self) b_self = self;
    NSDate *now = [NSDate date];
    [_sendRequest sendReuqest:^(id result, NSError *error)
    {
        NSDate *then = [NSDate date];
        NSTimeInterval piece = [then timeIntervalSinceDate:now];
        if (piece >= 2)
        {
            [b_self updateWithResponse:result error:error];
        }
        else
        {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((2-piece) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
                           {
                               [b_self updateWithResponse:result error:error];
                           });
        }
    }];
}

- (void)updateWithResponse:(id)result error:(NSError *)error
{
    [HYRPCompleteAnimationView dismiss];
    if (error)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:error.domain delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return ;
    }
    else
    {
        //HYSendRedpacketRep *respone = (HYSendRedpacketRep *)result;
        HYRPNormalCompleteViewController *vc = [[HYRPNormalCompleteViewController alloc] initWithNibName:@"HYRPNormalCompleteViewController" bundle:nil];
        vc.name = self.name ? self.name : self.mob_phone;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

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
    
    //判断是否可以提交
    NSInteger balance = [[[HYUserInfo getUserInfo] points] integerValue];
    NSInteger input = result.integerValue;
    NSInteger old = [textField.text integerValue];
    
    if (input > 0 && input <= balance)
    {
        self.commitBtn.enabled = YES;
    }
    else
    {
        self.commitBtn.enabled = NO;
        if (input > balance)
        {
            if (old <= balance)
            {
                [METoast toastWithMessage:@"您的现金券账户余额不足，请重新输入！"];
            }
        }
    }
    
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    [self.contentView setContentOffset:CGPointMake(0, textView.frame.origin.y)];
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



//- (void)keyboardChangeFrame:(CGRect)kFrame
//{
//    
//}

#pragma mark - scroll

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
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
