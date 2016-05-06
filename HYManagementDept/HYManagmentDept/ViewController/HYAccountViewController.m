//
//  HYAccountViewController.m
//  HYManagmentDept
//
//  Created by RayXiang on 14-5-12.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYAccountViewController.h"
#import "HYDataManager.h"
#import "HYUserInfoEditRequestParma.h"
#import "HYHYUserInfoEditResponse.h"
#import "HYAddCardSubmitBackgroundView.h"
#import "HYAppDelegate.h"
#import "UIAlertView+Utils.h"
#import "HYStrokeField.h"

@interface HYAccountViewController ()
<UIAlertViewDelegate>
{
    HYUserInfoEditRequestParma *_request;
}

@end

@implementation HYAccountViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor  whiteColor];
    self.title = @"我的帐户";
    
    UIButton *logout = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 30)];
    [logout setTitle:@"退出" forState:UIControlStateNormal];
    [logout setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    logout.titleLabel.font = [UIFont systemFontOfSize:UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 18.0 : 14.0];
    [logout addTarget:self action:@selector(logout:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:logout];
    self.navigationItem.rightBarButtonItem = item;
    
    //界面控制变量
    CGFloat offsetx, offsety;
    float middle = 14;
    float labelWidth = 87;
    float fieldWidth = 222;
    float height = 30;
    float row_space = 24;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        offsetx = 10;
        offsety = 30;
    }
    else
    {
        offsetx = 10;
        offsety = 20;
        middle = 10;
        labelWidth = 70;
        fieldWidth = 160;
        height = 30;
        row_space = 10;
    }
    
    UIView *wrapper = [[UIView alloc] initWithFrame:CGRectMake(200, 28, 320, 240)];
    wrapper.backgroundColor = [UIColor clearColor];
    wrapper.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [self.view addSubview:wrapper];
    
    
    //用户名
    CGRect frame = CGRectMake(0, 0, labelWidth, height);
    _nameLbl = [[UILabel alloc] initWithFrame:frame];
    [self configLabel:_nameLbl];
    _nameLbl.text = @"用户名";
    [wrapper addSubview:_nameLbl];
    
    frame.origin.x = CGRectGetMaxX(frame) + middle;
    frame.size.width = fieldWidth;
    _nameFld = [[HYStrokeField alloc] initWithFrame:frame];
    [self configField:_nameFld];
    //_nameFld.backgroundColor = [UIColor lightGrayColor];
    _nameFld.textColor = [UIColor lightGrayColor];
    [wrapper addSubview:_nameFld];
    
    //密码
    frame = CGRectMake(0, CGRectGetMaxY(frame) + row_space, labelWidth, height);
    _passLbl = [[UILabel alloc] initWithFrame:frame];
    [self configLabel:_passLbl];
    _passLbl.text = @"密码";
    [wrapper addSubview:_passLbl];
    
    frame.origin.x += frame.size.width + middle;
    frame.size.width = fieldWidth;
    _passFld = [[HYStrokeField alloc] initWithFrame:frame];
    [self configField:_passFld];
    _passFld.secureTextEntry = YES;
    _passFld.placeholder = @"密码(留空表示不修改)";
    [wrapper addSubview:_passFld];
    
    //邮箱
    frame = CGRectMake(0, CGRectGetMaxY(frame) + row_space, labelWidth, height);
    _mailLbl = [[UILabel alloc] initWithFrame:frame];
    [self configLabel:_mailLbl];
    _mailLbl.text = @"电子邮箱";
    _mailFld.placeholder = @"电子邮箱";
    [wrapper addSubview:_mailLbl];
    
    frame.origin.x += frame.size.width + middle;
    frame.size.width = fieldWidth;
    _mailFld = [[HYStrokeField alloc] initWithFrame:frame];
    [self configField:_mailFld];
    [wrapper addSubview:_mailFld];
    
    //真实姓名
    frame = CGRectMake(0, CGRectGetMaxY(frame) + row_space, labelWidth, height);
    _realNameLbl = [[UILabel alloc] initWithFrame:frame];
    [self configLabel:_realNameLbl];
    _realNameLbl.text = @"真实姓名";
    [wrapper addSubview:_realNameLbl];
    
    frame.origin.x += frame.size.width + middle;
    frame.size.width = fieldWidth;
    _realNameFld = [[HYStrokeField alloc] initWithFrame:frame];
    [self configField:_realNameFld];
    [wrapper addSubview:_realNameFld];
    
    //QQ
    frame = CGRectMake(0, CGRectGetMaxY(frame) + row_space, labelWidth, height);
    _qqLbl = [[UILabel alloc] initWithFrame:frame];
    [self configLabel:_qqLbl];
    _qqLbl.text = @"QQ";
    [wrapper addSubview:_qqLbl];
    
    frame.origin.x += frame.size.width + middle;
    frame.size.width = fieldWidth;
    _qqFld = [[HYStrokeField alloc] initWithFrame:frame];
    [self configField:_qqFld];
    _qqFld.placeholder = @"QQ";
    //_qqFld.backgroundColor = [UIColor redColor];
    [wrapper addSubview:_qqFld];
    
    wrapper.frame = CGRectMake(CGRectGetWidth(self.view.frame)/2 - CGRectGetMaxX(_qqFld.frame)/2,  10, CGRectGetMaxX(_qqFld.frame), CGRectGetMaxY(_qqFld.frame));
    
    
    //提交
    HYAddCardSubmitBackgroundView *submitBg = [[HYAddCardSubmitBackgroundView alloc]
                                               initWithFrame:
                                               CGRectMake(offsetx,
                                                          CGRectGetMaxY(wrapper.frame)+ 33,
                                                          CGRectGetWidth(self.view.frame)-2*offsetx,
                                                          44)];
    submitBg.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin| \
    UIViewAutoresizingFlexibleRightMargin |\
    UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:submitBg];
    
    UIImage *btn_n = [UIImage imageNamed:@"orderlist_btn"];
    btn_n = [btn_n stretchableImageWithLeftCapWidth:5 topCapHeight:5];
    
    CGSize btnSize = {105, 30};
    frame = CGRectMake(0, 0, btnSize.width, btnSize.height);
    _submitBtn = [[UIButton alloc] initWithFrame:frame];
    [_submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [_submitBtn setBackgroundImage:btn_n forState:UIControlStateNormal];
    _submitBtn.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [_submitBtn addTarget:self action:@selector(submitBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    //[submitBg addSubview:_submitBtn];
    
    frame.origin.x = CGRectGetWidth(frame) + 10;
    _cancelBtn = [[UIButton alloc] initWithFrame:frame];
    [_cancelBtn setBackgroundImage:btn_n forState:UIControlStateNormal];
    [_cancelBtn setTitle:@"重置" forState:UIControlStateNormal];
    _cancelBtn.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [_cancelBtn addTarget:self action:@selector(cancelBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    //[submitBg addSubview:_cancelBtn];
    
    wrapper = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetMaxX(_cancelBtn.frame), CGRectGetMaxY(_cancelBtn.frame))];
    [wrapper addSubview:_submitBtn];
    [wrapper addSubview:_cancelBtn];
    wrapper.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [submitBg addSubview:wrapper];
    wrapper.center = CGPointMake(CGRectGetWidth(submitBg.frame)/2, CGRectGetHeight(submitBg.frame)/2);
    
    //数据
    HYUserInfo *userInfo = [HYDataManager sharedManager].userInfo;
    _nameFld.text = userInfo.user_name;
    _mailFld.text = userInfo.email;
    _realNameFld.text = userInfo.real_name;
    _nameFld.enabled = NO;
}

- (void)logout:(UIButton *)btn
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定退出吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = 201;
    [alert show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1 && alertView.tag == 201)
    {
        UIApplication *app = [UIApplication sharedApplication];
        HYAppDelegate *delegate = (HYAppDelegate *)app.delegate;
        [delegate showLogin];
    }
    if (alertView.tag == 200)
    {
        HYAppDelegate *delegate = (HYAppDelegate *)[[UIApplication sharedApplication] delegate];
        [delegate showLogin];
    }
}

- (void)configLabel:(UILabel *)label
{
    label.font = [UIFont systemFontOfSize:14.0];
    //label.backgroundColor = [UIColor redColor];
    label.textAlignment =  NSTextAlignmentCenter;
    //label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;
}

- (void)configField:(UITextField *)field
{
    //field.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin;
    field.returnKeyType = UIReturnKeyDone;
    field.font = [UIFont systemFontOfSize:14.0];
    field.delegate = self;
}

#pragma mark - Event

- (void)submitBtnClicked:(UIButton *)btn
{
    [self.view endEditing:YES];
    
    NSString *pass = _passFld.text;
    if (pass.length < 6 || pass.length > 11)
    {
        [UIAlertView showMessage:@"密码应在6到11位之间"];
        return;
    }
    
    if (!_request) {
        HYUserInfoEditRequestParma *request = [[HYUserInfoEditRequestParma alloc] init];
        _request = request;
    }
    
    _request.user_name = _nameFld.text;
    _request.password = _passFld.text;
    _request.email = _mailFld.text;
    _request.real_name = _realNameFld.text;
    _request.im_qq = _qqFld.text;
    
    [self showLoadingView];
    
    __weak typeof(self) b_self = self;
    [_request sendReuqest:^(id result, NSError *error)
    {
        [b_self hideLoadingView];
        
        if ([result isKindOfClass:[HYHYUserInfoEditResponse class]])
        {
            HYHYUserInfoEditResponse *response = (HYHYUserInfoEditResponse *)result;
            NSString *msg;
            if (response.status == 200)
            {
                msg = @"信息更新成功";
            }
            else
            {
                msg = response.rspDesc;
            }
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            alert.tag = response.status;
            alert.delegate = self;
            [alert show];
        }
        else
        {
            if (self.view.window)
            {
                [UIAlertView showMessage:@"网络请求异常"];
            }
        }
    }];
}

//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    
//}

- (void)cancelBtnClicked:(UIButton *)btn
{
    //数据
    HYUserInfo *userInfo = [HYDataManager sharedManager].userInfo;
    _nameFld.text = userInfo.user_name;
    _mailFld.text = userInfo.email;
    _realNameFld.text = userInfo.real_name;
    _passFld.text = nil;
    _qqFld.text = nil;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    BOOL isphone = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone;
    if (textField == _qqFld && isphone)
    {
        [UIView animateWithDuration:.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^
        {
            CGRect frame = self.view.frame;
            frame.origin.y -= 100;
            self.view.frame = frame;
        } completion:nil];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    BOOL isphone = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone;
    if (textField == _qqFld && isphone)
    {
        [UIView animateWithDuration:.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^
         {
             CGRect frame = self.view.frame;
             frame.origin.y += 100;
             self.view.frame = frame;
         } completion:nil];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark -

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
