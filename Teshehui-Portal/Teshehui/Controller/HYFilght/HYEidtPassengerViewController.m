//
//  HYEidtPassengerViewController.m
//  Teshehui
//
//  Created by 回亿资本 on 14-3-1.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYEidtPassengerViewController.h"
#import "HYModifyPassengerRequest.h"
// #import "HYDeletePassengerRequest.h"
#import "NSString+Addition.h"
#import "METoast.h"
#import "HYUserInfo.h"
#import "HYBaseLineCell.h"
#import "HYCardTypeListViewController.h"
#import "HYDatePickerView.h"
#import "NSDate+Addition.h"
#import "HYLoadHubView.h"
#import "HYPickerToolView.h"
#import "HYFlightCityViewController.h"

@interface HYEidtPassengerViewController ()
<
UITextFieldDelegate,
HYCardTypeListViewControllerDelegate,
HYDatePickerViewDelegate,
HYPickerToolViewDelegate,
HYFlightCityViewControllerDelegate
>
{
//    HYDeletePassengerRequest *_rDelete;
    HYModifyPassengerRequest *_rModify;
    UITextField *_nameField;
    UITextField *_cardIdField;
    UITextField *_phoneField;
    
    HYDatePickerView *_datePicker;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) HYPickerToolView *pickerView;
@property (nonatomic, strong) HYCountryInfo *country;
@property (nonatomic, copy) NSString *sex;
@end

@implementation HYEidtPassengerViewController
- (void)dealloc
{
    if (_datePicker)
    {
        [_datePicker dismissWithAnimation:YES];
        _datePicker = nil;
    }
    
//    [_rDelete cancel];
//    _rDelete = nil;
    
    [_rModify cancel];
    _rModify = nil;
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
    
    tableview.sectionFooterHeight = 0;
    tableview.sectionHeaderHeight = 0;
    
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
//    [doneBtn setTitle:NSLocalizedString(@"done", nil)
//             forState:UIControlStateNormal];
    [doneBtn setTitle:@"保存" forState:UIControlStateNormal];
    [doneBtn setTitleColor:[UIColor grayColor]
                  forState:UIControlStateNormal];
    [doneBtn addTarget:self
                action:@selector(eidtPassenger:)
      forControlEvents:UIControlEventTouchUpInside];
    if (!CheckIOS7)
    {
        [doneBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 12)];
    }
    UIBarButtonItem *itemBar = [[UIBarButtonItem alloc] initWithCustomView:doneBtn];
    self.navigationItem.rightBarButtonItem = itemBar;
    
    //设置默认数据
    [self setDefData];
    
    switch (self.type)
    {
        case Unknow:
        {
            self.title = @"编辑常用旅客";
            
//            UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 1, ScreenRect.size.width, 80)];
//            UIImage *bg = [UIImage imageNamed:@"person_buttom_orange1_normal"];
//            UIImage *bg_h = [UIImage imageNamed:@"person_buttom_orange1_press"];
//            UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//            searchBtn.frame = CGRectMake((ScreenRect.size.width-152)/2, 20, 152, 38);
//            [searchBtn setBackgroundImage:bg
//                                 forState:UIControlStateNormal];
//            [searchBtn setBackgroundImage:bg_h
//                                 forState:UIControlStateHighlighted];
//            [searchBtn addTarget:self
//                          action:@selector(deletePassenger:)
//                forControlEvents:UIControlEventTouchUpInside];
//            
//            [searchBtn setTitle:NSLocalizedString(@"delete", nil)
//                       forState:UIControlStateNormal];
//            [footerView addSubview:searchBtn];
//            self.tableView.tableFooterView = footerView;
        }
            break;
        case Passenger:
            self.title = @"编辑乘机人";
            break;
        case HotelGuest:
            self.title = @"编辑入住人";
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
        _datePicker.delegate = nil;
        _datePicker = nil;
        
        _nameField = nil;
        _cardIdField = nil;
        _phoneField = nil;
        self.tableView = nil;
        self.view = nil;
    }
}

#pragma mark private methods

- (void)setDefData
{
    //默认国籍为中国
    if ([self.passenger.country length] <= 0)
    {
        HYCountryInfo *c = [[HYCountryInfo alloc] init];
        c.countryId = @"1";
        c.countryName = @"中国";
        self.country = c;
        
        self.passenger.country = c.countryId;
    }
    else
    {
        HYCountryInfo *c = [HYCountryInfo countryWithId:self.passenger.country];
        self.country = c;
    }
    
    //默认性别为男
    if ([self.passenger.sex length] <= 0)
    {
        self.sex = @"男";
        self.passenger.sex = @"M";
    }
    else
    {
        self.sex = [self.passenger.sex isEqualToString:@"M" ] ? @"男" : @"女";
    }
}

- (void)eidtPassenger:(id)sender
{
    [self hiddenKeyborad];
    
    
    if (self.type == HotelGuest)
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
            
            _rModify = [[HYModifyPassengerRequest alloc] init];
            
            HYUserInfo *user = [HYUserInfo getUserInfo];
            _rModify.userId = user.userId;
            _rModify.passengerId = self.passenger.passengerId;
            _rModify.realName = _nameField.text;
            
            __weak typeof(self) b_self = self;
            [_rModify sendReuqest:^(id result, NSError *error) {
                [HYLoadHubView dismiss];
                HYPassengers *p = nil;
                HYPassengerResponse *rs = (HYPassengerResponse *)result;
                if (!error && [result isKindOfClass:[HYPassengerResponse class]])
                {
                    p = rs.passenger;
                    if (p) {
                        
                        NSString *message = @"成功编辑入住人";
                        [METoast toastWithMessage:message];
                        [b_self updatePassenger:p];
                    }
                }
                else
                {
                    if (rs.message) {
                        
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:rs.message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                        [alert show];
                    }
                }
            }];
        }
        
    }
    else
    {
        [self checkMoreInfoAndSendRequest];
    }
    
}

- (void)checkMoreInfoAndSendRequest
{
    NSString *errorMsg = nil;
    if ([_nameField.text length] <= 0)
    {
        errorMsg = @"请输入中文姓名";
    }
    
    if (!errorMsg &&
        self.passenger.id_card_type_id.integerValue == 0)
    {
        errorMsg = @"请选择证件类型";
    }
    
    if (!errorMsg &&
        self.passenger.id_card_type_id.integerValue > 0)
    {
        if (![NSString validateIDCardNumber:_cardIdField.text] &&
            (self.passenger.id_card_type_id.integerValue==1))
        {
            errorMsg = @"请输入有效身份证号码";
        }
        else
        {
            if ([_cardIdField.text length] <= 0)
            {
                errorMsg = @"请输入证件号码";
            }
        }
    }
    
    if (!errorMsg &&
        (self.passenger.id_card_type_id.integerValue!=1) &&
        [self.passenger.birthday length] <= 0)
    {
        errorMsg = @"请输入出生日期";
    }
    
    if (errorMsg)
    {
        [METoast toastWithMessage:errorMsg];
    }
    else
    {
        [HYLoadHubView show];
        
        _rModify = [[HYModifyPassengerRequest alloc] init];
        
        HYUserInfo *user = [HYUserInfo getUserInfo];
        _rModify.userId = user.userId;
        _rModify.passengerId = self.passenger.passengerId;
        _rModify.realName = _nameField.text;
        _rModify.certificateCode = self.passenger.id_card_type_id;
        _rModify.certifacateNumber = _cardIdField.text;
        _rModify.birthday = self.passenger.birthday;
        if (self.passenger.phone) {
            _rModify.phone = self.passenger.phone;
        }
        else
        {
            _rModify.phone = @"";
        }
        
        //如果不是身份证， 则需要性别和国籍
        if (self.passenger.id_card_type_id.integerValue != 1)
        {
            _rModify.sex = self.passenger.sex;
            _rModify.country = self.passenger.country;
        }
        
        __weak typeof(self) b_self = self;
        [_rModify sendReuqest:^(id result, NSError *error) {
            [HYLoadHubView dismiss];
            HYPassengers *p = nil;
            HYPassengerResponse *rs = (HYPassengerResponse *)result;
            if (!error && [result isKindOfClass:[HYPassengerResponse class]])
            {
                p = rs.passenger;
                if (p) {
                    //                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"成功编辑常用旅客" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                    //                    [alert show];
                    NSString *message = @"";
                    switch (self.type) {
                        case Unknow:
                            message = @"成功编辑常用旅客";
                            break;
                        case Passenger:
                            message = @"成功编辑乘机人";
                            break;
                        case HotelGuest:
                            message = @"成功编辑入住人";
                            break;
                        default:
                            break;
                    }
                    
                    [METoast toastWithMessage:message];
                    [b_self updatePassenger:p];
                }
            }
            else
            {
                if (rs.message) {
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:rs.message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                    [alert show];
                }
            }
        }];
    }
}

- (void)updatePassenger:(HYPassengers *)paseenger
{
    if ([paseenger.passengerId length]>0 && [self.delegate respondsToSelector:@selector(didUpdateWithPassenger:)])
    {
        [self.delegate didUpdateWithPassenger:paseenger];
    }
    [HYLoadHubView dismiss];
    
    [self.navigationController popViewControllerAnimated:YES];
}

//- (void)deletePassenger:(id)sender
//{
//    [self hiddenKeyborad];
//    
//    if (!_rDelete)
//    {
//        _rDelete = [[HYDeletePassengerRequest alloc] init];
//    }
//    
//    [HYLoadHubView show];
//    
//    HYUserInfo *user = [HYUserInfo getUserInfo];
//    _rDelete.user_id = user.userId;
//    _rDelete.passenger_id = self.passenger.passengerId;
//    
//    __weak typeof(self) b_self = self;
//    [_rDelete sendReuqest:^(id result, NSError *error) {
//        [b_self deletePassengerFinished:error];
//    }];
//}

//- (void)deletePassengerFinished:(NSError *)error
//{
//    if (!error)
//    {
//        if ([self.delegate respondsToSelector:@selector(didDeletePassenger:)])
//        {
//            [self.delegate didDeletePassenger:self.passenger];
//        }
//    }
//    
//    [HYLoadHubView dismiss];
//    [self.navigationController popViewControllerAnimated:YES];
//}

- (void)updatebirthday
{
    if ([self.pickerView isShow])
    {
        [self.pickerView dismissWithAnimation:NO];
    }
    
    if (!_datePicker)
    {
        _datePicker = [[HYDatePickerView alloc] initWithFrame:CGRectMake(0, 0, ScreenRect.size.width, 260)];
        _datePicker.title = @"选择出生日期";
        _datePicker.delegate = self;
    }
    
    NSString *dateStr =  ([self.passenger.birthday length] > 0) ? self.passenger.birthday :@"1980-01-01";
    NSDate *date = [NSDate dateFromString:dateStr];
    _datePicker.pickerView.date = date;
    [_datePicker showWithAnimation:YES];
}

- (void)updatePassengerSex
{
    if ([_datePicker isShow])
    {
        [_datePicker dismissWithAnimation:NO];
    }
    
    [self.pickerView showWithAnimation:YES];
}

- (void)updatePassengerCountry
{
    if ([self.pickerView isShow])
    {
        [self.pickerView dismissWithAnimation:NO];
    }
    
    if ([_datePicker isShow])
    {
        [_datePicker dismissWithAnimation:NO];
    }
    
    HYFlightCityViewController *vc = [[HYFlightCityViewController alloc] init];
    vc.titleName = Country;
    vc.delegate = self;
    vc.dataSoucreType = FlightCountry;
    vc.navbarTheme = self.navbarTheme;
    [self.navigationController pushViewController:vc
                                         animated:YES];
}

- (void)hiddenKeyborad
{
    [_nameField resignFirstResponder];
    [_cardIdField resignFirstResponder];
    [_phoneField resignFirstResponder];
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
            self.passenger.sex = @"M";
            self.sex = @"男";
            break;
        case 1:
            self.passenger.sex = @"F";
            self.sex = @"女";
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
    self.passenger.country = city.countryId;
    [self.tableView reloadData];
}

#pragma mark - HYCardTypeListViewControllerDelegate
- (void)didSelectCardtype:(HYCardType *)card
{
    self.passenger.id_card_type_id = card.certifacateCode;
    self.passenger.cardName = card.certifacateName;
    self.passenger.cardID = nil;
    [self.tableView reloadData];
}

#pragma mark - HYDatePickerViewDelegate
- (void)didSelectDate:(NSDate *)date
{
    NSString *birthday = [date timeDescription];
    self.passenger.birthday = birthday;
    
    [self.tableView reloadData];
}

#pragma mark - Table view data source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = 1;
    if (self.type != HotelGuest)
    {
        if (self.passenger.id_card_type_id.integerValue==1)  //身份证
        {
            count = 4;
        }
        else
        {
            count = 7;
        }
    }
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
            cell.textLabel.backgroundColor = [UIColor clearColor];
            cell.textLabel.font = [UIFont systemFontOfSize:16];
            
            _nameField = [[UITextField alloc] initWithFrame:CGRectMake(100, 0, TFScalePoint(200), 44)];
            _nameField.textAlignment = NSTextAlignmentRight;
            _nameField.keyboardType = UIKeyboardTypeDefault;
            _nameField.clearButtonMode = UITextFieldViewModeWhileEditing;
            _nameField.font = [UIFont systemFontOfSize:16];
            _nameField.returnKeyType = UIReturnKeyNext;
            _nameField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            _nameField.delegate = self;
            [cell.contentView addSubview:_nameField];
        }
        
        _nameField.text = self.passenger.name;
        cell.textLabel.text = @"姓名";
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
            [cell.contentView addSubview:cell.detailTextLabel];
            [cell.contentView addSubview:cell.detailTextLabel];
           // [cell.contentView addSubview:cell.certifacateLab];
        }
        
        cell.detailTextLabel.text = self.passenger.cardName;
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
            cell.textLabel.backgroundColor = [UIColor clearColor];
            cell.textLabel.font = [UIFont systemFontOfSize:16];
            
            _cardIdField = [[UITextField alloc] initWithFrame:CGRectMake(100, 0, TFScalePoint(200), 44)];
            _cardIdField.textAlignment = NSTextAlignmentRight;
            _cardIdField.keyboardType = UIKeyboardTypeDefault;
            _cardIdField.clearButtonMode = UITextFieldViewModeWhileEditing;
            _cardIdField.font = [UIFont systemFontOfSize:16];
            _cardIdField.returnKeyType = UIReturnKeyDone;
            _cardIdField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            _cardIdField.delegate = self;
            [cell.contentView addSubview:_cardIdField];
        }
        
        _cardIdField.text = self.passenger.cardID;
        cell.textLabel.text = @"证件号码";
        return cell;
    }
    else
    {
        if (self.passenger.id_card_type_id.integerValue==1)
        {
            static NSString *phoneCellId = @"phoneCellId";
            HYBaseLineCell *cell = [tableView dequeueReusableCellWithIdentifier:phoneCellId];
            if (cell == nil)
            {
                cell = [[HYBaseLineCell alloc]initWithStyle:UITableViewCellStyleDefault
                                            reuseIdentifier:phoneCellId];
                cell.textLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
                cell.textLabel.backgroundColor = [UIColor clearColor];
                cell.textLabel.font = [UIFont systemFontOfSize:16];
                
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.detailTextLabel.text = @"";
                cell.detailTextLabel.backgroundColor = [UIColor redColor];
                
                _phoneField = [[UITextField alloc] initWithFrame:CGRectMake(100, 0, TFScalePoint(200), 44)];
                _phoneField.textAlignment = NSTextAlignmentRight;
                _phoneField.keyboardType = UIKeyboardTypePhonePad;
                _phoneField.clearButtonMode = UITextFieldViewModeWhileEditing;
                _phoneField.font = [UIFont systemFontOfSize:16];
                _phoneField.returnKeyType = UIReturnKeyDone;
                _phoneField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                _phoneField.delegate = self;
                [cell.contentView addSubview:_phoneField];
            }
            
            _phoneField.text = self.passenger.phone;
            _phoneField.placeholder = @"选填";
            cell.textLabel.text = @"手机号码";
            return cell;
        }
        else
        {
            if (indexPath.row == 6)
            {
                
                static NSString *phoneCellId = @"phoneCellId";
                HYBaseLineCell *cell = [tableView dequeueReusableCellWithIdentifier:phoneCellId];
                if (cell == nil)
                {
                    cell = [[HYBaseLineCell alloc]initWithStyle:UITableViewCellStyleDefault
                                                reuseIdentifier:phoneCellId];
                    cell.textLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
                    cell.textLabel.backgroundColor = [UIColor clearColor];
                    cell.textLabel.font = [UIFont systemFontOfSize:16];
                    
                    _phoneField = [[UITextField alloc] initWithFrame:CGRectMake(100, 0, TFScalePoint(200), 44)];
                    _phoneField.textAlignment = NSTextAlignmentRight;
                    _phoneField.keyboardType = UIKeyboardTypePhonePad;
                    _phoneField.clearButtonMode = UITextFieldViewModeWhileEditing;
                    _phoneField.font = [UIFont systemFontOfSize:16];
                    _phoneField.returnKeyType = UIReturnKeyDone;
                    _phoneField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                    _phoneField.delegate = self;
                    [cell.contentView addSubview:_phoneField];
                }
                
                _phoneField.text = self.passenger.phone;
                _phoneField.placeholder = @"选填";
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
              //  [cell.contentView addSubview:cell.certifacateLab];
            }
            
            switch (indexPath.row)
            {
                case 3:
                    cell.detailTextLabel.text = self.country.countryName;
                    cell.textLabel.text = @"国籍";
                    break;
                case 4:
                    cell.detailTextLabel.text = self.sex;
                    cell.textLabel.text = @"性别";
                    break;
                case 5:
                    cell.detailTextLabel.text = self.passenger.birthday;
                    cell.textLabel.text = @"出生日期";
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
    
    [self hiddenKeyborad];
    
    switch (indexPath.row)
    {
        case 1:
        {
            HYCardTypeListViewController *vc = [[HYCardTypeListViewController alloc] init];
            vc.navbarTheme = self.navbarTheme;
            vc.delegate = self;
            HYCardType *card = [[HYCardType alloc] init];
            card.certifacateCode = self.passenger.id_card_type_id;
            vc.selectedCard = card;
            [self.navigationController pushViewController:vc
                                                 animated:YES];
        }
            break;
        case 3:
        {
            if (self.passenger.id_card_type_id.integerValue != 1)
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
    if (textField == _nameField)
    {
        [_cardIdField becomeFirstResponder];
    }
    else if (textField == _cardIdField)
    {
//        [self eidtPassenger: nil];
        [textField resignFirstResponder];
    }
    
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == _phoneField) {
        
        if (self.passenger.id_card_type_id.integerValue != 1) { // 非身份证
            
            [self.tableView setContentOffset:CGPointMake(0, 150)];
        }
    }
    return YES;
}

- (void) textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == _cardIdField)
    {
        self.passenger.cardID = textField.text;
    }
    else if (textField == _nameField)
    {
        self.passenger.name = textField.text;
    }
    else if (textField == _phoneField)
    {
        self.passenger.phone = textField.text;
    }
}

- (void) done
{
    [self.view endEditing:YES];
}

@end
