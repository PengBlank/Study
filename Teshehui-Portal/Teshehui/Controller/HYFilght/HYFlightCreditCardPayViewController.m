//
//  HYFlightCreditCardPayViewController.m
//  Teshehui
//
//  Created by HYZB on 14-8-20.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYFlightCreditCardPayViewController.h"
#import "HYCreditCardInfo.h"
#import "HYBankHelpInfoViewController.h"
#import "HYCardTypeListViewController.h"
#import "HYBaseLineCell.h"
#import "HYHotelFillCredCardCell.h"
#import "METoast.h"
#import "HYLoadHubView.h"
#import "HYUserInfo.h"
#import "HYFlightOrderRequest.h"
#import "NSString+Addition.h"
#import "HYFlightCabinListViewController.h"
#import "HYMonthPickerView.h"
#import "NSDate+Addition.h"

@interface HYFlightCreditCardPayViewController ()
<
UITextFieldDelegate,
HYCardTypeListViewControllerDelegate,
HYMonthPickerViewDelegate
>
{
    BOOL _isLoading;
    HYFlightOrderRequest *_orderReq;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) HYCreditCardInfo *creditInfo;
@property (nonatomic, strong) HYCardType *cardInfo;

@property (nonatomic, strong) HYMonthPickerView *datePicker;

@property (nonatomic, copy) NSString *cardNumber;
@property (nonatomic, copy) NSString *cardLastNumber;
@property (nonatomic, copy) NSString *cardUserName;
@property (nonatomic, copy) NSString *cardCode;
@property (nonatomic, copy) NSString *cardValidDate;
@property (nonatomic, copy) NSString *IDCards;

@end

@implementation HYFlightCreditCardPayViewController

- (void)dealloc
{
    [HYLoadHubView dismiss];
    
    [_orderReq cancel];
    _orderReq = nil;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _cardInfo = [[HYCardType alloc] init];
        _cardInfo.certifacateCode = @"01";
        _cardInfo.certifacateName = @"身份证";
    }
    return self;
}

- (void)loadView
{
    CGRect frame = [[UIScreen mainScreen] bounds];
    frame.size.height -= 64.0;
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor colorWithRed:223.0f/255.0f
                                           green:222.0f/255.0f
                                            blue:228.0f/255.0f
                                           alpha:1.0];
    self.view = view;
    
    //tableview
    UITableView *tableview = [[UITableView alloc] initWithFrame:frame
                                                          style:UITableViewStylePlain];
	tableview.delegate = self;
	tableview.dataSource = self;
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableview.backgroundColor = self.view.backgroundColor;
    
    UIView *v= [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    v.backgroundColor = self.view.backgroundColor;

    UILabel *descLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 300, 30)];
    descLabel.backgroundColor = [UIColor clearColor];
    descLabel.textColor = [UIColor grayColor];
    descLabel.font = [UIFont systemFontOfSize:14];
    descLabel.lineBreakMode = NSLineBreakByCharWrapping;
    descLabel.numberOfLines = 10;
    descLabel.text = @"＊该支付由携程提供，出票情况以携程通知为准";
    [v addSubview:descLabel];
    
    //line
    UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 29, 320, 1.0)];
    lineView.image = [[UIImage imageNamed:@"line_cell_bottom"] stretchableImageWithLeftCapWidth:2
                                                                                   topCapHeight:0];
    [v addSubview:lineView];
    
    tableview.tableHeaderView = v;
    
    [self.view addSubview:tableview];
	self.tableView = tableview;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title = @"支付";
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 80)];
    footerView.backgroundColor = self.view.backgroundColor;
    
    UILabel *plabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 30, 14, 20)];
    plabel.backgroundColor = [UIColor clearColor];
    plabel.font = [UIFont systemFontOfSize:14];
    plabel.textColor = [UIColor colorWithRed:250.0/255.0
                                       green:113.0/255.0
                                        blue:17.0/255.0
                                       alpha:1.0];
    plabel.text = @"￥";
    [footerView addSubview:plabel];
    
    UILabel *_priceLab = [[UILabel alloc] initWithFrame:CGRectMake(40, 30, 120, 20)];
    _priceLab.backgroundColor = [UIColor clearColor];
    _priceLab.font = [UIFont systemFontOfSize:18];
    _priceLab.textColor = [UIColor colorWithRed:250.0/255.0
                                          green:113.0/255.0
                                           blue:17.0/255.0
                                          alpha:1.0];
    _priceLab.text = [NSString stringWithFormat:@"%.02f", self.totalPrice];
    [footerView addSubview:_priceLab];
    
    UIButton *_orderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _orderBtn.frame = CGRectMake(140, 17, 160, 45);
    UIImage *nImage = [[UIImage imageNamed:@"btn_price"] stretchableImageWithLeftCapWidth:2
                                                                             topCapHeight:0];
    UIImage *pImage = [[UIImage imageNamed:@"btn_paypress"] stretchableImageWithLeftCapWidth:2
                                                                                topCapHeight:0];
    UIImage *image = [UIImage imageNamed:@"ico_common_safety"];
    [_orderBtn setBackgroundImage:nImage forState:UIControlStateNormal];
    [_orderBtn setBackgroundImage:pImage forState:UIControlStateHighlighted];
    [_orderBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [_orderBtn setTitle:@"支付"
               forState:UIControlStateNormal];
    [_orderBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_orderBtn setImage:image forState:UIControlStateNormal];
    [_orderBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 40, 0, 50)];
    [_orderBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 50, 0, 40)];
    [_orderBtn addTarget:self
                  action:@selector(creatitCradPayment:)
        forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:_orderBtn];
    
    self.tableView.tableFooterView = footerView;
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
- (void)creatitCradPayment:(id)sender
{
    if (!_isLoading)
    {
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
            if (!self.IDCards)
            {
                errorInfo = @"请填写持卡人身份证号";
            }
        }
        
        if (!errorInfo)
        {
            _isLoading = YES;
            [HYLoadHubView show];
            
            _orderReq = [[HYFlightOrderRequest alloc] init];
            _orderReq.contactPhone = self.phoneNumber;
            _orderReq.guestItems = self.passengers;
            _orderReq.cabin = self.cabin;
            _orderReq.flight = self.flight;
            
            HYUserInfo *user = [HYUserInfo getUserInfo];
            
            if (self.spendPattern == Enterprise_SP)
            {
                _orderReq.isEnterprise = user.enterpriseId;
            }
            BOOL needInvoice = ([self.invoiceAdds.consignee length]>0);
            if (needInvoice)
            {
                _orderReq.isNeenJourney = YES;
                _orderReq.userAddressId = self.invoiceAdds.addr_id;
            }
            
            /*
             NSString *card_number;  //信用卡卡号：使用信用卡加密
             NSString *card_number_pre;  //卡号前六位数：使用信用卡加密
             NSString *card_type;  //信用卡卡种 对应参照
             NSString *validity; // 有效日期，yyyyMM（年4位+月2位）使用信用卡加密
             NSString *card_holder;  //持卡人：使用信用卡加密
             NSString *id_card_type;  //持卡人证件类型：默认0 使用信用卡加密
             NSString *id_card_number;  //持卡人证件号：使用信用卡加密
             NSString *cvv2no;  //检查码：使用信用卡加密
             NSString *card_mobile;  //支付通协议号/手机支付手机号
             */
            
            //信用卡信息
            _orderReq.creditCardNumber = [self.cardNumber encryptUseDESKey:kDESKey];
//            _orderReq.card_number_pre = [self TripleDES:number
//                                   encryptOrDecrypt:kCCEncrypt
//                                encryptOrDecryptKey:kDESKey];
            _orderReq.creditCardType = bank;
            _orderReq.creditCardEffectiveDate = [cardDate encryptUseDESKey:kDESKey];
            
            _orderReq.creditCardHolderName = [self.cardUserName encryptUseDESKey:kDESKey];
//            _orderReq.id_card_type = [self.cardInfo.certifacateCode encryptUseDESKey:kDESKey];
//            _orderReq.id_card_number = [self.IDCards encryptUseDESKey:kDESKey];
            _orderReq.creditCardSeriesCode = [self.cardCode encryptUseDESKey:kDESKey];
            
//            _orderReq.card_mobile = [self TripleDES:number
//                                   encryptOrDecrypt:kCCEncrypt
//                                encryptOrDecryptKey:kDESKey];
            
            __weak typeof(self) b_self = self;
            [_orderReq sendReuqest:^(id result, NSError *error) {
                
                HYFlightOrder *order = nil;
                if ([result isKindOfClass:[HYFlightOrderResponse class]])
                {
                    HYFlightOrderResponse *rs = (HYFlightOrderResponse *)result;
                    order = rs.filghtOrder;
                }
                
                [b_self orderFlightResult:order error:error];
            }];
        }
        else
        {
            [METoast toastWithMessage:errorInfo];
        }
    }
}

- (void)orderFlightResult:(HYFlightOrder *)order error:(NSError *)error
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
        NSString *msg = [NSString stringWithFormat:@"订单成功：您可以在机票订单中查看。"];
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
    [self.navigationController pushViewController:vc
                                         animated:YES];
}

- (NSString *)getContentWithTextFieldTag:(NSInteger)tag
{
    NSString *content = nil;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:tag inSection:0];
    HYHotelFillCredCardCell *cell = (HYHotelFillCredCardCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    if (cell)
    {
        content = cell.textField.text;
    }
    
    return content;
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

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSArray *vcs = [self.navigationController viewControllers];
    
    UIViewController *list = nil;
    for (UIViewController *vc in vcs)
    {
        if ([vc isKindOfClass:[HYFlightCabinListViewController class]])
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

#pragma mark - HYMonthPickerViewDelegate
- (void)didSelectDate:(NSDate *)date
{
    self.cardValidDate = [date toStringWithFormat:@"yyyy/MM"];
    [self.tableView reloadData];
}

#pragma mark - HYCardTypeListViewControllerDelegate
- (void)didSelectCardtype:(HYCardType *)card
{
    self.cardInfo = card;
    [self.tableView reloadData];
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
            
            cell.detailTextLabel.backgroundColor = [UIColor clearColor];
            cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
            cell.detailTextLabel.textColor = [UIColor colorWithRed:20.0/255.0
                                                             green:140.0/255.0
                                                              blue:214.0/255.0
                                                             alpha:1.0];
        }
        
        cell.detailTextLabel.text = self.creditInfo.bankName;
        
        return cell;
    }
    else if (indexPath.row == 5)
    {
        static NSString *CellId1 = @"CellId1";
        HYBaseLineCell *cell = [tableView dequeueReusableCellWithIdentifier:CellId1];
        if (cell == nil)
        {
            cell = [[HYBaseLineCell alloc]initWithStyle:UITableViewCellStyleValue1
                                        reuseIdentifier:CellId1];
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = @"证件类型";
            cell.textLabel.font = [UIFont systemFontOfSize:15];
            cell.textLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
            cell.textLabel.backgroundColor = [UIColor clearColor];
            
            cell.detailTextLabel.backgroundColor = [UIColor clearColor];
            cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
            cell.detailTextLabel.textColor = [UIColor colorWithRed:20.0/255.0
                                                             green:140.0/255.0
                                                              blue:214.0/255.0
                                                             alpha:1.0];
        }
        
        cell.detailTextLabel.text = self.cardInfo.certifacateName;
        
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
                cell.textField.frame = CGRectMake(110, 12, 190, 20);
                cell.textField.text = self.cardNumber;
                cell.textLabel.text = @"卡号";
                [cell.infoBtn setHidden:YES];
            }
                break;
            case 2:
            {
                cell.textField.placeholder = @"年/月";
                cell.textField.keyboardType = UIKeyboardTypeNumberPad;
                [cell.textField setEnabled:NO];
                cell.textField.autoSpace = NO;
                cell.textField.frame = CGRectMake(110, 12, 120, 20);
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
                cell.textField.frame = CGRectMake(110, 12, 170, 20);
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
                cell.textField.frame = CGRectMake(110, 12, 190, 20);
                cell.textField.text = self.cardUserName;
                cell.textLabel.text = @"持卡人姓名";
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
                cell.textField.frame = CGRectMake(110, 12, 190, 20);
                cell.textField.text = self.IDCards;
                cell.textLabel.text = @"证件号码";
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
        [self.navigationController pushViewController:vc
                                             animated:YES];
    }
    else if (indexPath.row == 5) // 证件类型
    {
        HYCardTypeListViewController *vc = [[HYCardTypeListViewController alloc] init];
        vc.navbarTheme = self.navbarTheme;
        vc.delegate = self;
        vc.selectedCard = self.cardInfo;
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
//        [self creatitCradPayment:nil];
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
        case 6:
            [self.tableView setContentOffset:CGPointMake(0, 180) animated:YES];
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
        case 6:
            self.IDCards= textField.text;
            break;
        default:
            break;
    }
}

@end
