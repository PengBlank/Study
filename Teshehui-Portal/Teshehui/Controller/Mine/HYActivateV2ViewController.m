//
//  HYActivateV2ViewController.m
//  Teshehui
//
//  Created by 成才 向 on 15/8/17.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYActivateV2ViewController.h"
#import "HYLoginV2TextCell.h"
#import "HYActivateV2ValidateViewController.h"
#import "HYCardActiveOneRequest.h"
#import "HYUmengLoginClick.h"
#import "HYInfoInputCell.h"
#import "METoast.h"
#import "HYOnlineBuyCardFirstStepViewController.h"

@interface HYActivateV2ViewController ()
<UITableViewDataSource,
UITableViewDelegate,
UITextFieldDelegate>
{
    NSString *_cardNum;
    NSString *_passWord;
}
@property (nonatomic, strong) NSString *cardNum;
@property (nonatomic, strong) NSString *passWord;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *nextBtn;
@property (nonatomic, strong) HYCardActiveOneRequest *request;

@property (nonatomic, assign) BOOL isLoading;

@end

@implementation HYActivateV2ViewController

- (void)dealloc
{
    [_request cancel];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        _isLoading = NO;
    }
    return self;
}

- (void)loadView
{
    CGRect frame = [[UIScreen mainScreen] bounds];
    frame.size.height -= 64;
    self.view = [[UIView alloc] initWithFrame:frame];
    self.view.backgroundColor = [UIColor colorWithWhite:.94 alpha:1];
    
    //table
    UITableView *table = [[UITableView alloc] initWithFrame:frame
                                                      style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    table.rowHeight = 50;
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    table.backgroundColor = [UIColor clearColor];
    table.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 10)];
    [self.view addSubview:table];
    self.tableView = table;
        
    //foot
    UIView *footview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame)-290)];
    footview.backgroundColor = [UIColor clearColor];
    table.tableFooterView = footview;
    
    UIImage *disable = [[UIImage imageNamed:@"btn_login_new_disable"] stretchableImageWithLeftCapWidth:3 topCapHeight:5];
    UIImage *normal = [UIImage imageNamed:@"btn_login_new"];
    UIButton *loginBtn = [[UIButton alloc] initWithFrame:
                          CGRectMake(24, 30, CGRectGetWidth(frame)-48, 44)];
    [loginBtn setBackgroundImage:normal forState:UIControlStateNormal];
    [loginBtn setBackgroundImage:disable forState:UIControlStateDisabled];
    [loginBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(validateCard) forControlEvents:UIControlEventTouchUpInside];
    [footview addSubview:loginBtn];
    self.nextBtn = loginBtn;
    
    UIButton *buycard = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    [buycard setTitle:@"没有会员卡？立即在线购买 >>" forState:UIControlStateNormal];
    [buycard setTitleColor:[UIColor colorWithWhite:.7 alpha:1] forState:UIControlStateNormal];
    buycard.frame = CGRectMake(frame.size.width/2 - 100, CGRectGetMaxY(loginBtn.frame)+10, 200, 44);
    buycard.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [buycard addTarget:self action:@selector(toBuyCard) forControlEvents:UIControlEventTouchUpInside];
    [footview addSubview:buycard];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"验证卡号密码";
    self.navigationController.navigationBarHidden = NO;
    
    [self checkNextBtn];
}

#pragma mark - event
- (void)dismissView:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)toBuyCard
{
    HYOnlineBuyCardFirstStepViewController *buy = [[HYOnlineBuyCardFirstStepViewController alloc] init];
    [self.navigationController pushViewController:buy animated:YES];
}

#pragma mark - functions
#pragma mark -- private
- (void)checkNextBtn
{
    if (_cardNum.length > 0 && _passWord.length > 0)
    {
        self.nextBtn.enabled = YES;
    }
    else
    {
        self.nextBtn.enabled = NO;
    }
}

- (void)validateCard
{
    [self.view endEditing:YES];
    if (!_isLoading)
    {
        NSString *err = nil;
        if (!_cardNum)
        {
            err = @"请输入卡号";
        }
        else if (_cardNum.length != 12)
        {
            err = @"您输入的会员卡号位数不正确";
        }
        else if (_passWord.length < 6)
        {
            err = @"会员卡密码至少6位";
        }
        if (err)
        {
            [METoast toastWithMessage:err];
        }
        else
        {
            _request = [[HYCardActiveOneRequest alloc] init];
            _request.memberCardNumber = _cardNum;
            _request.memberCardPassword = _passWord;
            [HYLoadHubView show];
            _isLoading = YES;
            __weak typeof(self) weakSelf = self;
            [_request sendReuqest:^(HYCardActiveOneResponse* result, NSError *error)
             {
                 [HYLoadHubView dismiss];
                 weakSelf.isLoading = NO;
                 
                 if ([result isKindOfClass:[HYCardActiveOneResponse class]] &&
                     result.status == 200)
                 {
                     HYActivateV2ValidateViewController *validate = [[HYActivateV2ValidateViewController alloc] init];
                     validate.activateInfo = result.info;
                     [weakSelf.navigationController pushViewController:validate animated:YES];
                 }
                 else
                 {
                     [METoast toastWithMessage:result.suggestMsg];
                 }
             }];
        }
    }
    
    [HYUmengLoginClick clickMoreActivateNext];
}

#pragma mark - delegates
#pragma mark -- tableview delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  2;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuse = @"reuse";
    HYInfoInputCell *phoneCell = [tableView dequeueReusableCellWithIdentifier:reuse];
    if (!phoneCell)
    {
        phoneCell = [[HYInfoInputCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
//        phoneCell.textField.placeholder = @"卡号";
//        phoneCell.textField.keyboardType = UIKeyboardTypeDecimalPad;
    }
    WS(weakSelf);
    if (indexPath.row == 0)
    {
        phoneCell.name = @"会员卡号";
        phoneCell.value = _cardNum;
        phoneCell.valueField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        phoneCell.placeholder = @"请输入您的会员卡号";
        phoneCell.didGetValue = ^(NSString *value) {
            weakSelf.cardNum = value;
            [weakSelf checkNextBtn];
        };
        return phoneCell;
    }
    else
    {
        phoneCell.name = @"初始密码";
        phoneCell.placeholder = @"请输入初始密码";
        phoneCell.valueField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        phoneCell.valueField.secureTextEntry = YES;
        phoneCell.value = _passWord;
        phoneCell.didGetValue = ^(NSString *value) {
            weakSelf.passWord = value;
            [weakSelf checkNextBtn];
        };
        return phoneCell;
    }
    DebugNSLog(@"cell缺失");
    return nil;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.isDragging)
    {
        [self.view endEditing:YES];
    }
}

@end
