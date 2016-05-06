//
//  HYResetPswViewController.m
//  Teshehui
//
//  Created by Kris on 15/12/22.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYResetPswViewController.h"
#import "HYInputCell.h"
#import "HYResetPsdCodeCell.h"
#import "NSString+Common.h"
#import "HYUserInfo.h"
#import "HYNewPassWordRequest.h"
#import "HYNewPassWordResponse.h"
#import "METoast.h"

@interface HYResetPswViewController ()
<UITableViewDataSource,
UITableViewDelegate,
UITextFieldDelegate,
HYResetPsdCodeCellDelegate>
{
    BOOL _gotAuthCode;
    NSString *_mobilePhone;
    NSString *_validateCode;
    
    HYNewPassWordRequest* _newPassWordRequest;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *saveBtn;

@end

@implementation HYResetPswViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupNavItem];
    _mobilePhone = [HYUserInfo getUserInfo].mobilePhone;
}

- (void)loadView
{
    CGRect frame = [[UIScreen mainScreen] bounds];
//    frame.size.height -= 64;
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor whiteColor];
    self.view = view;
    
    //tableview
    UITableView *tableview = [[UITableView alloc] initWithFrame:frame
                                                          style:UITableViewStylePlain];
    tableview.delegate = self;
    tableview.dataSource = self;
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //    tableview.sectionFooterHeight = 60;
    tableview.rowHeight = 60;
    tableview.backgroundColor = [UIColor clearColor];
    tableview.backgroundView = nil;
    
    //先留着，防止产品又改回来
    /*
    UIView *footerView = [[UIView alloc] initWithFrame:TFRectMakeFixWidth(0, 0, 320, 60)];
    UIButton* loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame = TFRectMakeFixWidth(80, 10, 160, 40);
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"person_buttom_orange2_normal"] forState:UIControlStateNormal];
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"person_buttom_orange2_press"] forState:UIControlStateHighlighted];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginBtn setTitle:@"确定修改" forState:UIControlStateNormal];
    loginBtn.titleLabel.font = [UIFont boldSystemFontOfSize:19.0f];
    [loginBtn addTarget:self
                 action:@selector(modifyPsdWordEvent:)
       forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:loginBtn];
    
    tableview.tableFooterView = footerView;
    */
    
    [self.view addSubview:tableview];
    self.tableView = tableview;
}

#pragma mark tableview
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        HYResetPsdCodeCell *codeCell = [tableView dequeueReusableCellWithIdentifier:@"codeCell"];
        if (!codeCell)
        {
            codeCell = [[HYResetPsdCodeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"codeCell"];
            codeCell.textField.placeholder = @"请输入手机号码";
            codeCell.delegate = self;
//            [codeCell.codeBtn addTarget:self
//                                 action:@selector(validateAction:)
//                       forControlEvents:UIControlEventTouchUpInside];
        }
        codeCell.nameLab.text = @"手机号";
        codeCell.nameLab.frame = CGRectMake(20, 20, 70, 20);
        codeCell.textField.frame = CGRectMake(90, 20, 220, 20);
        codeCell.textField.text = _mobilePhone ? [NSString turnToSecurityNum:_mobilePhone] : nil;
        codeCell.mobilePhone = _mobilePhone;
        codeCell.textField.delegate = self;
        codeCell.textField.tag = 200;
        codeCell.textField.userInteractionEnabled = NO;
        codeCell.textField.keyboardType = UIKeyboardTypeNumberPad;
        return codeCell;
    }
    else
    {
        static NSString *hyInputCell = @"HYInputCell";
        HYInputCell *cell = [tableView dequeueReusableCellWithIdentifier:hyInputCell];
        
        if (!cell)
        {
            cell = [[HYInputCell alloc]initWithStyle:UITableViewCellStyleDefault
                                     reuseIdentifier:hyInputCell];
        }
        
        cell.nameLab.frame = CGRectMake(20, 20, 70, 20);
        cell.nameLab.font = [UIFont systemFontOfSize:16.0f];
        cell.textField.frame = CGRectMake(90, 20, 220, 20);
        cell.textField.font = [UIFont systemFontOfSize:16.0f];
        cell.textField.delegate = self;
        cell.textField.tag = indexPath.row;
        cell.textField.clearButtonMode =  UITextFieldViewModeWhileEditing;
        
        switch (indexPath.row) {
            case 1:
            {
                cell.nameLab.text = @"验证码";
                cell.textField.placeholder = @"请输入验证码";
                cell.textField.returnKeyType = UIReturnKeyDone;
                cell.textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
                break;
            }
            case 2:
            {
                cell.nameLab.text = @"新密码";
                cell.textField.placeholder = @"6-20位数字或者字母";
                cell.textField.returnKeyType = UIReturnKeyDone;
                cell.textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
                cell.textField.secureTextEntry = YES;
                break;
            }
            case 3:
            {
                cell.nameLab.text = @"确认密码";
                cell.textField.placeholder = @"请重复一遍新密码";
                cell.textField.returnKeyType = UIReturnKeyDone;
                cell.textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
                cell.textField.secureTextEntry = YES;
                break;
            }
            default:
                break;
        }
        return cell;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _gotAuthCode ? 4 : 1;
}

#pragma mark private methods
- (void)startTimming
{
    HYResetPsdCodeCell *codeCell = (HYResetPsdCodeCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    if (codeCell)
    {
        [codeCell startTiming];
    }
}

- (void)setupNavItem
{
    _saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _saveBtn.frame = CGRectMake(0, 0, 40, 15);
    [_saveBtn addTarget:self action:@selector(savePassword) forControlEvents:UIControlEventTouchDown];
    [_saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [_saveBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    _saveBtn.hidden = YES;
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:_saveBtn];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)savePassword
{
    [self.view endEditing:YES];
    [self.tableView setContentOffset:CGPointZero
                            animated:YES];
    
    UITextField* authField = (UITextField*)[self.view viewWithTag:1];
    UITextField* newField = (UITextField*)[self.view viewWithTag:2];
    UITextField* sureField = (UITextField*)[self.view viewWithTag:3];
    
    NSString* str;
    BOOL isOk = YES;
    
    if (authField.text.length <= 0)
    {
        str = @"请输入验证码";
        isOk = NO;
    }
    else if (newField.text.length <6 || newField.text.length > 20)
    {
        if (newField.text.length == 0)
        {
            str = @"请输入新密码";
        }
        else
        {
            str = @"密码长度不低于6位不超过20位";
        }
        
        isOk = NO;
    }
    else if (sureField.text.length <6 || sureField.text.length > 20)
    {
        if (sureField.text.length == 0)
        {
            str = @"请输入确认密码";
        }
        else
        {
            str = @"密码长度不低于6位不超过20位";
        }
        
        isOk = NO;
    }
    else
    {
        isOk = [sureField.text isEqualToString:newField.text];
        if (!isOk)
        {
            str = @"两次密码输入不一致,请重新确认";
        }
    }
    
    if (isOk)
    {
        if (!_newPassWordRequest)
        {
            _newPassWordRequest = [[HYNewPassWordRequest alloc] init];
        }
        [_newPassWordRequest cancel];
        
        _newPassWordRequest.phone_mob = _mobilePhone;
        _newPassWordRequest.phone_code = authField.text;
        _newPassWordRequest.newpassword = newField.text;
        
        [HYLoadHubView show];
        
        __weak typeof (self) b_self = self;
        [_newPassWordRequest sendReuqest:^(id result, NSError *error) {
            
            [HYLoadHubView dismiss];
            
            if ([result isKindOfClass:[HYNewPassWordResponse class]])
            {
                HYNewPassWordResponse *response = (HYNewPassWordResponse *)result;
                if (response.status == 200)
                {
                    /*
                    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                                   message:@"找回成功，请重新登录"
                                                                  delegate:nil
                                                         cancelButtonTitle:@"确定"
                                                         otherButtonTitles:nil];
                    alert.tag = 200;
                    alert.delegate = self;
                    [alert showWithCompletionHandler:^(NSInteger buttonIndex) {
                        [b_self.navigationController popViewControllerAnimated:YES];
                    }];
                     */
                    [METoast toastWithMessage:@"重置成功" andCompleteBlock:^{
                        [b_self.navigationController popViewControllerAnimated:YES];
                    }];
                    
                }
                else if (response.status == 500)
                {
                    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                                   message:@"验证码不正确"
                                                                  delegate:nil
                                                         cancelButtonTitle:@"确定"
                                                         otherButtonTitles:nil];
                    [alert show];
                }
            }
        }];
    }
    else
    {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                       message:str
                                                      delegate:nil
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles:nil];
        [alert show];
    }
}

#pragma mark HYResetPsdCodeCellDelegate
- (void)tellDelegateAuthStatus:(BOOL)status
{
    _gotAuthCode = status;
    _saveBtn.hidden = !status;
    
    [self.tableView reloadData];
}

#pragma mark textfield delegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self.tableView setContentOffset:CGPointMake(0, 50) animated:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
