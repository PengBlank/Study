//
//  HYAccountLoginViewController.m
//  Teshehui
//
//  Created by 成才 向 on 15/8/10.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYAccountLoginViewController.h"
#import "HYLoginV2TextCell.h"
#import "HYAppDelegate.h"
#import "HYLoginRequest.h"
#import "HYLoginResponse.h"
#import "HYLoadHubView.h"
#import "HYUserInfo.h"
#import "HYForgetViewController.h"
#import "HYUmengLoginClick.h"
#import "HYAnalyticsManager.h"

UIKIT_EXTERN NSString * const LoginStatusChangeNotification;

@interface HYAccountLoginViewController ()
<UITableViewDataSource,
UITableViewDelegate,
UITextFieldDelegate>
{
    HYLoginRequest *_loginRequset;
}

@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, strong) UITableView *tableView;

@property(nonatomic, copy) NSString *phone;
@property (nonatomic, strong) NSString *password;

@end

@implementation HYAccountLoginViewController

- (void)loadView
{
    CGRect frame = [[UIScreen mainScreen] bounds];
    frame.size.height -= 64;
    self.view = [[UIView alloc] initWithFrame:frame];
    self.view.backgroundColor = [UIColor colorWithWhite:.91 alpha:1];
    
    self.tableView = [[UITableView alloc] initWithFrame:frame
                                                  style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 60;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    //head
    UIView *head = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 10)];
    self.tableView.tableHeaderView = head;
    
    //foot
    UIView *foot = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 110)];
    
    UIImage *disable = [[UIImage imageNamed:@"btn_login_new_disable"] stretchableImageWithLeftCapWidth:3 topCapHeight:5];
    UIImage *normal = [UIImage imageNamed:@"btn_login_new"];
    UIButton *loginBtn = [[UIButton alloc] initWithFrame:
                          CGRectMake(24, 15, CGRectGetWidth(frame)-48, 44)];
    [loginBtn setBackgroundImage:normal forState:UIControlStateNormal];
    [loginBtn setBackgroundImage:disable forState:UIControlStateDisabled];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn addTarget:self
                 action:@selector(loginAction:)
       forControlEvents:UIControlEventTouchUpInside];
    [foot addSubview:loginBtn];
    
    //忘记密码
    UIButton *forget = [[UIButton alloc] initWithFrame:CGRectMake(20, 65, 54, 44)];
    [forget setTitle:@"忘记密码" forState:UIControlStateNormal];
    [forget setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    forget.titleLabel.font = [UIFont systemFontOfSize:12.0];
    [forget addTarget:self
               action:@selector(forgetPassAction:)
     forControlEvents:UIControlEventTouchUpInside];
    [foot addSubview:forget];
    
    self.tableView.tableFooterView = foot;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"登录";
    self.navigationController.navigationBarHidden = NO;
    
    self.phone = [[NSUserDefaults standardUserDefaults] objectForKey:kPhoneNumber];
    self.isLoading = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loginAction:(UIButton *)btn
{
    [self goLogin];
    
    [HYUmengLoginClick clickMoreAccountLogin];
}

- (void)forgetPassAction:(UIButton *)btn
{
    HYForgetViewController *vc = [[HYForgetViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
    [HYUmengLoginClick clickMoreAccountForget];
}

#pragma mark - table
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HYLoginV2TextCell *phoneCell = [tableView dequeueReusableCellWithIdentifier:@"phoneCell"];
    if (!phoneCell)
    {
        phoneCell = [[HYLoginV2TextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"phoneCell"];
        phoneCell.textField.delegate = self;
    }
    if (indexPath.row == 0)
    {
        phoneCell.textField.placeholder = @"请输入手机号码或卡号";
        phoneCell.textField.text = self.phone;
        phoneCell.textField.returnKeyType = UIReturnKeyNext;
//        phoneCell.textField.keyboardType = UIKeyboardTypeNumberPad;
        phoneCell.textField.tag = 101;
    }
    else
    {
        phoneCell.textField.placeholder = @"密码";
        phoneCell.textField.returnKeyType = UIReturnKeyDone;
        phoneCell.textField.secureTextEntry = YES;
        phoneCell.textField.tag = 102;
        phoneCell.textField.text = self.password;
    }
    return phoneCell;
}

#pragma mark - text field
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    UITextFieldEx *textFieldEx = (UITextFieldEx *)textField;
    textFieldEx.isActive = NO;
    
    switch (textField.tag)
    {
        case 101:
            self.phone = textField.text;
            break;
        case 102:
            self.password = textField.text;
            break;
        default:
            break;
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    UITextFieldEx *textFieldEx = (UITextFieldEx *)textField;
    textFieldEx.isActive = YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    UITextField* password = (UITextField*)[self.view viewWithTag:102];
    if (textField.tag == 1)
    {
        [password becomeFirstResponder];
    }
    else
    {
        [self goLogin];
    }
    return YES;
}

-(void)goLogin
{
    [self.view endEditing:YES];
    if (_isLoading) {
        return;
    }
    
    NSString *error = nil;
    if (self.phone.length == 0)
    {
        error = @"手机号码或卡号不能为空";
    }
    else if (self.password.length == 0)
    {
        error = @"密码不能为空";
    }
    
    if (error)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:error delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        [HYLoadHubView show];
        
        if (!_loginRequset)
        {
            _loginRequset = [[HYLoginRequest alloc] init];
        }
        _loginRequset.loginName = self.phone;
        _loginRequset.password = self.password;
        __weak typeof(self) b_self = self;
        self.isLoading = YES;
        [_loginRequset sendReuqest:^(id result, NSError *error)
         {
             [HYLoadHubView dismiss];
             b_self.isLoading = NO;
             HYLoginResponse *response = (HYLoginResponse *)result;
             if (response.status == 200)
             {
                 [[NSUserDefaults standardUserDefaults] setBool:YES
                                                         forKey:kIsLogin];
                 
                 //如果切换了账号则需要清除内存
                 NSString *lastNumber = [[NSUserDefaults standardUserDefaults] objectForKey:kPhoneNumber];
                 BOOL needClearCache = !([lastNumber isEqualToString:response.userInfo.mobilePhone]);
                 
                 [response.userInfo saveData];
                 [[NSNotificationCenter defaultCenter] postNotificationName:LoginStatusChangeNotification object:nil];
                 
                 if (needClearCache)
                 {
                     HYAppDelegate* appDelegate = (HYAppDelegate*)[[UIApplication sharedApplication] delegate];
                     [appDelegate loadContentView:YES];
                 }
                 else
                 {
                     [self.navigationController dismissViewControllerAnimated:YES
                                                                   completion:nil];
                 }
                 
                 //统计
                 [HYAnalyticsManager sendUserLoginType:102];
             }
             else if (response.status == -90010)  //未激活的卡
             {
                 UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                                message:@"该卡暂未激活,您可以立刻激活"
                                                               delegate:b_self
                                                      cancelButtonTitle:@"取消"
                                                      otherButtonTitles:@"激活", nil];
                 alert.tag = 11;
                 [alert show];
             }
             else
             {
                 UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                                message:response.suggestMsg
                                                               delegate:nil
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles:nil];
                 [alert show];
             }
         }];
    }
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
