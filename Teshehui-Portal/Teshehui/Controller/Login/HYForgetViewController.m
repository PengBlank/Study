//
//  HYForgetViewController.m
//  Teshehui
//
//  Created by ichina on 14-3-5.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYForgetViewController.h"
#import "HYForGetRequest.h"
#import "HYForGetResponse.h"
#import "NSString+Addition.h"
#import "HYLoadHubView.h"
#import "HYGetCheckView.h"
#import "HYInputCell.h"
#import "HYNewPassWordRequest.h"
#import "HYNewPassWordResponse.h"
#import "HYSendCheckRequest.h"
#import "HYSendCheckResponse.h"
#import "METoast.h"
#import "CCCountTimer.h"
#import "HYInfoInputCell.h"
#import "HYInfoValidateCell.h"


@interface HYForgetViewController ()
<UITextFieldDelegate,
UITableViewDataSource,
UITableViewDelegate>
{
    HYForGetRequest* _forGetRequest;
    HYNewPassWordRequest* _newPasswordRequest;
    
    BOOL _showAdditionInfo;
}

@property(nonatomic,strong)UITableView* tableview;

/// 数据项
@property (nonatomic, strong) NSString *mob;
@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *pass;
@property (nonatomic, strong) NSString *pass2;

@end

@implementation HYForgetViewController

#pragma mark - life cycle

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)dealloc
{
    [HYLoadHubView dismiss];
    [_forGetRequest cancel];
    _forGetRequest = nil;
    [_newPasswordRequest cancel];
    _newPasswordRequest = nil;
}

- (void)loadView
{
    CGRect frame = [UIScreen mainScreen].bounds;
    frame.size.height -= 64;
    self.view = [[UIView alloc] initWithFrame:frame];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UITableView *table = [[UITableView alloc] initWithFrame:frame
                                                      style:UITableViewStylePlain];
    table.dataSource = self;
    table.delegate = self;
    table.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    table.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 10)];
    table.backgroundView = nil;
    table.backgroundColor = [UIColor clearColor];
    [self.view addSubview:table];
    self.tableview = table;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    self.title = @"找回密码";
    self.view.backgroundColor = [UIColor colorWithWhite:.97 alpha:1];
    
    _showAdditionInfo = NO;
}

#pragma mark - setter getter
- (UIBarButtonItem *)commitItem
{
    UIButton *commit = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 64, 44)];
    [commit setTitle:@"提交" forState:UIControlStateNormal];
    [commit setTitleColor:[UIColor colorWithWhite:.5 alpha:1] forState:UIControlStateNormal];
    commit.titleLabel.font = [UIFont systemFontOfSize:14.0];
    UIBarButtonItem *commitItem = [[UIBarButtonItem alloc] initWithCustomView:commit];
    self.navigationItem.rightBarButtonItem = commitItem;
    [commit addTarget:self
               action:@selector(commitAction)
     forControlEvents:UIControlEventTouchUpInside];
    return commitItem;
}

#pragma mark - event
- (void)commitAction
{
    [self resetPassword];
}

#pragma mark - functions

#pragma mark -- public
#pragma mark -- private
/// 发送验证码
- (void)sendValidate:(NSString *)phone callback:(void (^)(BOOL success))callback
{
    if (phone.length == 0)
    {
        [METoast toastWithMessage:@"请输入您的手机号！"];
        if (callback) {
            callback(NO);
        }
    }
    else if ([phone checkPhoneNumberValid])
    {
        if (!_forGetRequest)
        {
            _forGetRequest = [[HYForGetRequest alloc] init];
        }
        
        _forGetRequest.phone_mob = phone;
        
        [HYLoadHubView show];
//        __weak typeof (self) b_self = self;
        [_forGetRequest sendReuqest:^(id result, NSError *error)
        {
            [HYLoadHubView dismiss];
            if ([result isKindOfClass:[HYForGetResponse class]])
            {
                HYForGetResponse *response = (HYForGetResponse *)result;
//                NSDictionary* dic = response.dic;
//                b_self.dic = [NSDictionary dictionaryWithDictionary:dic];
                
                if (response.status == 200)
                {
                    if (callback) {
                        callback(YES);
                    }
                }
                else
                {
                    [METoast toastWithMessage:response.rspDesc];
                    if (callback) {
                        callback(NO);
                    }
                }
            }else{
                [METoast toastWithMessage:@"网络出现问题,请稍后再试"];
                if (callback) {
                    callback(NO);
                }
            }
        }];
    }
    else
    {
        [METoast toastWithMessage:@"请输入有效的手机号码！"];
        if (callback) {
            callback(NO);
        }
    }
}

-(void)resetPassword
{
    [self.view endEditing:YES];
    
    NSString *err;
    BOOL hasspace = NO;
    for (int i = 0; i < self.pass.length; i++) {
        unichar ch = [self.pass characterAtIndex:i];
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        if ([set characterIsMember:ch]) {
            hasspace = YES;
            break;
        }
    }
    if (self.code.length == 0)
    {
        err = @"请输入验证码！";
    }
    else if (self.code.length !=6)
    {
        err = @"您输入的验证码不正确，请重新输入！";
    }
    else if (self.pass.length == 0)
    {
        err = @"请输入新密码！";
    }
    else if (self.pass.length < 6 ||self.pass.length > 20)
    {
        err = @"密码长度不低于6位不超过20位！";
    }
    else if (hasspace)
    {
        err = @"密码格式有误";
    }
    else if (self.pass2.length == 0)
    {
        err = @"请重复一遍新密码！";
    }
    else if (![self.pass isEqualToString:self.pass2])
    {
        err = @"两次密码输入不一致，请重新确认";
    }
    
    if (!err)
    {
        if (!_newPasswordRequest)
        {
            _newPasswordRequest = [[HYNewPassWordRequest alloc] init];
        }
        
        _newPasswordRequest.phone_mob = self.mob;
        _newPasswordRequest.phone_code = self.code;
        _newPasswordRequest.newpassword = self.pass;
        
        [HYLoadHubView show];
        __weak typeof (self) b_self = self;
        [_newPasswordRequest sendReuqest:^(id result, NSError *error) {
            
            [HYLoadHubView dismiss];
            
            if ([result isKindOfClass:[HYNewPassWordResponse class]])
            {
                HYNewPassWordResponse *response = (HYNewPassWordResponse *)result;
                if (response.status == 200)
                {
                    [METoast toastWithMessage:@"找回成功，请重新登录"];
                    [b_self.navigationController popViewControllerAnimated:YES];
                    
                }
                else if (response.status == 300)
                {
                    [METoast toastWithMessage:@"手机验证码不正确，请重新填写"];
                }
                else
                {
                    [METoast toastWithMessage:response.suggestMsg];
                }
            }
        }];
    }
    else
    {
        [METoast toastWithMessage:err];
    }
}

- (void)showAdditionInfo
{
    _showAdditionInfo = YES;
    self.navigationItem.rightBarButtonItem = [self commitItem];
    [self.tableview reloadData];
}

#pragma mark - delegates
#pragma mark -- tableview delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_showAdditionInfo) {
        return 4;
    }
    else {
        return 1;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        static NSString *reuse = @"validate";
        HYInfoValidateCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
        if (!cell)
        {
            cell = [[HYInfoValidateCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
        }
        WS(weakSelf);
        __weak HYInfoValidateCell *weakCell = cell;
        cell.startValidate = ^(NSString *mob) {
            [weakSelf sendValidate:mob callback:^(BOOL success) {
                if (weakCell && success) {
                    [weakCell startCounting];
                }
                if (success)
                {
                    [weakSelf showAdditionInfo];
                    weakCell.canEditPhone = NO;
                }
            }];
        };
        cell.mob = self.mob;
        cell.showName = YES;
        cell.didGetValue = ^(NSString *value){
            weakSelf.mob = value;
        };
        return cell;
    }
    else
    {
        static NSString *reuse = @"info";
        HYInfoInputCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
        if (!cell)
        {
            cell = [[HYInfoInputCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
            cell.showName = YES;
        }
        WS(weakSelf);
        switch (indexPath.row)
        {
            case 1:
            {
                cell.name = @"验证码";
                cell.placeholder = @"请输入验证码";
                cell.value = self.code;
                cell.valueField.returnKeyType = UIReturnKeyNext;
                cell.valueField.keyboardType = UIKeyboardTypeDecimalPad;
                cell.didGetValue = ^(NSString *value) {
                    weakSelf.code = value;
                };
                cell.didReturn = ^{
                    HYInfoInputCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row+1 inSection:indexPath.section]];
                    [cell.valueField becomeFirstResponder];
                };
                break;
            }
            case 2:
            {
                cell.name = @"新密码";
                cell.placeholder = @"6-20位数字或者字母";
                cell.valueField.secureTextEntry = YES;
                cell.valueField.returnKeyType = UIReturnKeyNext;
                cell.value = self.pass;
                cell.didGetValue = ^(NSString *value) {
                    weakSelf.pass = value;
                };
                cell.didReturn = ^{
                    HYInfoInputCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row+1 inSection:indexPath.section]];
                    [cell.valueField becomeFirstResponder];
                };
                break;
            }
            case 3:
            {
                cell.name = @"确认密码";
                cell.placeholder = @"请重复一遍新密码";
                cell.value = self.pass2;
                cell.valueField.secureTextEntry = YES;
                cell.valueField.returnKeyType = UIReturnKeyGo;
                cell.didGetValue = ^(NSString *value) {
                    weakSelf.pass2 = value;
                };
                cell.didReturn = ^{
                    [weakSelf commitAction];
                };
                break;
            }
            default:
                break;
        }
        return cell;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.isDragging)
    {
        [self.view endEditing:YES];
    }
}


@end
