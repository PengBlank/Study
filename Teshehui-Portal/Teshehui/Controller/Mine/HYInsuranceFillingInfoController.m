//
//  HYInsuranceFillingInfoController.m
//  Teshehui
//
//  Created by Kris on 15/11/4.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYInsuranceFillingInfoController.h"
#import "HYLoginV2TextCell.h"
#import "NSString+Addition.h"

@interface HYInsuranceFillingInfoController ()
<UITableViewDataSource,
UITableViewDelegate,
UITextFieldDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSString *result;

@end

@implementation HYInsuranceFillingInfoController

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
    [loginBtn setTitle:@"保存" forState:UIControlStateNormal];
    [loginBtn addTarget:self
                 action:@selector(saveAction:)
       forControlEvents:UIControlEventTouchUpInside];
    [foot addSubview:loginBtn];
    self.tableView.tableFooterView = foot;
}

- (void)saveAction:(id)sender
{
    [self.view endEditing:YES];
  
    if ([_result length] <= 0)
    {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"提示" message:@"请输入正确的信息" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
    }
    if (self.handler)
    {
        self.handler(_result);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - table
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

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
        phoneCell.textField.text = self.result;
        phoneCell.textField.returnKeyType = UIReturnKeyNext;
        phoneCell.textField.tag = 101;
        phoneCell.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
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
            self.result = textField.text;
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

    }
    return YES;
}


@end
