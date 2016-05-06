//
//  HYModiyPsdViewController.m
//  Teshehui
//
//  Created by 回亿资本 on 14-4-1.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYModiyPsdViewController.h"
#import "HYModifyPasswordRequest.h"
#import "HYInputCell.h"
#import "NSString+Addition.h"
#import "HYUserInfo.h"
#import "METoast.h"

@interface HYModiyPsdViewController ()<UITextFieldDelegate>
{
    HYModifyPasswordRequest *_request;
}

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation HYModiyPsdViewController

- (void)dealloc
{
    [_request cancel];
    _request = nil;
}

- (void)loadView
{
    CGRect frame = [[UIScreen mainScreen] bounds];
    frame.size.height -= 64;
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
    
//    UIView *footerView = [[UIView alloc] initWithFrame:TFRectMakeFixWidth(0, 0, 320, 60)];
   //先留着，防止产品改回来
    /*
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"修改密码";
    
    [self setupNavItem];
}

#pragma mark private methods
- (void)modifySuccess
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)modifyPsdWordEvent:(id)sender
{
    [self.view endEditing:YES];
    [self.tableView setContentOffset:CGPointZero
                            animated:YES];
    
    UITextField* oldField = (UITextField*)[self.view viewWithTag:1];
    UITextField* newField = (UITextField*)[self.view viewWithTag:2];
    UITextField* sureField = (UITextField*)[self.view viewWithTag:3];

    NSString* str;
    BOOL isOk = YES;

    if (oldField.text.length <6 || oldField.text.length > 20)
    {
        if (oldField.text.length == 0)
        {
            str = @"请输入旧密码";
        }
        else
        {
            str = @"密码长度不低于6位不超过20位";
        }
        
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
        _request = [[HYModifyPasswordRequest alloc] init];
        
        HYUserInfo *user = [HYUserInfo getUserInfo];
        
        _request.userId = user.userId;
        _request.password_old = oldField.text;
        _request.password_new = newField.text;
        
        [HYLoadHubView show];
        
        __weak typeof (self) b_self = self;
        [_request sendReuqest:^(id result, NSError *error) {
            
            [HYLoadHubView dismiss];
            
            if ([result isKindOfClass:[HYModifyPasswordRespone class]])
            {
                HYModifyPasswordRespone *response = (HYModifyPasswordRespone *)result;
                if (response.status == 200)
                {
                    [METoast toastWithMessage:@"成功修改密码" duration:2.0f andCompleteBlock:^{
                        [b_self modifySuccess];
                    }];
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
            }
            else
            {
                [METoast toastWithMessage:@"网络出现问题,请稍后再试"];
            }
        }];
    }
    else
    {
        UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"提示"
                                                           message:str
                                                          delegate:self
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil];
        [alertView show];
    }
}

- (void)setupNavItem
{
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    saveBtn.frame = CGRectMake(0, 0, 40, 15);
    [saveBtn addTarget:self action:@selector(modifyPsdWordEvent:) forControlEvents:UIControlEventTouchDown];
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    saveBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [saveBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:saveBtn];
    self.navigationItem.rightBarButtonItem = item;
}

#pragma mark tableview
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
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
    cell.textField.tag = indexPath.row+1;
    cell.textField.delegate = self;
    cell.textField.clearButtonMode =  UITextFieldViewModeWhileEditing;
    
    switch (indexPath.row) {
        case 0:
        {
            cell.nameLab.text = @"旧密码";
            cell.textField.placeholder = @"请输入您的旧密码";
            cell.textField.returnKeyType = UIReturnKeyNext;
            cell.textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            cell.textField.secureTextEntry = YES;
            break;
        }
        case 1:
        {
            cell.nameLab.text = @"新密码";
            cell.textField.placeholder = @"6-20位数字或者字母";
            cell.textField.returnKeyType = UIReturnKeyNext;
            cell.textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            cell.textField.secureTextEntry = YES;
            break;
        }
        case 2:
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.dragging)
    {
        [self.view endEditing:YES];
    }
}

#pragma mark textfield

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGPoint size = CGPointZero;
    size.y = 40 *(textField.tag-1);
    size.y = (size.y>0)? size.y : 0;
    
    [self.tableView setContentOffset:size animated:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.returnKeyType == UIReturnKeyNext)
    {
        UITextField* phone = (UITextField*)[self.view viewWithTag:(textField.tag+1)];
        [phone becomeFirstResponder];
    }
    else if (textField.returnKeyType == UIReturnKeyDone)
    {
        [textField resignFirstResponder];
    }
    
    return YES;
}


@end
