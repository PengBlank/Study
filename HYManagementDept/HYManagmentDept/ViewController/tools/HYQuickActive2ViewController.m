//
//  HYQuickActive2ViewController.m
//  HYManagmentDept
//
//  Created by RayXiang on 14-10-31.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYQuickActive2ViewController.h"
#import "HYActiveInfoCell.h"
#import "HYActiveInfoSelectCell.h"
#import "HYCardType.h"
#import "HYCardTypeListViewController.h"
#import "HYPickerToolView.h"
#import "HYPopSelectViewController.h"
#import "HYPopDateViewController.h"
#import "DatePickerViewController.h"
#import "NSDate+Addition.h"
#import "HYKeyboardHandler.h"
#import "NSString+Addition.h"
#import "HYActivateUserRequest.h"
#import "UIAlertView+Utils.h"
#import "HYSendCheckRequest.h"
#import "HYQuickActiveViewController.h"
#import "HYOnlinePurchaseRequest.h"
#import "HYPaymentViewController.h"
#import "HYDataManager.h"
#import <AlipaySDK/AlipaySDK.h>
#import "UINavigationItem+Margin.h"

@interface HYQuickActive2ViewController ()
<UITableViewDataSource,
UITableViewDelegate,
UITextFieldDelegate,
HYKeyboardHandlerDelegate,
HYPopSelectViewDelegate,
PopDateViewDelegate,
HYCardTypeListViewControllerDelegate,
HYPickerToolViewDelegate>
{
    UIPopoverController *_popController;
}
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) HYCardType *cardInfo;
@property (nonatomic, copy) NSString *birthday;
@property (nonatomic, copy) NSString *sex;
@property (nonatomic, strong) NSString *authCode;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *cardId;
@property (nonatomic, strong) NSString *inviteCode; //unused.
@property (nonatomic, strong) NSString *phone;

@property (nonatomic, strong) UITextField *authField;
@property (nonatomic, strong) UITextField *nameField;
@property (nonatomic, strong) UITextField *cardIdField;
@property (nonatomic, strong) UITextField *inviteField;
@property (nonatomic, strong) UITextField *phoneField;

@property (nonatomic, strong) HYPickerToolView *sexPicker;

@property (nonatomic, strong) HYKeyboardHandler *keyboardHandler;
@property (nonatomic, strong) UIToolbar *keyboardBar;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger timerCount;
@property (nonatomic, strong) UIButton *sendBackBtn;

@property (nonatomic, strong) HYActivateUserRequest *activateRequest;
@property (nonatomic, strong) HYSendCheckRequest *sendCheckRequest;
@property (nonatomic, strong) HYOnlinePurchaseRequest *purchaseRequest;

@end

@implementation HYQuickActive2ViewController

- (void)dealloc
{
    [self.timer invalidate];
    [_activateRequest cancel];
    [_sendCheckRequest cancel];
    [_purchaseRequest cancel];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _cardInfo = [[HYCardType alloc] init];
        _cardInfo.card_id = 1;
        _cardInfo.card_name = @"身份证";
        _sex = @"男";
        _birthday = @"1980-01-01";
    }
    return self;
}

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 538)];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (_activeInfo) {
        self.title = @"填写用户信息";
    } else {
        self.title = @"在线购卡";
    }
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    UIImageView* image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 310, 50)];
    image.image = [UIImage imageNamed:@"person_bank_PA"];
    image.contentMode = UIViewContentModeScaleAspectFit;
    image.center = CGPointMake(160, 25);
    image.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
    [headerView addSubview:image];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 2, 320, 60)];
    UIButton * activateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    activateBtn.frame = CGRectMake(80, 14, 160, 40);
    [activateBtn setBackgroundImage:[UIImage imageNamed:@"btn_orange_normal"]
                           forState:UIControlStateNormal];
    [activateBtn setBackgroundImage:[UIImage imageNamed:@"btn_orange_press"]
                           forState:UIControlStateHighlighted];
    [activateBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    if (self.activeInfo) {
        [activateBtn setTitle:@"立即激活"
                     forState:UIControlStateNormal];
    } else {
        [activateBtn setTitle:@"立即购买"
                     forState:UIControlStateNormal];
    }
    
    activateBtn.titleLabel.font = [UIFont boldSystemFontOfSize:19.0f];
    [activateBtn addTarget:self
                    action:@selector(submitAction:)
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
    
    /*
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        self.keyboardBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 30)];
        UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(keyboardDone:)];
        self.keyboardBar.items = @[space,doneItem];
    }*/
    
    if (self.activeInfo) {
        UIImage *back = [UIImage imageNamed:@"icon_back.png"];
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        [btn setImage:back forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(backItemAction:) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
//        self.navigationItem.leftBarButtonItem = backItem;
        [self.navigationItem setLeftBarButtonItemWithMargin:backItem];
    }
    
    //开始计时
    if (_activeInfo) {
        [self beginTimerCount];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_keyboardHandler startListen];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_keyboardHandler stopListen];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    //这里是一段很坑爹的代码，用于适配ipad的屏
    HYActiveInfoCell *cell = (HYActiveInfoCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    if (cell) {
        CGFloat x = 100 / 320.0 * CGRectGetWidth(self.view.frame);
        CGFloat w = 110 / 320.0 * CGRectGetWidth(self.view.frame);
        cell.valueField.frame = CGRectMake(x, 5, w, 40);
        x = 210 / 320.0 * CGRectGetWidth(self.view.frame);
        _sendBackBtn.frame = CGRectMake(x, 10, 80, 30);
    }
}

#pragma mark - private

- (void)backItemAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)beginTimerCount
{
    self.timerCount = 120;
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    _timer = [NSTimer scheduledTimerWithTimeInterval:1
                                              target:self
                                            selector:@selector(timerAction:)
                                            userInfo:nil
                                             repeats:YES];
    self.sendBackBtn.enabled = NO;
}

- (void)timerAction:(NSTimer *)timer
{
    if (_timerCount > 0)
    {
        _timerCount --;
        //DebugNSLog(@"time %d", _timerCount);
        NSString *title = [NSString stringWithFormat:@"%lds后重发", (long)_timerCount];
        [self.sendBackBtn setTitle:title forState:UIControlStateDisabled];
    }
    else
    {
        [self.timer invalidate];
        _timer = nil;
        [self.sendBackBtn setTitle:@"重新发送" forState:UIControlStateNormal];
        self.sendBackBtn.enabled = YES;
    }
}

- (void)submitAction:(UIButton *)btn
{
    if (_activeInfo)
    {
        [self getActivate];
    } else
    {
        [self onlinePurchase];
    }
}

//重新发送验证码
- (void)getCheck
{
    [self.view endEditing:YES];
    if (_sendCheckRequest) {
        [_sendCheckRequest cancel];
    }
    _sendCheckRequest = [[HYSendCheckRequest alloc] init];
    if (_activeInfo) {
        _sendCheckRequest.phone_mob = _activeInfo.phone_mob;
    } else {
        if (self.phone.length == 0) {
            [UIAlertView showMessage:@"手机号码都不输，发啥验证码呀>_<!"];
            return;
        }
        _sendCheckRequest.phone_mob = self.phone;
    }
    
    
    [self showLoadingView];
    __weak typeof (self) b_self = self;
    [_sendCheckRequest sendReuqest:^(id result, NSError *error)
    {
        [self hideLoadingView];
        if ([result isKindOfClass:[HYSendCheckResponse class]])
        {
            HYSendCheckResponse *response = (HYSendCheckResponse *)result;
            if (response.status == 200)
            {
                [b_self beginTimerCount];
            }
            else
            {
                [UIAlertView showMessage:response.rspDesc];
            }
        }else{
            [UIAlertView showMessage:@"网络出现问题,请稍后再试"];
        }
    }];
}

//验证信息是否正确，返回错误信息
- (NSString *)validateInfo
{
    NSString* str = nil;;
    do
    {
        if ([_phoneField.text length] == 0) {
            str = @"请输入手机号码";
            break;
        }
        if ([_phoneField.text length] != 11 && ![_phoneField.text checkPhoneNumberValid])
        {
            str = @"不正确的手机号码";
            break;
        }
        if ([_authField.text length] != 6)
        {
            str = @"验证码不正确";
            break;
        }
        else if (_nameField.text.length == 0)
        {
            str = @"真实姓名不能为空";
            break;
        }
        else if (_cardIdField.text.length <= 0)
        {
            str = @"证件号码不能为空";
            break;
        }
        else if (self.cardInfo.card_id==1 && ![NSString validateIDCardNumber:_cardIdField.text])
        {
            str = @"身份证号码不正确";
            break;
        }
    } while (0);
    return str;
}

//开始激活
-(void)getActivate
{
    [self.view endEditing:YES];
    
    NSString* str = [self validateInfo];
    if (str)
    {
        [UIAlertView showMessage:str];
        return;
    }
    
    if (_activateRequest) {
        [_activateRequest cancel];
    }
    _activateRequest = [[HYActivateUserRequest alloc] init];
    _activateRequest.agency_id = _activeInfo.agency_id;
    _activateRequest.number = _activeInfo.number;
    _activateRequest.number_password = _activeInfo.password;
    //_activateRequest.number_id = _activeInfo.Activateid;
    _activateRequest.phone_mob = _activeInfo.phone_mob;
    _activateRequest.check_code = _authField.text;
    _activateRequest.real_name = _nameField.text;
    _activateRequest.id_card = _cardIdField.text;
    _activateRequest.cardType = self.cardInfo.card_id;
    
    if (self.cardInfo.card_id != 1)
    {
        _activateRequest.sex = ([self.sex isEqualToString:@"男"]? @"M" : @"F");
        _activateRequest.birthday = self.birthday;
    }
    
    [self showLoadingView];
    __weak typeof (self) b_self = self;
    [_activateRequest sendReuqest:^(id result, NSError *error)
    {
        [self hideLoadingView];
        
        if ([result isKindOfClass:[HYActivateUserReponse class]])
        {
            HYActivateUserReponse *response = (HYActivateUserReponse *)result;
            if (response.status == 200)
            {
                [UIAlertView showMessage:@"会员卡激活成功"];
                [b_self.delegate clearInfo];
                [b_self.navigationController popViewControllerAnimated:YES];
            }
            else
            {
                [UIAlertView showMessage:response.rspDesc];
            }
        }
        else
        {
            [UIAlertView showMessage:@"网络出现问题,请稍后再试"];
        }
    }];
}

- (void)onlinePurchase
{
    
    [self.view endEditing:YES];
    
    NSString* str = [self validateInfo];
    if (str)
    {
        [UIAlertView showMessage:str];
        return;
    }
    if (_purchaseRequest) {
        [_purchaseRequest cancel];
    }
    _purchaseRequest = [[HYOnlinePurchaseRequest alloc] init];
    _purchaseRequest.name = self.name;
    _purchaseRequest.id_card_type = [NSString stringWithFormat:@"%02ld", (long)self.cardInfo.card_id];
    _purchaseRequest.id_card_num = self.cardId;
    _purchaseRequest.sex = [self.sex isEqualToString:@"男"] ? @"M":@"F";
    _purchaseRequest.birthday = self.birthday;
    _purchaseRequest.phone = self.phone;
    _purchaseRequest.phone_code = self.authCode;
    _purchaseRequest.invitation_code = [HYDataManager sharedManager].inviteCode;
    
    [self showLoadingView];
    __weak typeof(self) b_self = self;
    [_purchaseRequest sendReuqest:^(id result, NSError *error)
    {
        [b_self hideLoadingView];
        if ([result isKindOfClass:[HYOnlinePurchaseResponse class]])
        {
            HYOnlinePurchaseResponse *rs = (HYOnlinePurchaseResponse *)result;
            if (rs.status == 200)
            {
                HYAlipayOrder *alOrder = [[HYAlipayOrder alloc] init];
                alOrder.partner = PartnerID;
                alOrder.seller = SellerID;
                alOrder.tradeNO = rs.order_no; //订单号 (显示订单号)
                alOrder.productName = rs.order_name; //商品标题 (显示订单号)
                alOrder.productDescription = [NSString stringWithFormat:@"【特奢汇】在线购卡: %@", rs.order_no]; //商品描述
                alOrder.amount = [NSString stringWithFormat:@"%0.2f", rs.pay_total.floatValue]; //商品价格
                
                HYPaymentViewController* payVC = [[HYPaymentViewController alloc]init];
                payVC.alipayOrder = alOrder;
                payVC.amountMoney = [rs.pay_total floatValue];
                payVC.orderID = rs.order_id;
                payVC.orderNO = rs.order_no;
                payVC.type = Pay_BuyCard;
                
                [self.navigationController pushViewController:payVC animated:YES];
            }
            else
            {
                [UIAlertView showMessage:rs.rspDesc];
            }
        }
        else
        {
            [UIAlertView showMessage:@"网络出现问题,请稍后再试"];
        }
    }];
    
    
}

- (void)clearInfo
{
    _phoneField.text = nil;
    _phone = nil;
    
    _authField.text = nil;
    _authCode = nil;
    
    _nameField.text = nil;
    _name = nil;
    
    _cardInfo = [[HYCardType alloc] init];
    _cardInfo.card_id = 1;
    _cardInfo.card_name = @"身份证";
    _sex = @"男";
    _birthday = @"1980-01-01";
    
    _cardIdField.text = nil;
    _cardId = nil;
    
    [_timer invalidate];
    _sendBackBtn.enabled = YES;
    if (_activeInfo)
    {
        [_sendBackBtn setTitle:@"重新发送" forState:UIControlStateNormal];
    }
    else
    {
        [_sendBackBtn setTitle:@"重新发送" forState:UIControlStateNormal];
    }
    [_tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - table data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = 0;
    if (self.cardInfo.card_id == 1)
    {
        count = 5;
    }
    else
    {
        count = 7;
    }
    if (!_activeInfo) {
        count += 1;
    }
    return count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *fieldCell = @"fieldCell";
    static NSString *selectCell = @"selectCell";
    NSInteger idx = indexPath.row;
    if (!_activeInfo)
    {
        if (self.cardInfo.card_id == 1)
        {
            if (idx == 5) {
                idx = 7;
            }
        }
    }
    switch (idx)
    {
        case 0:
        {
            //电话号码，120秒后重发
            static NSString *authcodeCellId = @"phoneCell";
            HYActiveInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:authcodeCellId];
            if (cell == nil)
            {
                cell = [[HYActiveInfoCell alloc]initWithStyle:UITableViewCellStyleDefault
                                            reuseIdentifier:authcodeCellId];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                cell.valueField.autoresizingMask = UIViewAutoresizingNone;
                
                UIButton *sendCheck = [[UIButton alloc] initWithFrame:CGRectMake(0, 10, 0, 30)];
                sendCheck.tag = 100;
                [sendCheck setBackgroundImage:[UIImage imageNamed:@"btn_orange_normal"]
                                     forState:UIControlStateNormal];
                [sendCheck setBackgroundImage:[UIImage imageNamed:@"btn_orange_press"]
                                     forState:UIControlStateHighlighted];
                [sendCheck setTitleColor:[UIColor whiteColor]
                                forState:UIControlStateNormal];
                [sendCheck.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0f]];
                [sendCheck setTitle:@"发送验证码" forState:UIControlStateNormal];
                [sendCheck addTarget:self
                              action:@selector(getCheck)
                    forControlEvents:UIControlEventTouchUpInside ];
                sendCheck.tag = 100;
                sendCheck.enabled = _activeInfo ? NO : YES;
                [cell.contentView addSubview:sendCheck];
                self.sendBackBtn = sendCheck;
                cell.textLabel.text = @"手机号码";
                cell.valueField.enabled = _activeInfo ? NO : YES;
                cell.valueField.text = _activeInfo ? _activeInfo.phone_mob : _phone;
                cell.valueField.inputAccessoryView = self.keyboardBar;
                cell.valueField.delegate = self;
                cell.valueField.placeholder = @"您的手机号码";
                self.phoneField = cell.valueField;
            }
            cell.valueField.text = _activeInfo ? _activeInfo.phone_mob : _phone;
            return cell;
        }
            break;
        case 1:
        {
            HYActiveInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:fieldCell];
            if (cell == nil)
            {
                cell = [[HYActiveInfoCell alloc]initWithStyle:UITableViewCellStyleDefault
                                            reuseIdentifier:fieldCell];
                cell.valueField.inputAccessoryView = self.keyboardBar;
            }
            cell.valueField.text = _authCode;
            cell.textLabel.text = @"验证码";
            self.authField = cell.valueField;
            cell.valueField.delegate = self;
            cell.valueField.placeholder = @"手机收到的验证码";
            return cell;
        }
            break;
        case 2:
        {
            HYActiveInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:fieldCell];
            if (cell == nil)
            {
                cell = [[HYActiveInfoCell alloc]initWithStyle:UITableViewCellStyleDefault
                        
                                              reuseIdentifier:fieldCell];
                cell.valueField.inputAccessoryView = self.keyboardBar;
                cell.valueField.delegate = self;
            }
            cell.valueField.text = self.name;
            cell.textLabel.text = @"真实姓名";
            self.nameField = cell.valueField;
            cell.valueField.placeholder = @"您的真实姓名";
            return cell;
        }
            break;
        case 3:
        {
            HYActiveInfoSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:selectCell];
            if (!cell)
            {
                cell = [[HYActiveInfoSelectCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                     reuseIdentifier:selectCell];
            }
            cell.textLabel.text = @"证件类型";
            cell.valueLabel.text = self.cardInfo.card_name;
            return cell;
        }
            break;
        case 4:
        {
            HYActiveInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:fieldCell];
            if (cell == nil)
            {
                cell = [[HYActiveInfoCell alloc]initWithStyle:UITableViewCellStyleDefault
                        
                                              reuseIdentifier:fieldCell];
                cell.valueField.inputAccessoryView = self.keyboardBar;
                cell.valueField.delegate = self;
            }
            cell.valueField.text = self.cardId;
            cell.valueField.placeholder = @"请使用有效证件购买平安保险";
            cell.textLabel.text = @"证件号码";
            self.cardIdField = cell.valueField;
            return cell;
        }
            break;
        case 5:
        {
            HYActiveInfoSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:selectCell];
            if (!cell)
            {
                cell = [[HYActiveInfoSelectCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                     reuseIdentifier:selectCell];
            }
            cell.textLabel.text = @"性别";
            cell.valueLabel.text = self.sex;
            return cell;
        }
            break;
        case 6:
        {
            HYActiveInfoSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:selectCell];
            if (!cell)
            {
                cell = [[HYActiveInfoSelectCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                     reuseIdentifier:selectCell];
            }
            cell.textLabel.text = @"出生日期";
            cell.valueLabel.text = self.birthday;
            return cell;
        }
            break;
        case 7:
        {
            static NSString *inviteCell = @"inviteCell";
            HYActiveInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:inviteCell];
            if (cell == nil)
            {
                cell = [[HYActiveInfoCell alloc]initWithStyle:UITableViewCellStyleDefault
                        
                                              reuseIdentifier:inviteCell];
                cell.valueField.inputAccessoryView = self.keyboardBar;
                cell.valueField.delegate = self;
                cell.valueField.placeholder = @"您的邀请码";
                cell.textLabel.text = @"邀请码";
                self.inviteField = cell.valueField;
                cell.valueField.text = [HYDataManager sharedManager].inviteCode;
                cell.valueField.enabled = NO;
            }
            
            return cell;
        }
            break;
        default:
            break;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 3)
    {
        HYCardTypeListViewController *vc = [[HYCardTypeListViewController alloc] init];
        vc.title = @"选择证件类型";
        vc.delegate = self;
        vc.type = UseForBuyInsourance;
        [self.navigationController pushViewController:vc
                                             animated:YES];
    }
    //性别
    if (indexPath.row == 5 && _cardInfo.card_id != 1)
    {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            if (!self.sexPicker)
            {
                self.sexPicker = [[HYPickerToolView alloc] initWithFrame:CGRectMake(0, 0, 320, 260)];
                self.sexPicker.delegate = self;
                self.sexPicker.dataSouce = @[@"男", @"女"];
                self.sexPicker.title = @"选择性别";
            }
            [self.sexPicker showWithAnimation:YES];
        }
        else
        {
            HYActiveInfoSelectCell *cell = (HYActiveInfoSelectCell*)[self.tableView cellForRowAtIndexPath:indexPath];
            if (cell)
            {
                CGRect frame = cell.valueLabel.frame;
                frame.size.width = 100;
                frame = [cell.contentView convertRect:frame toView:self.view];
                HYPopSelectViewController *pop = [[HYPopSelectViewController alloc] init];
                pop.delegate = self;
                pop.dataArray = @[@"男", @"女"];
                pop.title = @"选择性别";
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:pop];
                nav.contentSizeForViewInPopover = CGSizeMake(320, 240);
                _popController = [[UIPopoverController alloc] initWithContentViewController:nav];
                [_popController presentPopoverFromRect:frame
                                                inView:self.view
                              permittedArrowDirections:UIPopoverArrowDirectionLeft
                                              animated:YES];
            }
        }
    }
    //出生日期
    if (indexPath.row == 6)
    {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            HYActiveInfoSelectCell *cell = (HYActiveInfoSelectCell*)[self.tableView cellForRowAtIndexPath:indexPath];
            if (cell)
            {
                CGRect frame = cell.valueLabel.frame;
                frame.size.width = 100;
                frame = [cell.contentView convertRect:frame toView:self.view];
                HYPopDateViewController *pop = [[HYPopDateViewController alloc] init];
                pop.delegate = self;
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:pop];
                nav.contentSizeForViewInPopover = CGSizeMake(320, 240);
                _popController = [[UIPopoverController alloc] initWithContentViewController:nav];
                [_popController presentPopoverFromRect:frame
                                                inView:self.view
                              permittedArrowDirections:UIPopoverArrowDirectionLeft
                                              animated:YES];
            }
        }
        else
        {
            DatePickerViewController *datePicker = [[DatePickerViewController alloc] init];
            __weak typeof(self) b_self = self;
            [self showDatePickerViewController:datePicker withCompletionHandler:^(NSDate *date) {
                [b_self handleGetDate:date];
            }];
        }
    }
}

#pragma mark - textField
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

//UIKIT_STATIC_INLINE void rowPlus(UIScrollView *v, int row)
//{
//    CGPoint offset = v.contentOffset;
//    offset.y += row * 50;
//    [v setContentOffset:offset animated:YES];
//}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    /*
    if (textField == self.phoneField) {
        rowPlus(_tableView, 1);
        [self.authField becomeFirstResponder];
    }
    if (textField == self.authField)
    {
        rowPlus(_tableView, 1);
        [self.nameField becomeFirstResponder];
    }
    if (textField == self.nameField)
    {
        rowPlus(_tableView, 2);
        [self.cardIdField becomeFirstResponder];
    }
    if (textField == self.cardIdField)
    {
        [textField resignFirstResponder];
    }*/
    [textField resignFirstResponder];
    return YES;
}

#define bindTextField(textField, varField, var) \
    if (textField == varField) { \
        var = textField.text;   \
    }

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    bindTextField(textField, _phoneField, _phone)
    bindTextField(textField, _authField, _authCode)
    bindTextField(textField, _nameField, _name)
    bindTextField(textField, _cardIdField, _cardId)
    bindTextField(textField, _inviteField, _inviteCode)
}

#pragma mark - HYCardTypeListViewControllerDelegate
- (void)didSelectCardtype:(HYCardType *)card
{
    self.cardInfo = card;
    [self.tableView reloadData];
}

#pragma mark - HYPickerToolViewDelegate
- (void)selectComplete:(HYPickerToolView *)pickerView
{
    switch (pickerView.currentIndex)
    {
        case 0:
            self.sex = @"男";
            break;
        case 1:
            self.sex = @"女";
            break;
        default:
            break;
    }
    
    [self.tableView reloadData];
}

#pragma mark - 
- (void)popSelectView:(HYPopSelectViewController *)select
       didSelectIndex:(NSInteger)selectIdx
         andGetString:(NSString *)getString
{
    [_popController dismissPopoverAnimated:YES];
    if (selectIdx == 0)
    {
        self.sex = @"男";
    } else if (selectIdx == 1)
    {
        self.sex = @"女";
    }
    [self.tableView reloadData];
}
- (void)cancelSelectPop:(HYPopSelectViewController *)popSelect
{
    [_popController dismissPopoverAnimated:YES];
}

#pragma mark - date
- (void)popDateViewDidGetDate:(NSDate *)date
{
    [_popController dismissPopoverAnimated:YES];
    [self handleGetDate:date];
}

- (void)handleGetDate:(NSDate *)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [calendar components:NSYearCalendarUnit|
                               NSMonthCalendarUnit|
                               NSDayCalendarUnit|
                               NSHourCalendarUnit|
                               NSMinuteCalendarUnit|
                               NSSecondCalendarUnit fromDate:date];
    comps.hour = 0;
    comps.minute = 0;
    comps.second = 0;
    NSDate *getDate = [calendar dateFromComponents:comps];
    self.birthday = [getDate timeDescription];
    [self.tableView reloadData];
}

- (void)popDateViewDidClickCancel
{
    [_popController dismissPopoverAnimated:YES];
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
