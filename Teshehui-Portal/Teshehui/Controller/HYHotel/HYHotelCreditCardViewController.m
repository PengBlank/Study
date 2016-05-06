//
//  HYHotelCreditCardViewController.m
//  Teshehui
//
//  Created by 回亿资本 on 14-2-20.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYHotelCreditCardViewController.h"
#import "HYCreditCardInfo.h"
#import "HYHotelFillCredCardCell.h"
#import "HYBankHelpInfoViewController.h"
#import "HYHotelListViewController.h"
#import "HYUserInfo.h"
#import "HYHotelOrderRequest.h"
#import "HYHotelOrderResponse.h"
#import "HYBaseLineCell.h"
#import "METoast.h"
#import "HYLoadHubView.h"
#import "NSString+Addition.h"
#import "HYMonthPickerView.h"
#import "HYPaymentViewController.h"
#import "NSDate+Addition.h"

@interface HYHotelCreditCardViewController ()
<
UITextFieldDelegate,
UIAlertViewDelegate,
HYMonthPickerViewDelegate
>
{
    HYHotelOrderRequest *_orderRequest;
    BOOL _isLoading;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) HYCreditCardInfo *creditInfo;
@property (nonatomic, strong) HYMonthPickerView *datePicker;

@property (nonatomic, copy) NSString *cardNumber;
@property (nonatomic, copy) NSString *cardLastNumber;
@property (nonatomic, copy) NSString *cardUserName;
@property (nonatomic, copy) NSString *cardCode;
@property (nonatomic, copy) NSString *cardValidDate;
@property (nonatomic, copy) NSString *holderMobile;
@property (nonatomic, copy) NSString *IDCards;

@end

@implementation HYHotelCreditCardViewController

- (void)dealloc
{
    [_orderRequest cancel];
    _orderRequest = nil;
    
    [_datePicker dismissWithAnimation:YES];
    [HYLoadHubView dismiss];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView
{
    CGRect frame = [[UIScreen mainScreen] bounds];
    frame.size.height -= 64.0;
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor whiteColor];
    self.view = view;
    
    //tableview
    UITableView *tableview = [[UITableView alloc] initWithFrame:frame
                                                          style:UITableViewStylePlain];
	tableview.delegate = self;
	tableview.dataSource = self;
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIView *v= [[UIView alloc] initWithFrame:CGRectZero];
    tableview.tableHeaderView = v;
    tableview.sectionFooterHeight = 10;
    
    //line
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), 10)];
    tableview.tableHeaderView = headerView;
    
    [self.view addSubview:tableview];
	self.tableView = tableview;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title = @"担保";
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 80)];
    UILabel *plabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 32, 14, 20)];
    plabel.font = [UIFont systemFontOfSize:14];
    plabel.textColor = [UIColor colorWithRed:250.0/255.0
                                       green:113.0/255.0
                                        blue:17.0/255.0
                                       alpha:1.0];
    plabel.text = @"￥";
    [footerView addSubview:plabel];
    
    UILabel *_priceLab = [[UILabel alloc] initWithFrame:CGRectMake(36, 30, 120, 20)];
    _priceLab.font = [UIFont systemFontOfSize:20];
    _priceLab.textColor = [UIColor colorWithRed:250.0/255.0
                                          green:113.0/255.0
                                           blue:17.0/255.0
                                          alpha:1.0];
    _priceLab.text = [NSString stringWithFormat:@"%@", @(self.price)];
    [footerView addSubview:_priceLab];
    
    UIButton *_orderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat orderWidth = CGRectGetWidth(self.view.frame)*0.4;
    _orderBtn.frame = CGRectMake((CGRectGetWidth(self.view.frame)-orderWidth)/2, 17, orderWidth, 45);
    UIImage *nImage = [[UIImage imageNamed:@"btn_price"] stretchableImageWithLeftCapWidth:2
                                                                           topCapHeight:0];
    UIImage *pImage = [[UIImage imageNamed:@"btn_paypress"] stretchableImageWithLeftCapWidth:2
                                                                                topCapHeight:0];
    UIImage *image = [UIImage imageNamed:@"ico_common_safety"];
    [_orderBtn setBackgroundImage:nImage forState:UIControlStateNormal];
    [_orderBtn setBackgroundImage:pImage forState:UIControlStateHighlighted];
    [_orderBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [_orderBtn setTitle:NSLocalizedString(@"guarantee", nil)
               forState:UIControlStateNormal];
    [_orderBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_orderBtn setImage:image forState:UIControlStateNormal];
//    [_orderBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 40, 0, 50)];
//    [_orderBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 50, 0, 40)];
    [_orderBtn addTarget:self
                  action:@selector(hotelGuarantee:)
        forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:_orderBtn];
    
    self.tableView.tableFooterView = footerView;
    
    HYUserInfo *user = [HYUserInfo getUserInfo];
    self.holderMobile = user.mobilePhone;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    if (!self.view.window)
    {
        [_tableView removeFromSuperview];
        self.tableView = nil;
        self.view = nil;
    }
}

#pragma mark - private methods
- (void)hotelGuarantee:(id)sender
{
    if (!_isLoading)
    {
        [self.view endEditing:YES];
        
        NSString *errorInfo = nil;
        NSString *bank = self.creditInfo.bankId;
        NSString *cardDate = nil;
        if (!bank)
        {
            errorInfo = @"请选择信用卡发卡行";
        }
        
        if (!errorInfo)
        {
            if (!self.cardNumber)
            {
                errorInfo = @"请填写信用卡卡号";
            }
        }
        
        if (!errorInfo)
        {
            cardDate = [self.cardValidDate stringByReplacingOccurrencesOfString:@"/" withString:@""];
            
            if (!cardDate)
            {
                errorInfo = @"请填写信用卡有效期";
            }
        }
        
        if (!errorInfo)
        {
            if (!self.cardCode)
            {
                errorInfo = @"请填写信用卡后三位";
            }
        }
        
        if (!errorInfo)
        {
            if (!self.cardUserName)
            {
                errorInfo = @"请填写持卡人姓名";
            }
        }
        
        if (!errorInfo)
        {
            if (![NSString validateIDCardNumber:self.IDCards])
            {
                errorInfo = @"请填写持卡人有效身份证号";
            }
        }
        
        if (!errorInfo)
        {
            _orderRequest = [[HYHotelOrderRequest alloc] init];
            
            _isLoading = YES;
            [HYLoadHubView show];
            
            HYUserInfo* userInfo = [HYUserInfo getUserInfo];
            _orderRequest.userId = userInfo.userId;
            _orderRequest.price = self.roomInfo.price;
            _orderRequest.quantity = self.quantity;
            _orderRequest.startTimeSpan = self.checkInDate;
            _orderRequest.endTimeSpan = self.checkOutDate;
            _orderRequest.latestArrivalTime = self.lastArrivalTime;
            _orderRequest.contactName = self.contact;
            _orderRequest.contactPhone = self.phoneNumber;
//            _orderRequest.contactEmail = self.contact;
            _orderRequest.productSKUCode = self.roomInfo.productSKUId;
            _orderRequest.latestArrivalTime = self.lastArrivalTime;
            _orderRequest.guestPOList = self.hotelGuest;
            _orderRequest.remark = self.spacialContent;

            if (self.spendPattern == Enterprise_SP)
            {
                _orderRequest.isEnterprise = userInfo.enterpriseId;
            }
            
            //担保信息
            _orderRequest.creditCardType = [bank encryptUseDESKey:kDESKey];
            _orderRequest.creditCardHolderMobile = [self.phoneNumber encryptUseDESKey:kDESKey];
            _orderRequest.creditCardNumber = [self.cardNumber encryptUseDESKey:kDESKey];
            _orderRequest.creditCardSeriesCode = [self.cardCode encryptUseDESKey:kDESKey];
            _orderRequest.creditCardHolderName = [self.cardUserName encryptUseDESKey:kDESKey];
            _orderRequest.creditCardEffectiveDate = [cardDate encryptUseDESKey:kDESKey];
            _orderRequest.creditCardHolderIDCardNumber = [self.IDCards encryptUseDESKey:kDESKey];

            __weak typeof(self) b_self = self;
            [_orderRequest sendReuqest:^(id result, NSError *error) {
                HYHotelOrderBase *order = nil;
                if (!error && [result isKindOfClass:[HYHotelOrderResponse class]])
                {
                    HYHotelOrderResponse *response = (HYHotelOrderResponse *)result;
                    order = response.orders[0];
                }
                
                [b_self guaranteeFinisthed:order error:error];
            }];
        }
        else
        {
            [METoast toastWithMessage:errorInfo];
        }
    }
}

- (void)guaranteeFinisthed:(HYHotelOrderBase *)order error:(NSError *)error
{
    _isLoading = NO;
    [HYLoadHubView dismiss];
    
    if (error)
    {
        NSString *msg = error.domain;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:msg
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"知道了", nil];
        [alert show];
    }
    else
    {
        NSString *msg = [NSString stringWithFormat:@"订单成功：您可以在酒店订单中查看。"];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:msg
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"知道了", nil];
        [alert show];
    }
}

- (void)checkInfo:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    
    BankHelpType type = CardValidDate;
    if (btn.tag == 3)
    {
        type = CardNumberLast;
    }
    
    HYBankHelpInfoViewController *vc = [[HYBankHelpInfoViewController alloc] init];
    vc.type = type;
    vc.navbarTheme = self.navbarTheme;
    [self.navigationController pushViewController:vc
                                         animated:YES];
}

- (void)selectCardVaildDate
{
    if (!_datePicker)
    {
        _datePicker = [[HYMonthPickerView alloc] init];
        _datePicker.title = @"选择有效日期";
        _datePicker.delegate = self;
    }
    _datePicker.pickerView.date = [NSDate date];
    [_datePicker showWithAnimation:YES];
}

#pragma mark - HYMonthPickerViewDelegate
- (void)didSelectDate:(NSDate *)date
{
    self.cardValidDate = [date toStringWithFormat:@"MM/yy"];
    [self.tableView reloadData];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSArray *vcs = [self.navigationController viewControllers];
    
    UIViewController *list = nil;
    for (UIViewController *vc in vcs)
    {
        if ([vc isKindOfClass:[HYHotelListViewController class]])
        {
            list = vc;
            break;
        }
    }
    
    if (list)
    {
        [self.navigationController popToViewController:list
                                              animated:YES];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

#pragma mark - HYBankViewControllerDelegate
- (void)didSelectBankInfo:(HYCreditCardInfo *)bankInfo
{
    self.creditInfo = bankInfo;
    [self.tableView reloadData];
}

#pragma mark - Table view data source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 44.0f;
    return height;
}

- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger totalRow = [tableView numberOfRowsInSection:indexPath.section];//first get total rows in that section by current indexPath.
    if(indexPath.row == totalRow -1){
        //this is the last row in section.
        HYBaseLineCell *lineCell = (HYBaseLineCell *)cell;
        lineCell.separatorLeftInset = 0.0f;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        static NSString *CellId1 = @"CellId1";
        HYBaseLineCell *cell = [tableView dequeueReusableCellWithIdentifier:CellId1];
        if (cell == nil)
        {
            cell = [[HYBaseLineCell alloc]initWithStyle:UITableViewCellStyleValue1
                                                 reuseIdentifier:CellId1];
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = NSLocalizedString(@"bank_info", nil);
            cell.textLabel.font = [UIFont systemFontOfSize:15];
            cell.textLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
            cell.textLabel.backgroundColor = [UIColor clearColor];
        }
        
        cell.detailTextLabel.text = self.creditInfo.bankName;
        
        return cell;
    }
    else
    {
        static NSString *CellId2 = @"CellId2";
        HYHotelFillCredCardCell *cell = [tableView dequeueReusableCellWithIdentifier:CellId2];
        if (cell == nil)
        {
            cell = [[HYHotelFillCredCardCell alloc]initWithStyle:UITableViewCellStyleDefault
                                                 reuseIdentifier:CellId2];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textField.delegate = self;
            [cell.infoBtn addTarget:self
                             action:@selector(checkInfo:)
                   forControlEvents:UIControlEventTouchUpInside];
        }
        
        cell.textField.tag = indexPath.row;
        
        switch (indexPath.row)
        {
            case 1:
            {
                cell.textField.placeholder = nil;
                cell.textField.keyboardType = UIKeyboardTypeNumberPad;
                [cell.textField setEnabled:YES];
                cell.textField.autoSpace = YES;
                cell.textField.frame = CGRectMake(110, 12, CGRectGetWidth(self.view.frame)-130, 20);
                cell.textField.text = self.cardNumber;
                cell.textLabel.text = @"卡号";
                [cell.infoBtn setHidden:YES];
            }
                break;
            case 2:
            {
                cell.textField.placeholder = @"月/年";
                cell.textField.keyboardType = UIKeyboardTypeNumberPad;
                [cell.textField setEnabled:NO];
                cell.textField.autoSpace = NO;
                cell.textField.frame = CGRectMake(110, 12, CGRectGetWidth(self.view.frame)-160, 20);
                cell.textField.text = self.cardValidDate;
                cell.textLabel.text = @"卡有效期";
                cell.infoBtn.tag = indexPath.row;
                [cell.infoBtn setHidden:NO];
            }
                break;
            case 3:
            {
                cell.textField.placeholder = @"签名栏末尾处最后3位";
                cell.textField.keyboardType = UIKeyboardTypeNumberPad;
                [cell.textField setEnabled:YES];
                cell.textField.autoSpace = NO;
                cell.textField.frame = CGRectMake(110, 12, CGRectGetWidth(self.view.frame)-160, 20);
                cell.textField.text = self.cardCode;
                cell.textLabel.text = @"信用卡验证码";
                cell.infoBtn.tag = indexPath.row;
                [cell.infoBtn setHidden:NO];
            }
                break;
            case 4:
            {
                cell.textField.placeholder = nil;
                cell.textField.keyboardType = UIKeyboardTypeDefault;
                cell.textField.returnKeyType = UIReturnKeyNext;
                [cell.textField setEnabled:YES];
                cell.textField.autoSpace = NO;
                cell.textField.frame = CGRectMake(110, 12, CGRectGetWidth(self.view.frame)-130, 20);
                cell.textField.text = self.cardUserName;
                cell.textLabel.text = @"持卡人姓名";
                [cell.infoBtn setHidden:YES];
            }
                break;
            case 5:
            {
                cell.textField.placeholder = @"请输入持卡人手机号码";
                cell.textField.keyboardType = UIKeyboardTypePhonePad;
                cell.textField.returnKeyType = UIReturnKeyNext;
                [cell.textField setEnabled:YES];
                cell.textField.autoSpace = YES;
                cell.textField.frame = CGRectMake(110, 12, CGRectGetWidth(self.view.frame)-130, 20);
                cell.textField.text = self.holderMobile;
                cell.textLabel.text = @"手机号码";
                [cell.infoBtn setHidden:YES];
            }
                break;
            case 6:
            {
                cell.textField.placeholder = nil;
                cell.textField.keyboardType = UIKeyboardTypeDefault;
                cell.textField.returnKeyType = UIReturnKeyDone;
                [cell.textField setEnabled:YES];
                cell.textField.autoSpace = NO;
                cell.textField.frame = CGRectMake(110, 12, CGRectGetWidth(self.view.frame)-130, 20);
                cell.textField.text = self.IDCards;
                cell.textLabel.text = @"身份证号码";
                [cell.infoBtn setHidden:YES];
            }
                break;
                
            default:
                break;
        }
        
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0)
    {
        HYBankViewController *vc = [[HYBankViewController alloc] init];
        vc.delegate = self;
        vc.navbarTheme = self.navbarTheme;
        [self.navigationController pushViewController:vc
                                             animated:YES];
    }
    else if (indexPath.row == 2)
    {
        [self.view endEditing:YES];
        [self selectCardVaildDate];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.dragging)
    {
        [self.view endEditing:YES];
    }
}


#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    if (textField.returnKeyType == UIReturnKeyNext)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(textField.tag+1) inSection:0];
        HYHotelFillCredCardCell *cell = (HYHotelFillCredCardCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        if (cell)
        {
            [cell.textField becomeFirstResponder];
        }
    }
    else if (textField.returnKeyType == UIReturnKeyDone)
    {
        [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    switch (textField.tag)
    {
        case 1:
            [self.tableView setContentOffset:CGPointMake(0, 10) animated:YES];
            break;
        case 2:
            [self.tableView setContentOffset:CGPointMake(0, 50) animated:YES];
            break;
        case 3:
            [self.tableView setContentOffset:CGPointMake(0, 90) animated:YES];
            break;
        case 4:
            [self.tableView setContentOffset:CGPointMake(0, 130) animated:YES];
            break;
        case 5:
            [self.tableView setContentOffset:CGPointMake(0, 180) animated:YES];
            break;
        case 6:
            [self.tableView setContentOffset:CGPointMake(0, 200) animated:YES];
            break;
        default:
            break;
    }
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    switch (textField.tag)
    {
        case 1:
            self.cardNumber = [textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
            break;
        case 2:
            self.cardValidDate = textField.text;
            break;
        case 3:
            self.cardCode = textField.text;
            break;
        case 4:
            self.cardUserName = textField.text;
            break;
        case 5:
            self.holderMobile = textField.text;
            break;
        case 6:
            self.IDCards = textField.text;
            break;
        default:
            break;
    }
}
@end
