//
//  HYAddPassengerViewController.m
//  Teshehui
//
//  Created by 回亿资本 on 14-2-27.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYAddPassengerViewController.h"
#import "HYAddPassengerRequest.h"
#import "NSString+Addition.h"
#import "METoast.h"
#import "HYUserInfo.h"
#import "HYBaseLineCell.h"
#import "HYCardTypeListViewController.h"
#import "HYDatePickerView.h"
#import "NSDate+Addition.h"
#import "HYLoadHubView.h"
#import "HYCountryInfo.h"
#import "HYPickerToolView.h"
#import "HYFlightCityViewController.h"

@interface HYAddPassengerViewController ()
<
UITextFieldDelegate,
HYCardTypeListViewControllerDelegate,
HYDatePickerViewDelegate,
HYPickerToolViewDelegate,
HYFlightCityViewControllerDelegate
>
{
    HYAddPassengerRequest *_request;
    UITextField *_nameField;
    UITextField *_cardIdField;
    UITextField *_phoneField;
    
    UILabel *_cardTpyeLab;
    UILabel *_birthdayLab;
    
    HYDatePickerView *_datePicker;
    
    BOOL _isAdding;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) HYCardType *cardType;
@property (nonatomic, copy) NSString *birthday;
@property (nonatomic, strong) HYCountryInfo *country;
@property (nonatomic, strong) NSString *sexDisplay;
@property (nonatomic, strong) NSString *sex;
@property (nonatomic, strong) HYPickerToolView *pickerView;

@end

@implementation HYAddPassengerViewController

- (void)dealloc
{
    [_datePicker dismissWithAnimation:YES];
    _datePicker = nil;
    
    [_request cancel];
    _request = nil;
    
    [_pickerView dismissWithAnimation:YES];
    _pickerView = nil;
    
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
    view.backgroundColor = [UIColor colorWithRed:237.0f/255.0f
                                           green:237.0f/255.0f
                                            blue:237.0f/255.0f
                                           alpha:1.0];
    self.view = view;
    
    //tableview
    UITableView *tableview = [[UITableView alloc] initWithFrame:frame
                                                          style:UITableViewStylePlain];
	tableview.delegate = self;
	tableview.dataSource = self;
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableview.backgroundColor = [UIColor clearColor];
    tableview.backgroundView = nil;
    UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 1.0)];
    lineView.image = [[UIImage imageNamed:@"line_cell_bottom"] stretchableImageWithLeftCapWidth:2
                                                                                   topCapHeight:0];
    
    tableview.tableHeaderView = lineView;
    
    [self.view addSubview:tableview];
	self.tableView = tableview;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    doneBtn.frame = CGRectMake(0, 0, 30, 30);
    doneBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [doneBtn setTitle:@"保存"
             forState:UIControlStateNormal];
//    [doneBtn setTitle:NSLocalizedString(@"done", nil)
//             forState:UIControlStateNormal];
    [doneBtn setTitleColor:[UIColor grayColor]
                  forState:UIControlStateNormal];
    
    [doneBtn addTarget:self
                   action:@selector(addNewPassenger:)
         forControlEvents:UIControlEventTouchUpInside];
    if (!CheckIOS7)
    {
        [doneBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 12)];
    }
    UIBarButtonItem *itemBar = [[UIBarButtonItem alloc] initWithCustomView:doneBtn];
    self.navigationItem.rightBarButtonItem = itemBar;
    
    [self setDefData];
    
    switch (self.type)
    {
        case Unknow:
        {
            self.title = @"添加常用旅客";
            /*
            UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 1, 320, 80)];
            UIImage *bg = [UIImage imageNamed:@"person_buttom_orange1_normal"];
            UIImage *bg_h = [UIImage imageNamed:@"person_buttom_orange1_press"];
            UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            searchBtn.frame = CGRectMake(84, 20, 152, 38);
            [searchBtn setBackgroundImage:bg
                                 forState:UIControlStateNormal];
            [searchBtn setBackgroundImage:bg_h
                                 forState:UIControlStateHighlighted];
            [searchBtn addTarget:self
                          action:@selector(deletePassenger:)
                forControlEvents:UIControlEventTouchUpInside];
            [searchBtn setTitle:NSLocalizedString(@"delete", nil)
                       forState:UIControlStateNormal];
            [footerView addSubview:searchBtn];
            self.tableView.tableFooterView = footerView;*/
        }
            break;
        case Passenger:
            self.title = @"添加乘机人";
            break;
        case HotelGuest:
            self.title = @"添加入住人";
            break;
        default:
            break;
    }
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (_datePicker)
    {
        _datePicker.delegate = nil;
        [_datePicker dismissWithAnimation:YES];
        _datePicker = nil;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    if (!self.view.window)
    {
        [_datePicker removeFromSuperview];
        _datePicker.delegate = self;
        _datePicker = nil;
        
        _nameField = nil;
        _cardIdField = nil;
        self.tableView = nil;
        self.view = nil;
    }
}

#pragma mark private methods
- (void)setDefData
{
    //默认国籍为中国
    if (!self.country)
    {
        HYCountryInfo *c = [[HYCountryInfo alloc] init];
        c.countryId = @"1";
        c.countryName = @"中国";
        self.country = c;
        
        //self.passenger.country = c.cityId;
    }
    
    self.cardType = [[HYCardType alloc] init];
    self.cardType.certifacateCode = @"01";
    self.cardType.certifacateName = @"身份证";
    
    //默认性别为男
    self.sexDisplay = @"男";
    self.sex = @"M";
}

- (void)addNewPassenger:(id)sender
{
    [self.view endEditing:YES];
    
    if (self.type == HotelGuest)
    {
        if (!_isAdding)
        {
            NSString *errorMsg = nil;
            if ([_nameField.text length] <= 0)
            {
                errorMsg = @"请输入中文姓名";
            }
            if (errorMsg)
            {
                [METoast toastWithMessage:errorMsg];
            }
            else
            {
                [HYLoadHubView show];
                
                _isAdding = YES;
                
                if (!_request)
                {
                    _request = [[HYAddPassengerRequest alloc] init];
                }
                
                HYUserInfo *user = [HYUserInfo getUserInfo];
                _request.userId = user.userId;
                _request.realName = _nameField.text;
                
                __weak typeof(self) b_self = self;
                [_request sendReuqest:^(id result, NSError *error) {
                    
                    HYPassengers *p = nil;
                    if (!error && [result isKindOfClass:[HYPassengerResponse class]])
                    {
                        HYPassengerResponse *rs = (HYPassengerResponse *)result;
                        p = rs.passenger;
                        
                        if (rs) {
                            
                            NSString *message = @"成功添加入住人";
                            [METoast toastWithMessage:message];
                        }
                    }
                    
                    [b_self didAddNewPassenger:p
                                         error:error];
                }];
            }
        }
    }
    else
    {
        [self checkMoreAndSendAddPassengerRequest];
    }
}

- (void)checkMoreAndSendAddPassengerRequest
{
    if (!_isAdding)
    {
        [_pickerView dismissWithAnimation:YES];
        [_datePicker dismissWithAnimation:YES];
        
        NSString *errorMsg = nil;
        if ([_nameField.text length] <= 0)
        {
            errorMsg = @"请输入中文姓名";
        }
        
        else if (self.type!=HotelGuest &&
                 self.cardType.certifacateCode.integerValue == 0)
        {
            errorMsg = @"请选择证件类型";
        }
        
        else if ( self.cardType.certifacateCode.integerValue==1)
        {
            if (![NSString validateIDCardNumber:_cardIdField.text])
            {
                errorMsg = @"请输入正确证件号码";
            }
        }
        
        else if (_cardIdField.text.length == 0)
        {
            errorMsg = @"请输入证件号码";
        }
        
        else if (
                 (self.cardType.certifacateCode.integerValue!=1) &&
                 [self.birthday length] <= 0)
        {
            errorMsg = @"请填写出生日期";
        }
        
        if (errorMsg)
        {
            [METoast toastWithMessage:errorMsg];
        }
        else
        {
            [HYLoadHubView show];
            
            _isAdding = YES;
            
            if (!_request)
            {
                _request = [[HYAddPassengerRequest alloc] init];
            }
            
            HYUserInfo *user = [HYUserInfo getUserInfo];
            _request.userId = user.userId;
            _request.realName = _nameField.text;
            _request.certificateCode = self.cardType.certifacateCode;
            _request.certifacateNumber = _cardIdField.text;
            _request.birthday = self.birthday;
            if (_phoneField.text) {
                _request.phone = _phoneField.text;
            }
            
            //如果不是身份证， 则需要性别和国籍
            if (self.cardType.certifacateCode.integerValue != 1)
            {
                _request.sex = self.sex;
                _request.country = self.country.countryId;
            }
            
            __weak typeof(self) b_self = self;
            [_request sendReuqest:^(id result, NSError *error) {
                
                HYPassengers *p = nil;
                if (!error && [result isKindOfClass:[HYPassengerResponse class]])
                {
                    HYPassengerResponse *rs = (HYPassengerResponse *)result;
                    p = rs.passenger;
                    
                    if (rs) {
                        NSString *message = @"";
                        switch (self.type) {
                            case Unknow:
                                message = @"成功添加常用旅客";
                                break;
                            case Passenger:
                                message = @"成功添加乘机人";
                                break;
                            case HotelGuest:
                                message = @"成功添加入住人";
                                break;
                            default:
                                break;
                        }
                        
                        //                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                        //                        [alert show];
                        [METoast toastWithMessage:message];
                    }
                }
                
                [b_self didAddNewPassenger:p
                                     error:error];
            }];
        }
    }
}

- (void)didAddNewPassenger:(HYPassengers *)paseenger error:(NSError *)error
{
    _isAdding = NO;
    [HYLoadHubView dismiss];
    
    if (paseenger)
    {
        if ([self.delegate respondsToSelector:@selector(didUpdateWithPassenger:)])
        {
            [self.delegate didUpdateWithPassenger:paseenger];
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                       message:error.domain
                                                      delegate:nil
                                             cancelButtonTitle:nil
                                             otherButtonTitles:NSLocalizedString(@"done", nil), nil];
        [alert show];
    }
}

#pragma mark - Table view data source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    NSInteger count = 1;
    NSInteger count = 0;
    if (self.type == HotelGuest)
    {
        count = 1;
    }
    else
    {
        if (self.cardType.certifacateCode.integerValue == 1)  //身份证
        {
            count = 4;
        }
        else
        {
            count = 7;
        }
    }
//    if (self.type != HotelGuest)
//    {
//        if (self.cardType.certifacateCode.integerValue == 1)  //身份证
//        {
//            count = 4;
//        }
//        else
//        {
//            count = 7;
//        }
//    }
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger totalRow = [tableView numberOfRowsInSection:indexPath.section];
    if(indexPath.row == totalRow -1)
    {
        HYBaseLineCell *lineCell = (HYBaseLineCell *)cell;
        lineCell.separatorLeftInset = 0.0f;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.row == 0)
    {
        static NSString *nameCellId = @"nameCellId";
        HYBaseLineCell *cell = [tableView dequeueReusableCellWithIdentifier:nameCellId];
        if (cell == nil)
        {
            cell = [[HYBaseLineCell alloc]initWithStyle:UITableViewCellStyleDefault
                                         reuseIdentifier:nameCellId];
            cell.textLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
            
            _nameField = [[UITextField alloc] initWithFrame:CGRectMake(100, 0, TFScalePoint(200), 44)];
            _nameField.textAlignment = NSTextAlignmentRight;
            _nameField.keyboardType = UIKeyboardTypeDefault;
            _nameField.clearButtonMode = UITextFieldViewModeWhileEditing;
            _nameField.font = [UIFont systemFontOfSize:16];
            _nameField.returnKeyType = UIReturnKeyNext;
            _nameField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            _nameField.delegate = self;
            
            if (self.type == HotelGuest)
            {
                _nameField.placeholder = @"请输入姓名";
            }
            else
            {
                _nameField.placeholder = @"确保与证件保持一致";
            }
            [cell.contentView addSubview:_nameField];
        }
        
        cell.textLabel.text = @"中文姓名";
        return cell;
    }
    else if (indexPath.row == 1)
    {
        static NSString *cardIdCellId = @"cardTypeCell";
        HYBaseLineCell *cell = [tableView dequeueReusableCellWithIdentifier:cardIdCellId];
        if (cell == nil)
        {
            cell = [[HYBaseLineCell alloc]initWithStyle:UITableViewCellStyleValue1
                                        reuseIdentifier:cardIdCellId];
            cell.textLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            cell.detailTextLabel.textColor = [UIColor colorWithRed:51.0f/255.0f
                                                             green:147.0f/255.0f
                                                              blue:196.0f/255.0f
                                                             alpha:1.0];
            [cell.detailTextLabel setFont:[UIFont systemFontOfSize:16]];
            cell.detailTextLabel.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:cell.detailTextLabel];
           // [cell.contentView addSubview:cell.certifacateLab];
        }
        
        cell.detailTextLabel.text = self.cardType.certifacateName;
        cell.textLabel.text = @"证件类型";
        return cell;
    }
    else if (indexPath.row == 2)
    {
        static NSString *cardIdCellId = @"cardIdCellId";
        HYBaseLineCell *cell = [tableView dequeueReusableCellWithIdentifier:cardIdCellId];
        if (cell == nil)
        {
            cell = [[HYBaseLineCell alloc]initWithStyle:UITableViewCellStyleDefault
                                         reuseIdentifier:cardIdCellId];
            cell.textLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
            
            _cardIdField = [[UITextField alloc] initWithFrame:CGRectMake(100, 0, TFScalePoint(200), 44)];
            _cardIdField.textAlignment = NSTextAlignmentRight;
            _cardIdField.keyboardType = UIKeyboardTypeASCIICapable;
            _cardIdField.clearButtonMode = UITextFieldViewModeWhileEditing;
            _cardIdField.font = [UIFont systemFontOfSize:16];
            _cardIdField.returnKeyType = UIReturnKeyDone;
            _cardIdField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            _cardIdField.delegate = self;
            _cardIdField.placeholder = @"请输入证件号码";
            [cell.contentView addSubview:_cardIdField];
        }
        
        cell.textLabel.text = @"证件号码";
        return cell;
    }
    else
    {
        if (self.cardType.certifacateCode.integerValue == 1)
        {
            
            static NSString *phoneCellId = @"phoneCellId";
            HYBaseLineCell *cell = [tableView dequeueReusableCellWithIdentifier:phoneCellId];
            if (cell == nil)
            {
                cell = [[HYBaseLineCell alloc]initWithStyle:UITableViewCellStyleDefault
                                            reuseIdentifier:phoneCellId];
                cell.textLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
                
                _phoneField = [[UITextField alloc] initWithFrame:CGRectMake(100, 0, TFScalePoint(200), 44)];
                _phoneField.textAlignment = NSTextAlignmentRight;
                _phoneField.keyboardType = UIKeyboardTypePhonePad;
                _phoneField.clearButtonMode = UITextFieldViewModeWhileEditing;
                _phoneField.font = [UIFont systemFontOfSize:16];
                _phoneField.returnKeyType = UIReturnKeyDone;
                _phoneField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                _phoneField.delegate = self;
                _phoneField.placeholder = @"选填";
                [cell.contentView addSubview:_phoneField];
            }
            
            cell.textLabel.text = @"手机号码";
            return cell;
        }
        else
        {
            if (indexPath.row == 6) {
                
                static NSString *phoneCellId = @"phoneCellId";
                HYBaseLineCell *cell = [tableView dequeueReusableCellWithIdentifier:phoneCellId];
                if (cell == nil)
                {
                    cell = [[HYBaseLineCell alloc]initWithStyle:UITableViewCellStyleDefault
                                                reuseIdentifier:phoneCellId];
                    cell.textLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
                    
                    _phoneField = [[UITextField alloc] initWithFrame:CGRectMake(100, 0, TFScalePoint(200), 44)];
                    _phoneField.textAlignment = NSTextAlignmentRight;
                    _phoneField.keyboardType = UIKeyboardTypePhonePad;
                    _phoneField.clearButtonMode = UITextFieldViewModeWhileEditing;
                    _phoneField.font = [UIFont systemFontOfSize:16];
                    _phoneField.returnKeyType = UIReturnKeyDone;
                    _phoneField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                    _phoneField.delegate = self;
                    _phoneField.placeholder = @"选填";
                    [cell.contentView addSubview:_phoneField];
                }
                
                cell.textLabel.text = @"手机号码";
                return cell;
            }
            static NSString *cardIdCellId = @"valueSelectCell";
            HYBaseLineCell *cell = [tableView dequeueReusableCellWithIdentifier:cardIdCellId];
            if (cell == nil)
            {
                cell = [[HYBaseLineCell alloc]initWithStyle:UITableViewCellStyleValue1
                                            reuseIdentifier:cardIdCellId];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.textLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
                
                cell.detailTextLabel.textColor = [UIColor colorWithRed:51.0f/255.0f
                                                                 green:147.0f/255.0f
                                                                  blue:196.0f/255.0f
                                                                 alpha:1.0];
                [cell.detailTextLabel setFont:[UIFont systemFontOfSize:16]];
                cell.detailTextLabel.backgroundColor = [UIColor clearColor];
                [cell.contentView addSubview:cell.detailTextLabel];
               // [cell.contentView addSubview:cell.certifacateLab];
            }
            
            switch (indexPath.row)
            {
                case 3:
                    cell.detailTextLabel.text = self.country.countryName;
                    cell.textLabel.text = @"国籍";
                    break;
                case 4:
                    cell.detailTextLabel.text = self.sexDisplay;
                    cell.textLabel.text = @"性别";
                    break;
                case 5:
                    cell.detailTextLabel.text = self.birthday;
                    cell.textLabel.text = @"生日";
                    break;
                default:
                    break;
            }
            
            return cell;
        }
        
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.view endEditing:YES];
    
    switch (indexPath.row)
    {
        case 1:
        {
            HYCardTypeListViewController *vc = [[HYCardTypeListViewController alloc] init];
            vc.navbarTheme = self.navbarTheme;
            vc.delegate = self;
            vc.selectedCard = self.cardType;
            [self.navigationController pushViewController:vc
                                                 animated:YES];
        }
            break;
        case 3:
        {
            if (self.cardType.certifacateCode.integerValue != 1)
            {
                [self updatePassengerCountry];
            }
        }
            break;
        case 4:
        {
            [self updatePassengerSex];
        }
            break;
        case 5:
        {
            [self updatebirthday];
        }
            break;
        default:
            break;
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (![self.cardType.certifacateCode isEqual:@"01"]) {
        
        [self.tableView setContentOffset:CGPointMake(0, 150)];
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _nameField)
    {
        [_cardIdField becomeFirstResponder];
    }
    else if (textField == _cardIdField)
    {
        [self addNewPassenger: nil];
        [textField resignFirstResponder];
    }
    
    return YES;
}

#pragma mark - HYCardTypeListViewControllerDelegate
- (void)didSelectCardtype:(HYCardType *)card
{
    self.cardType = card;
    [self.tableView reloadData];
}

#pragma mark - HYDatePickerViewDelegate
- (void)didSelectDate:(NSDate *)date
{
    self.birthday = [date timeDescription];
    [self.tableView reloadData];
}

#pragma mark private methods
- (void)updatebirthday
{
    if (!_datePicker)
    {
        _datePicker = [[HYDatePickerView alloc] initWithFrame:CGRectMake(0, 0, ScreenRect.size.width, 260)];
        _datePicker.title = @"选择出生日期";
        _datePicker.delegate = self;
    }
    
    NSString *dateStr =  ([self.birthday length] > 0) ? self.birthday :@"1980-01-01";
    NSDate *date = [NSDate dateFromString:dateStr];
    _datePicker.pickerView.date = date;
    [_datePicker showWithAnimation:YES];
}

- (void)updatePassengerSex
{
    [self.pickerView showWithAnimation:YES];
}

- (void)updatePassengerCountry
{
    HYFlightCityViewController *vc = [[HYFlightCityViewController alloc] init];
    vc.titleName = Country;
    vc.delegate = self;
    vc.dataSoucreType = FlightCountry;
    vc.navbarTheme = self.navbarTheme;
    [self.navigationController pushViewController:vc
                                         animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.dragging)
    {
        [self.view endEditing:YES];
    }
}

#pragma mark setter/getter
- (HYPickerToolView *)pickerView
{
    if (!_pickerView)
    {
        _pickerView = [[HYPickerToolView alloc] initWithFrame:CGRectMake(0, 0, 320, 260)];
        _pickerView.delegate = self;
        _pickerView.dataSouce = @[@"男", @"女"];
        _pickerView.title = @"选择性别";
    }
    
    return _pickerView;
}

#pragma mark - HYPickerToolViewDelegate
- (void)selectComplete:(HYPickerToolView *)pickerView
{
    switch (pickerView.currentIndex)
    {
        case 0:
            self.sex = @"M";
            self.sexDisplay = @"男";
            break;
        case 1:
            self.sex = @"F";
            self.sexDisplay = @"女";
            break;
        default:
            break;
    }
    
    [self.tableView reloadData];
}

#pragma mark - HYFlightCityViewControllerDelegate
- (void)didSelectCity:(HYCountryInfo *)city
{
    self.country = city;
    [self.tableView reloadData];
}

- (void) done
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}


@end
