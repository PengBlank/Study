//
//  HYQuickActiveViewController.m
//  HYManagmentDept
//
//  Created by RayXiang on 14-10-31.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYQuickActiveViewController.h"
#import "HYCardActiveRequest.h"
#import "UIAlertView+Utils.h"
#import "HYQuickActive2ViewController.h"
#import "NSString+Addition.h"
#import "HYActiveInfoCell.h"
#import "HYKeyboardHandler.h"

@interface HYQuickActiveViewController ()
<UITextFieldDelegate,
UITableViewDataSource,
UITableViewDelegate,
HYKeyboardHandlerDelegate>

@property (nonatomic, strong) UITextField *numField;
@property (nonatomic, strong) UITextField *passField;
@property (nonatomic, strong) UITextField *phoneField;
@property (nonatomic, strong) NSString *num;
@property (nonatomic, strong) NSString *pass;
@property (nonatomic, strong) NSString *phone;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) HYCardActiveRequest *request;

@property (nonatomic, strong) HYKeyboardHandler *keyboardHandler;

@end

@implementation HYQuickActiveViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 538)];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"快速激活";
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    UIImageView* image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 310, 50)];
    image.image = [UIImage imageNamed:@"person_bank_PA"];
    image.contentMode = UIViewContentModeScaleAspectFit;
    image.center = CGPointMake(160, 25);
    image.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
    [headerView addSubview:image];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
    UIButton * activateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    activateBtn.frame = CGRectMake(80, 14, 160, 40);
    [activateBtn setBackgroundImage:[UIImage imageNamed:@"btn_orange_normal"]
                           forState:UIControlStateNormal];
    [activateBtn setBackgroundImage:[UIImage imageNamed:@"btn_orange_press"]
                           forState:UIControlStateHighlighted];
    [activateBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [activateBtn setTitle:@"下一步"
                 forState:UIControlStateNormal];
    
    activateBtn.titleLabel.font = [UIFont boldSystemFontOfSize:19.0f];
    [activateBtn addTarget:self
                    action:@selector(nextBtnAction:)
          forControlEvents:UIControlEventTouchUpInside];
    activateBtn.autoresizingMask = UIViewAutoresizingHorizontalCenter;
    [footerView addSubview:activateBtn];
    
    UITableView *table = [[UITableView alloc] initWithFrame:self.view.bounds
                                                      style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    table.separatorColor = [UIColor grayColor];
    table.tableHeaderView = headerView;
    table.tableFooterView = footerView;
    table.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:table];
    self.tableView = table;
    
    self.keyboardHandler = [[HYKeyboardHandler alloc] initWithDelegate:self view:self.view];
    _keyboardHandler.tapToDismiss = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_keyboardHandler startListen];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [_keyboardHandler stopListen];
}
#pragma mark - private

- (UIView *)getLineWithY:(CGFloat)y
{
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(20, y, CGRectGetWidth(self.view.frame), 1)];
    line.backgroundColor = [UIColor grayColor];
    line.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    return line;
}

- (void)nextBtnAction:(UIButton *)btn
{
    [self.view endEditing:YES];
    
    NSString *error = nil;
    NSString *number = self.num;
    number = [number stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *phone = self.phone;
    NSString *pass = self.pass;
    
    do
    {
        if (!number || number.length != 12)
        {
            error = @"请输入会员卡号";
            break;
        }
        if (!pass || pass.length != 6)
        {
            error = @"请输入正确的密码";break;
        }
        if (!phone || phone.length == 0 || ![phone checkPhoneNumberValid])
        {
            error = @"请输入正确的手机号码";break;
        }
    } while (0);
    
    if (error)
    {
        [UIAlertView showMessage:error];
        return;
    }
    
    self.request = [[HYCardActiveRequest alloc] init];
    _request.number = number;
    _request.password = pass;
    _request.phone_mob = phone;
    
    [self showLoadingView];
    __weak typeof(self) b_self = self;
    [_request sendReuqest:^(id result, NSError *error)
    {
        [b_self hideLoadingView];
        HYCardActiveResponse *rs = (HYCardActiveResponse *)result;
        if (rs)
        {
            if (rs.status == 200)
            {
                [b_self handleResponse:rs];
            }
            else
            {
                [UIAlertView showMessage:error.domain];
            }
        }
        else
        {
            [UIAlertView showMessage:@"网络请求异常"];
        }
    }];
}

- (void)handleResponse:(HYCardActiveResponse *)rs
{
    HYQuickActive2ViewController *a2V = [[HYQuickActive2ViewController alloc] init];
    a2V.activeInfo = rs.activeInfo;
    a2V.delegate = self;
    [self.navigationController pushViewController:a2V animated:YES];
}

- (void)clearInfo
{
    self.numField.text = nil;
    self.passField.text = nil;
    self.phoneField.text = nil;
}

#pragma mark - table view
#pragma mark - table data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *fieldCell = @"fieldCell";
    HYActiveInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:fieldCell];
    if (cell == nil)
    {
        cell = [[HYActiveInfoCell alloc]initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:fieldCell];
        cell.valueField.delegate = self;
        cell.valueField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    }
    if (indexPath.row == 0)
    {
        cell.textLabel.text = @"会员卡号";
        cell.valueField.placeholder = @"请输入会员卡号";
        self.numField = cell.valueField;
        cell.valueField.returnKeyType = UIReturnKeyNext;
    }
    else if (indexPath.row == 1)
    {
        cell.textLabel.text = @"初始密码";
        cell.valueField.placeholder = @"请输入会员卡背面的初始密码";
        self.passField = cell.valueField;
        cell.valueField.returnKeyType = UIReturnKeyNext;
    }
    else if (indexPath.row == 2)
    {
        cell.textLabel.text = @"手机号码";
        cell.valueField.placeholder = @"请输入需要注册的手机号码";
        self.phoneField = cell.valueField;
        cell.valueField.returnKeyType = UIReturnKeyDone;
    }
    return cell;
}

#pragma mark - text field
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect frame = [self.tableView convertRect:textField.frame fromView:textField.superview];
    //NSIndexPath *path = [_tableView indexPathForRowAtPoint:frame.origin];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
                   {
                       /*[self.tableView scrollToRowAtIndexPath:path
                        atScrollPosition:UITableViewScrollPositionMiddle
                        animated:YES];*/
                       [_tableView scrollRectToVisible:frame animated:YES];
                   });
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.numField)
    {
        NSString *result = [textField.text stringByReplacingCharactersInRange:range
                                                                   withString:string];
        result = [result stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSMutableString *result_s = [NSMutableString stringWithString:result];
        NSInteger idx = 4;
        while (idx < result_s.length)
        {
            [result_s insertString:@" " atIndex:idx];
            idx += 5;
        }
        if (result_s.length <= 14) {
            textField.text = result_s;
        }
        return NO;
    }
    if (textField == self.passField)
    {
        NSString *result = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if (result.length <= 6) {
            textField.text = result;
        }
        return NO;
    }
    return YES;
}

#define getText(_num) \
    if (textField == _num##Field) { \
        _num = textField.text; \
    }

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    /*
     * this is
     * if (textField == _numField) {
     *      _num = textField.text;
     *  }
     */
    getText(_num)
    getText(_pass)
    getText(_phone)
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _numField) {
        [_passField becomeFirstResponder];
    }
    else if (textField == _passField)
    {
        [_phoneField becomeFirstResponder];
    }
    else if (textField == _phoneField)
    {
        [textField resignFirstResponder];
    }
    return YES;
}

#pragma mark - keyboard
//- (void)keyboardShow;
- (void)keyboardChangeFrame:(CGRect)kFrame
{
    CGFloat bottom = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 20 : 0;
    CGFloat keyboardheight = 0;
    BOOL systemLess8 = [UIDevice currentDevice].systemVersion.floatValue < 8.0;
    if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation) && systemLess8)
    {
        keyboardheight = CGRectGetWidth(kFrame);
    }
    else
    {
        keyboardheight = CGRectGetHeight(kFrame);
    }
    CGFloat height = keyboardheight - bottom;
    self.tableView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-height);
}

- (void)keyboardHide
{
    self.tableView.frame = self.view.bounds;
}

- (void)keyboardDone:(UIBarButtonItem *)item
{
    [self.view endEditing:YES];
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
