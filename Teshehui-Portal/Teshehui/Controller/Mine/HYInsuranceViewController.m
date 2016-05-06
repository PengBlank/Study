//
//  HYInsuranceViewController.m
//  Teshehui
//
//  Created by HYZB on 15/3/30.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYInsuranceViewController.h"
#import "HYPersonCell.h"
#import "HYScreenTransformHeader.h"
#import "HYUserUpgradeRequest.h"

#import "HYUserInfo.h"
#import "HYUiunderlinedbutton.h"
#import "HYCheckInsuranceViewController.h"
#import "HYPaymentViewController.h"

#import "HYQueryMemberInsuranceRequest.h"
#import "HYQueryMemberInsuranceResponse.h"
#import "HYNullView.h"
#import "HYPickerToolView.h"
#import "HYInsuranceFillingInfoController.h"
#import "HYCardTypeRequest.h"
#import "HYCardTypeListViewController.h"
#import "HYGetPolicyListRequest.h"
#import "HYGetPolicyListResponse.h"
#import "NSString+Addition.h"

#import "HYChindLoginV2RadioCell.h"
#import "HYChildLoginV2TextCell.h"
#import "HYDatePickerView.h"
#import "NSDate+Addition.h"
#import "METoast.h"

@interface HYInsuranceViewController ()
<UITableViewDataSource,
UITableViewDelegate,
HYCheckInsuranceDelegate,
HYDatePickerViewDelegate>
{
    HYUserUpgradeRequest *_insuranceRequest;
    HYQueryMemberInsuranceRequest *_queryMemberInsuranceRequest;
    HYGetPolicyListRequest *_getPolicyTypeRequest;
    
    HYDatePickerView *_datePicker;
    BOOL _agreeInsurance;
    BOOL _isAgree;
    BOOL _isPaySucc;
    
    NSString *_idAuth;
    
    HYCardTypeRequest *_cardReqeust;
}

@property (nonatomic, strong)UITableView* tableview;
@property (nonatomic, strong)UIButton *buttonOfFooter;
@property (nonatomic, strong)UIButton *lookBtn;
@property (nonatomic, strong)UIButton *continueInsurance;
@property (nonatomic, strong)HYNullView* nullView;
@property (nonatomic, strong) HYPickerToolView *pickerView;


@property (nonatomic, copy) NSString *realName;
@property (nonatomic, copy) NSString *idCardNum;
@property (nonatomic, copy) NSString *idCardCode;
@property (nonatomic, copy) NSString *idCardName;
@property (nonatomic, assign) HYUserInfoSex sex;
@property (nonatomic, copy) NSString *birthday;

/// 获取到的已购买保险类型
@property (nonatomic, strong) HYPolicy *policy;
/// 选择的保险类型
@property (nonatomic, strong) HYPolicyType *selectedPolicy;

//应付金额
@property(nonatomic, copy)NSString *gold;
@end

@implementation HYInsuranceViewController

-(void)dealloc
{
    [_insuranceRequest cancel];
    _insuranceRequest = nil;
    
    [_queryMemberInsuranceRequest cancel];
    _queryMemberInsuranceRequest = nil;
    
    [_cardReqeust cancel];
    _cardReqeust = nil;
    
    [_pickerView dismissWithAnimation:YES];
    
    [HYLoadHubView dismiss];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    
    [_pickerView dismissWithAnimation:YES];
    [_datePicker dismissWithAnimation:YES];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"会员续费";
   
    self.userInfo = [HYUserInfo getUserInfo];
    _realName = self.userInfo.realName;
    _idCardNum = self.userInfo.certificateNumber;
    _idCardCode = self.userInfo.certificateCode;
    _idCardName = self.userInfo.certificateName;
    _idAuth = self.userInfo.idAuthentication;
    _birthday = self.userInfo.birthday;
    _sex = self.userInfo.localSex;
    
    //主视图的宽高
    CGFloat width = self.view.bounds.size.width;
    
    UITableView *tableview = [[UITableView alloc] initWithFrame:self.view.bounds
                                                          style:UITableViewStylePlain];
    tableview.dataSource = self;
    tableview.delegate = self;
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableview.backgroundView = nil;
    tableview.backgroundColor = [UIColor clearColor];

    //设置footerview
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 90)];
    footerView.userInteractionEnabled = YES;
    
    UIImage *submit = [[UIImage imageNamed:@"ci_btn_on"]
                       stretchableImageWithLeftCapWidth:5 topCapHeight:10];
    UIButton *continueInsurance = [[UIButton alloc]initWithFrame:CGRectMake(20, 5, width-40, 44)];
    [continueInsurance setBackgroundImage:[UIImage imageNamed:@"xb_06"] forState:UIControlStateNormal];
    [continueInsurance setTitle:@"立即续费" forState:UIControlStateNormal];
    [continueInsurance addTarget:self action:@selector(xubao:) forControlEvents:UIControlEventTouchDown];
    continueInsurance.enabled = NO;
    [continueInsurance setBackgroundImage:submit forState:UIControlStateNormal];
    [footerView addSubview:continueInsurance];
    self.continueInsurance = continueInsurance;

    tableview.tableFooterView = footerView;
    self.tableview = tableview;
    
    [self.view addSubview:tableview];
    
    [self getInsuranceResult];
}

-(void)loadView
{
    CGRect frame = [[UIScreen mainScreen] bounds];
    frame.size.height -= 64.0;
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor whiteColor];
    self.view = view;
}

#pragma mark - setter/getter
- (HYPickerToolView *)pickerView
{
    if (!_pickerView) {
        _pickerView = [[HYPickerToolView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 216)];
    }
    return _pickerView;
}

#pragma mark - events
-(void)checkProtocol:(id)sender
{
    [self.view endEditing:YES];
    
    if ([self hasPurchasedPolicy] || _selectedPolicy)
    {
        HYCheckInsuranceViewController *vc = [[HYCheckInsuranceViewController alloc] init];
        vc.insuranceProvision = [self hasPurchasedPolicy] ? _policy.insuranceProvision : _selectedPolicy.insuranceProvision;
        vc.delegate = self;
        vc.isAgree = _isAgree;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        [METoast toastWithMessage:@"请选择保险类型"];
    }
}

//checkBox点击事件
-(void)checkBoxClick:(UIButton *)sender
{
    if ([self hasPurchasedPolicy] || _selectedPolicy)
    {
        sender.selected = !sender.isSelected;
        
        if (sender.isSelected) {
            _continueInsurance.enabled = YES;
        }else
        {
            _continueInsurance.enabled = NO;
        }
    }
    else
    {
        [METoast toastWithMessage:@"请选择保险类型"];
    }
}

//立即续保
- (void)xubao:(UIButton *)sender
{
    _realName = [_realName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    NSString *str = nil;
    
    if ([_realName length] <= 0)
    {
        str = @"请输入姓名";
    }
    else if ([_idCardCode length] <= 0)
    {
        str = @"请选择证件类型";
    }
    else if ([_idCardNum length] <= 0)
    {
        str = @"请输入证件号码";
    }
    else if (_idCardCode.integerValue == 1)
    {
        if (![NSString validateIDCardNumber:_idCardNum])
        {
            str = @"请输入合法的身份证号";
        }
    }
    else if (_sex == HYSexUnknown)
    {
        str = @"请选择性别";
    }
    else if ([_birthday length] <= 0)
    {
        str = @"请输入生日";
    }
    else if (_policy.insuranceTypeCode.length == 0 &&
             !_selectedPolicy)
    {
        str = @"请选择保险类型";
    }
    
    if (str)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:str delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        
        return;
    }
    
    [self getInsuranceData];
}

#pragma mark - private
#pragma mark -- functions

- (BOOL)hasPurchasedPolicy
{
    return _policy.insuranceTypeCode.length > 0;
}

- (void)modifyUserName
{
    HYInsuranceFillingInfoController *vc = [[HYInsuranceFillingInfoController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    vc.title = @"真实姓名";
    vc.handler = ^(NSString *result)
    {
        _realName = result;
        [self.tableview reloadData];
    };
}

- (void)modifyCardType
{
    [HYLoadHubView show];
    
    if (!_cardReqeust)
    {
        _cardReqeust = [[HYCardTypeRequest alloc] init];
    }
    [_cardReqeust cancel];
    //买保险
    _cardReqeust.applicationType = @"1";
    
    __weak typeof(self) b_self = self;
    [_cardReqeust sendReuqest:^(id result, NSError *error)
     {
         [HYLoadHubView dismiss];
         if ([result isKindOfClass:[HYCardTypeResponse class]] && !error)
         {
             HYCardTypeResponse *response = (HYCardTypeResponse *)result;
             if (response.status == 200)
             {
                 NSArray *cardList = response.cardList;
                 NSMutableArray *names = [NSMutableArray array];
                 for (HYCardType *card in cardList)
                 {
                     [names addObject:card.certifacateName];
                 }
                 b_self.pickerView.dataSouce = names;
                 [b_self.pickerView showWithAnimation:YES];
                 b_self.pickerView.didSelectItem = ^(NSInteger idx){
                     HYCardType *selectedCard = [cardList objectAtIndex:idx];
                     b_self.idCardCode = selectedCard.certifacateCode;
                     b_self.idCardName = selectedCard.certifacateName;
                     [b_self.tableview reloadData];
                 };
             }
         }
         else
         {
             [METoast toastWithMessage:error.domain];
         }
     }];
}

- (void)modifyCardNum
{
    HYInsuranceFillingInfoController *vc = [[HYInsuranceFillingInfoController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    vc.title = @"证件号码";
    WS(weakSelf);
    vc.handler = ^(NSString *result)
    {
        weakSelf.idCardNum = result;
        [weakSelf.tableview reloadData];
    };
}

- (void)modifySex
{
    NSArray *datas = @[@"男", @"女"];
    self.pickerView.dataSouce = datas;
    WS(weakSelf);
    self.pickerView.didSelectItem = ^(NSInteger idx)
    {
        if (idx == 0) {
            weakSelf.sex = HYSexMale;
        }
        else if (idx == 1) {
            weakSelf.sex = HYSexFemale;
        }
        [weakSelf.tableview reloadData];
    };
    [self.pickerView showWithAnimation:YES];
}

/// 获取保险类型
- (void)fetchPolicys
{
    [HYLoadHubView show];
    
    if (!_getPolicyTypeRequest)
    {
        _getPolicyTypeRequest = [[HYGetPolicyListRequest alloc] init];
    }
    [_getPolicyTypeRequest cancel];
    _getPolicyTypeRequest.type = @"4";
    __weak typeof(self) b_self = self;
    [_getPolicyTypeRequest sendReuqest:^(HYGetPolicyListResponse *result, NSError *error)
     {
         [HYLoadHubView dismiss];
         if (result.status == 200)
         {
             [b_self showPolicys:result.dataList];
         }
         else
         {
             [METoast toastWithMessage:error.domain];
         }
     }];
}

/// 显示保险
- (void)showPolicys:(NSArray *)policys
{
    NSMutableArray *policyNames = [NSMutableArray array];
    for (HYPolicyType *policyType in policys)
    {
        [policyNames addObject:policyType.insuranceTypeName];
    }
    
    self.pickerView.dataSouce = policyNames;
    [self.pickerView showWithAnimation:YES];
    WS(weakSelf);
    self.pickerView.didSelectItem = ^(NSInteger idx) {
        HYPolicyType *selected = [policys objectAtIndex:idx];
        weakSelf.selectedPolicy = selected;
        [weakSelf.tableview reloadData];
    };
}

/// 获取已购买保险
-(void)getInsuranceResult
{
    BOOL isLogin = [[NSUserDefaults standardUserDefaults] boolForKey:kIsLogin];
    if (isLogin)
    {
        if (!_queryMemberInsuranceRequest)
        {
            _queryMemberInsuranceRequest = [[HYQueryMemberInsuranceRequest alloc] init];
        }
        _queryMemberInsuranceRequest.userId = [HYUserInfo getUserInfo].userId;
        
        [HYLoadHubView show];
        __weak typeof(self) b_self = self;
        [_queryMemberInsuranceRequest sendReuqest:^(id result, NSError *error) {
            
            HYPolicy *insuraceInfo = nil;
            if (result && [result isKindOfClass:[HYQueryMemberInsuranceResponse class]])
            {
                HYQueryMemberInsuranceResponse *response = (HYQueryMemberInsuranceResponse *)result;
                insuraceInfo = response.insuranceResualt;
            }
            [b_self updateViewWithInsuraceResult:insuraceInfo error:error];
        }];
    }
    else
    {
        _nullView.hidden = NO;
        _tableview.hidden = YES;
        _nullView.descInfo = @"登录后才可获取个人信息";
    }
}

/// 获取续费价格
- (void)updateViewWithInsuraceResult:(HYPolicy *)info error:(NSError *)error
{
    [HYLoadHubView dismiss];
    if (info)
    {
        _nullView.hidden = YES;
        _tableview.hidden = NO;
        
        self.userInfo.insurancePolicy = info;
        [self.userInfo saveData];
        
        self.policy = info;
        
        [_tableview reloadData];
    }
}

/// 续费
-(void)getInsuranceData
{
    //获得续保接口数据
    _insuranceRequest = [[HYUserUpgradeRequest alloc] init];
    _insuranceRequest.orderType = @"5";
    if ([self hasPurchasedPolicy]) {
        _insuranceRequest.policyType = _policy.policyType;
    } else if (_selectedPolicy) {
        _insuranceRequest.policyType = _selectedPolicy.insuranceTypeCode;
    }
    _insuranceRequest.isBuypolicy = @"1";
    _insuranceRequest.certificateCode = _idCardCode;
    _insuranceRequest.certificateNumber = _idCardNum;
    _insuranceRequest.realName = _realName;
    _insuranceRequest.sex = hyGetJavaSexStringFromSex(_sex).integerValue;
    _insuranceRequest.birthday = self.birthday;
    _insuranceRequest.mobilephone = self.userInfo.mobilePhone;
    
    [HYLoadHubView show];
    __weak typeof(self) b_self = self;
    [_insuranceRequest sendReuqest:^(id result, NSError *error) {
        
        [HYLoadHubView dismiss];
        if (result && [result isKindOfClass:[HYUserUpgradeResponse class]])
        {
            HYUserUpgradeResponse *response = ( HYUserUpgradeResponse *)result;
            [b_self updateViewWithData:response error:error];
        }
    }];
}

/// 续费数据更新
- (void)updateViewWithData:(HYUserUpgradeResponse*)response error:(NSError *)error
{
    if (response.status == 200)
    {
        HYPaymentViewController* payVC = [[HYPaymentViewController alloc]init];
        payVC.navbarTheme = self.navbarTheme;
        payVC.amountMoney = response.orderAmount;
        payVC.orderID = response.orderId;
        payVC.orderCode = response.orderNumber;
        payVC.type = Pay_Renewal;
        payVC.productDesc =[NSString stringWithFormat:@"【特奢汇】会员续费: %@", response.orderNumber]; //商品描述
        
        __weak typeof(self) bself = self;
        payVC.paymentCallback = ^(HYPaymentViewController *payvc, id data){
            [bself paymentCallback:payvc paydata:data];
        };
        [self.navigationController pushViewController:payVC animated:YES];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:error.domain
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (void)paymentCallback:(HYPaymentViewController *)payvc paydata:(id)data
{
    [payvc.navigationController popToRootViewControllerAnimated:YES];
    [UIAlertView showMessage:@"续费成功"];
}

#pragma mark - delegates
#pragma mark -- tableview
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows = 0;
    switch (section)
    {
        case 0:
            rows = (_idCardCode.integerValue == 1) ? 5 : 7;
            break;
        case 1:
            rows = 3;
            break;
        default:
            break;
    }
    return rows;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HYLoginV2SelectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"select"];
    if (!cell)
    {
        cell = [[HYLoginV2SelectCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"select"];
    }
//    HYPersonCell* cell = [tableView dequeueReusableCellWithIdentifier:@"InsuranceCell"];
//    if (cell == nil)
//    {
//        cell = [[HYPersonCell alloc]initWithStyle:UITableViewCellStyleDefault
//                                  reuseIdentifier:@"InsuranceCell"];
//    }
    if (indexPath.section == 0)
    {
        switch (indexPath.row)
        {
            case 0:
            {
                cell.textLabel.text = @"真实姓名";
                cell.detailTextLabel.text = _realName.length > 0 ? _realName : @"请输入真实姓名";
                cell.selectEnable = (_idAuth.integerValue) ? NO : YES;
                break;
            }
            case 1:
            {
                cell.textLabel.text = @"会员卡号";
                cell.detailTextLabel.text = self.userInfo.number;
                cell.selectEnable = NO;
                break;
            }
            case 2:
            {
                cell.textLabel.text = @"手机号码";
                cell.detailTextLabel.text = self.userInfo.mobilePhone;
                cell.selectEnable = NO;
                break;
            }
            case 3:
            {
                cell.textLabel.text = @"证件类型";
                cell.detailTextLabel.text = _idCardName.length > 0? _idCardName : @"选择证件类型";
                cell.selectEnable = (_idAuth.integerValue) ? NO : YES;
                break;
            }
            case 4:
            {
                cell.textLabel.text = @"证件号码";
                cell.detailTextLabel.text = _idCardNum.length > 0? _idCardNum: @"输入证件号码";
                cell.selectEnable = (_idAuth.integerValue) ? NO : YES;
                break;
            }
            case 5:
            {
                cell.textLabel.text = @"性别";
                cell.detailTextLabel.text = _idCardNum.length > 0? _idCardNum: @"输入证件号码";
                if (_sex == HYSexMale) {
                    cell.detailTextLabel.text = @"男";
                }
                else if (_sex == HYSexFemale) {
                    cell.detailTextLabel.text = @"女";
                }
                else {
                    cell.detailTextLabel.text = @"未知";
                }
                
                if (_userInfo.localSex != HYSexUnknown &&
                    _userInfo.idAuthentication.integerValue == 1)
                {
                    cell.selectEnable = NO;
                }
                else
                {
                    cell.selectEnable = YES;
                }
                break;
            }
            case 6:
            {
                cell.textLabel.text = @"出生日期";
                cell.detailTextLabel.text = _birthday.length > 0? _birthday: @"选择出生日期";
                cell.selectEnable = (_idAuth.integerValue) ? NO : YES;
            }
            default:
                break;
        }
    }
    else if (indexPath.section == 1)
    {
        switch (indexPath.row)
        {
            case 0:
            {
                cell.textLabel.text = @"保险类型";
                cell.detailTextLabel.text = [self hasPurchasedPolicy] ? _policy.insuranceTypeName : _selectedPolicy.insuranceTypeName;
                if (![self hasPurchasedPolicy] && !_selectedPolicy) {
                    cell.detailTextLabel.text = @"请选择保险类型";
                }
                /// 没有已买保险时，才可以编辑
                cell.selectEnable = _policy.insuranceTypeCode.length == 0;
                break;
            }
            case 1:
            {
                HYBaseLineCell *cell = [[HYBaseLineCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"check"];
                UIButton *buttonOfFooter = [[UIButton alloc]init];
                [buttonOfFooter setImage:[UIImage imageNamed:@"xb_04"] forState:UIControlStateNormal];
                [buttonOfFooter setImage:[UIImage imageNamed:@"xb_05"] forState:UIControlStateSelected];
                buttonOfFooter.frame = CGRectMake(15, 10, 80, buttonOfFooter.currentImage.size.height);
                [buttonOfFooter setTitle:@"同意" forState:UIControlStateNormal];
                [buttonOfFooter setTitleColor:[UIColor colorWithRed:18.0/255.0
                                                              green:146.0/255.0
                                                               blue:203.0/255.0
                                                              alpha:1.0]
                                     forState:UIControlStateNormal];
                buttonOfFooter.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
                buttonOfFooter.titleLabel.font = [UIFont systemFontOfSize:15];
                //添加点击事件
                [buttonOfFooter addTarget:self action:@selector(checkBoxClick:) forControlEvents:UIControlEventTouchDown];
                if ([self hasPurchasedPolicy] || _selectedPolicy)
                {
                    _continueInsurance.enabled = YES;
                    buttonOfFooter.selected = YES;
                }
                else
                {
                    _continueInsurance.enabled = NO;
                    buttonOfFooter.selected = NO;
                }
                self.buttonOfFooter = buttonOfFooter;
                
                HYUiunderlinedbutton *lookBtn = [HYUiunderlinedbutton underlinedButton];
                lookBtn.frame = CGRectMake(CGRectGetMaxX(buttonOfFooter.frame), CGRectGetMinY(buttonOfFooter.frame), 60, CGRectGetHeight(buttonOfFooter.frame));
                [lookBtn setTitle:@"保险条款" forState:UIControlStateNormal];
                [lookBtn.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
                [lookBtn setTitleColor:[UIColor colorWithRed:18.0/255.0
                                                       green:146.0/255.0
                                                        blue:203.0/255.0
                                                       alpha:1.0]
                              forState:UIControlStateNormal];
                [lookBtn setTitleColor:[UIColor colorWithRed:18.0/255.0
                                                       green:146.0/255.0
                                                        blue:203.0/255.0
                                                       alpha:1.0] forState:UIControlStateHighlighted];
                [lookBtn addTarget:self
                            action:@selector(checkProtocol:)
                  forControlEvents:UIControlEventTouchUpInside];
                self.lookBtn = lookBtn;
                
                [cell.contentView addSubview:buttonOfFooter];
                [cell.contentView addSubview:lookBtn];
                return cell;
                break;
            }
            case 2:
            {
                cell.textLabel.text = @"应付金额";
                NSString *gold = nil;
                if (self.userInfo.insurancePolicy.renewalFee && self.userInfo.insurancePolicy.points)
                {
                    gold = [NSString stringWithFormat:@"%@元+%@现金券",self.userInfo.insurancePolicy.renewalFee, self.userInfo.insurancePolicy.points];
                }
                
                cell.detailTextLabel.text = gold;
                self.gold = gold;
                cell.selectEnable = NO;
                break;
            }
            case 3:
            {
                NSString *days = self.userInfo.insurancePolicy.expiredDay;
                if ([days isEqualToString:@"0"])
                {
                    cell.textLabel.text = @"您的会员已过期";
                }else
                {
                    NSString *str = [NSString
                                     stringWithFormat:@"您的会员还有%@天到期",days];
                    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:str];
                    [attrStr addAttribute:NSForegroundColorAttributeName
                                    value:[UIColor colorWithRed:18.0/255.0
                                                          green:146.0/255.0
                                                           blue:203.0/255.0
                                                          alpha:1.0]
                                    range:NSMakeRange(6, days.length)];
                    cell.textLabel.attributedText = attrStr;
                }
                break;
            }
        }
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat height = 0;
    if (section == 1)
    {
        height = 30;
    }
    return height;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            //  修改姓名
            [self modifyUserName];
        }
        //证件类型
        else if (indexPath.row == 3)
        {
            [self modifyCardType];
        }
        else if (indexPath.row == 4)
        {
            //  证件号
            [self modifyCardNum];
        }
        else if (indexPath.row == 5)
        {
            [self modifySex];
        }
        else if (indexPath.row == 6)//选择出生日期
        {
            [self.view endEditing:YES];
            [self updatebirthday];
        }
    }
    else if (indexPath.section == 1)
    {
        //保险类型
        if (indexPath.row == 0)
        {
            [self fetchPolicys];
        }
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1)
    {
        //headerview
        UIView *header = [[UIView alloc]initWithFrame:
                          CGRectMake(0, 0, ScreenRect.size.width, 30)];
        header.backgroundColor = [UIColor colorWithWhite:.91 alpha:1.0f];
        UILabel *headerLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 5, 100, 20)];
        headerLabel.font = [UIFont systemFontOfSize:13];
        headerLabel.text = @"购买保险信息";
        headerLabel.textColor = [UIColor blackColor];
        [header addSubview:headerLabel];
        
        return header;
    }else
    {
        return nil;
    }
}

#pragma mark -- check insuarece delegate
- (void)didAgreeInsurance
{
    _isAgree = YES;
    _buttonOfFooter.selected = YES;
    _continueInsurance.enabled = YES;
}


#pragma mark -- alert
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 88)
    {
        [self checkBoxClick:self.buttonOfFooter];
        [self checkProtocol:nil];
    }
    else if (_isPaySucc && alertView.tag==100)
    {
        self.userInfo.realName = _realName;
        self.userInfo.certificateCode = _idCardCode;
        self.userInfo.certificateName = _idCardName;
        self.userInfo.certificateNumber = _idCardNum;
        [self.userInfo saveData];
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    [self checkProtocol:nil];
}

#pragma mark -- HYDatePickerViewDelegate
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

- (void)didSelectDate:(NSDate *)date
{
    self.birthday = [date timeDescription];
    NSIndexPath *index = [NSIndexPath indexPathForRow:6 inSection:0];
    NSArray *array = @[index];
    [_tableview reloadRowsAtIndexPaths:array
                      withRowAnimation:UITableViewRowAnimationAutomatic];
}


@end

