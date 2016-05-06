//
//  HYCIConfirmViewController.m
//  Teshehui
//
//  Created by 成才 向 on 15/7/1.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYCIConfirmViewController.h"
#import "HYCITableViewConfirmExpandCell.h"
#import "HYCITableViewConfirmDetailCell.h"
#import "HYCICheckBoxCell.h"
#import "HYCITableViewInputCell.h"
#import "HYCIConfirmTableDatasource.h"
#import "HYCIPersonInfo.h"
#import "HYKeyboardHandler.h"
#import "HYCICarInfoFillType.h"
#import "HYCIAddOrderRequest.h"
#import "HYUserInfo.h"
#import "HYCIAddOrderResponse.h"
#import "HYCIQuoteDeclarationViewController.h"
#import "HYCIGetPaymentURLRequest.h"
#import "HYCIGetPaymentURLResponse.h"
#import "HYCIConfirmPaymentViewController.h"
#import "HYCIConfirmCodeViewController.h"

@interface HYCIConfirmViewController ()
<UITableViewDataSource,
UITableViewDelegate,
HYCICheckBoxCellDelegate,
UITextFieldDelegate,
HYKeyboardHandlerDelegate,
UIAlertViewDelegate
>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) HYCIConfirmTableDatasource *tableDatasource;

@property (nonatomic, strong) UIButton *checkBtn;


@property (nonatomic, strong) HYCIPersonInfo *insuredInfo;
@property (nonatomic, strong) HYCIPersonInfo *applicantInfo;    //投保人信息

@property (nonatomic, strong) HYKeyboardHandler *keyboardHandler;

@property (nonatomic, strong) HYCIAddOrderRequest *addOrderRequest;
@property (nonatomic, strong) HYCIOrderDetail *order;

@property (nonatomic, assign) BOOL agreeStatement;

@end

@implementation HYCIConfirmViewController

- (void)dealloc
{
    [_keyboardHandler stopListen];
    [_addOrderRequest cancel];
    
    [HYLoadHubView dismiss];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"投保确认";
    
    self.view.backgroundColor = [UIColor colorWithWhite:.97 alpha:1];
    CGRect frame = self.view.bounds;
    frame.size.height -= 64;
    
    self.tableDatasource = [[HYCIConfirmTableDatasource alloc] init];
    
    [self.tableDatasource setInsureInfoRowCount:
     (1+2+_commercialInsureInfos.count+_forceInsureInfos.count)];
    
    self.tableView = [[UITableView alloc] initWithFrame:frame];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [self tableFooterView];
    [self.tableView registerNib:[UINib nibWithNibName:@"HYCITableViewConfirmExpandCell"
                                               bundle:nil]
         forCellReuseIdentifier:@"expandCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"HYCITableViewInputCell"
                                               bundle:nil]
         forCellReuseIdentifier:@"inputCell"];
    [self.view addSubview:self.tableView];
    
    self.keyboardHandler = [[HYKeyboardHandler alloc] initWithDelegate:self view:self.view];
    [self.keyboardHandler startListen];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (HYCIPersonInfo *)insuredInfo
{
    if (!_insuredInfo)
    {
        _insuredInfo = [[HYCIPersonInfo alloc] init];
        [_insuredInfo setWithOwnerInfo:self.ownerInfo];
    }
    return _insuredInfo;
}

- (HYCIPersonInfo *)applicantInfo
{
    if (!_applicantInfo)
    {
        _applicantInfo = [[HYCIPersonInfo alloc] init];
        [_applicantInfo setWithOwnerInfo:self.ownerInfo];
    }
    return _applicantInfo;
}

#pragma mark - private
- (UIView *)tableFooterView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                            0,
                                                            CGRectGetWidth(self.view.bounds),
                                                            100)];
    view.backgroundColor = [UIColor colorWithWhite:.97 alpha:1];
    //    UIImageView *_lineView = [[UIImageView alloc] initWithFrame:
    //                              CGRectMake(0, 0, CGRectGetWidth(view.frame), 1.0)];
    //    _lineView.image = [[UIImage imageNamed:@"line_cell_top"] stretchableImageWithLeftCapWidth:2
    //                                                                                 topCapHeight:0];
    //    [view addSubview:_lineView];
    
    UILabel *infoLab = [[UILabel alloc] initWithFrame:
                        CGRectMake(0, 0, CGRectGetWidth(self.view.bounds)/2, 40)];
    infoLab.numberOfLines = 0;
    infoLab.font = [UIFont systemFontOfSize:15.0];
    infoLab.textColor = [UIColor blackColor];
    infoLab.backgroundColor = [UIColor clearColor];
    infoLab.textAlignment = NSTextAlignmentCenter;
    infoLab.text = @"本人已认真阅读:";
    [view addSubview:infoLab];
    
    _checkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_checkBtn setFrame:CGRectMake(CGRectGetWidth(self.view.bounds)/2, 0, CGRectGetWidth(self.view.bounds)/2, 40)];
    [_checkBtn setImage:[UIImage imageNamed:@"icon_check"]
               forState:UIControlStateNormal];
    [_checkBtn setImage:[UIImage imageNamed:@"icon_check_on"]
               forState:UIControlStateSelected];
    [_checkBtn setTitle:@"同意" forState:UIControlStateNormal];
    [_checkBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_checkBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    _checkBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [_checkBtn addTarget:self
                  action:@selector(checkEvent:)
        forControlEvents:UIControlEventTouchUpInside];
    _checkBtn.selected = self.agreeStatement;
    [view addSubview:_checkBtn];
    
    UIImage *submit = [UIImage imageNamed:@"ci_btn_on"];
    submit = [submit stretchableImageWithLeftCapWidth:2 topCapHeight:2];
    UIButton *nextBtn = [[UIButton alloc] initWithFrame:
                         CGRectMake(CGRectGetMidX(self.view.bounds)-85, 50, 170, 35)];
    
    [nextBtn setBackgroundImage:submit forState:UIControlStateNormal];
    [nextBtn setTitle:@"提交" forState:UIControlStateNormal];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextBtn addTarget:self
                action:@selector(nextAction:)
      forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:nextBtn];
    return view;
}

- (void)checkEvent:(UIButton *)btn
{
    btn.selected = !btn.selected;
    self.agreeStatement = btn.selected;
}

- (void)nextAction:(UIButton *)btn
{
    [self addOrder];
}

- (void)addOrder
{
    if (_addOrderRequest) {
        [_addOrderRequest cancel];
    }
    else
    {
        _addOrderRequest = [[HYCIAddOrderRequest alloc] init];
    }
    
    NSString *err = nil;
    if (!self.agreeStatement)
    {
        err = @"请阅读并同意投保声明";
    }
    else
    {
        NSString *domain = [self.insuredInfo checkErrorDomain];
        if (domain)
        {
            err = [NSString stringWithFormat:@"请输入被保人%@", domain];
        }
        else
        {
            domain = [self.applicantInfo  checkErrorDomain];
            if (domain) {
                err = [NSString stringWithFormat:@"请输入投保人%@", domain];
            }
        }
    }
    if (err)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:err delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    _addOrderRequest.totalAmount = self.totalAmount;
    _addOrderRequest.points = self.points;
    _addOrderRequest.userId = [HYUserInfo getUserInfo].userId;
    _addOrderRequest.sessionid = self.sessionid;
    _addOrderRequest.ownerInfo = self.ownerInfo;
    _addOrderRequest.carInfo = self.carInfo;
    _addOrderRequest.insuredInfo = self.insuredInfo;
    _addOrderRequest.applicantInfo = self.applicantInfo;
    _addOrderRequest.deliverInfo = self.deliverInfo;
    _addOrderRequest.insureInfoList = self.commercialInsureInfos;
    _addOrderRequest.forceList = self.forceInsureInfos;
    _addOrderRequest.dateList = self.insureDates;
    [HYLoadHubView show];
    __weak typeof(self) b_self = self;
    [_addOrderRequest sendReuqest:^(id result, NSError *error)
    {
        [b_self updateWithAddOrderResponse:result error:error];
    }];
}

- (void)updateWithAddOrderResponse:(HYCIAddOrderResponse *)response error:(NSError *)error
{
    [HYLoadHubView dismiss];
    if (!error)
    {
        self.order = response.order;
        if (_order.isNeedCheckCode)
        {
            [self toCheckPhone];
        }
        else
        {
            [self toPayment];
        }
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:error.domain delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
}

- (void)toCheckPhone
{
    HYCIConfirmCodeViewController *confirmCode = [[HYCIConfirmCodeViewController alloc] init];
    confirmCode.sessionid = self.sessionid;
    confirmCode.order = self.order;
    [self.navigationController pushViewController:confirmCode animated:YES];
}

- (void)toPayment
{
    HYCIConfirmPaymentViewController *confirmPayment = [[HYCIConfirmPaymentViewController alloc] init];
    confirmPayment.order = self.order;
    confirmPayment.sessionid = self.sessionid;
    [self.navigationController pushViewController:confirmPayment animated:YES];
}


#pragma mark - checkbox cell
//这里展开投保人信息界面
- (void)checkBoxCellIsChecked:(HYCICheckBoxCell *)cell
{
    if (cell.path.section == 2 || cell.path.section == 3)
    {
//        self.tableDatasource
        HYCIConfirmSection section = cell.path.section == 2 ? HYCiConfirmSectionApplicant : HYCiConfirmSectionRecognizor;
        HYCIPersonInfo *person = cell.path.section == 2 ? self.applicantInfo : self.insuredInfo;
        [self.tableDatasource setSection:section isExpanded:!cell.isChecked];
        NSArray *insertRows = [NSArray arrayWithObjects:
                               [NSIndexPath indexPathForRow:1 inSection:cell.path.section],
                               [NSIndexPath indexPathForRow:2 inSection:cell.path.section],
                               [NSIndexPath indexPathForRow:3 inSection:cell.path.section],
                               [NSIndexPath indexPathForRow:4 inSection:cell.path.section], nil];
        if (cell.isChecked)
        {
            //投保人、被保人 同车主！
            [person setWithOwnerInfo:self.ownerInfo];
            
            [self.tableView deleteRowsAtIndexPaths:insertRows
                                  withRowAnimation:UITableViewRowAnimationLeft];
        }
        else
        {
            [self.tableView insertRowsAtIndexPaths:insertRows
                                  withRowAnimation:UITableViewRowAnimationLeft];
        }
    }
}

#pragma mark - tableview data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.tableDatasource.numOfSection;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tableDatasource numOfRowsInSection:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header = [[UIView alloc] initWithFrame:
                      CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 5)];
    UIImageView *_lineView = [[UIImageView alloc] initWithFrame:
                              CGRectMake(0, CGRectGetMaxY(header.bounds)-1, CGRectGetWidth(header.frame), 1.0)];
    _lineView.image = [[UIImage imageNamed:@"line_cell_top"] stretchableImageWithLeftCapWidth:2
                                                                                 topCapHeight:0];
    [header addSubview:_lineView];
    return header;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    indexPath = [self.tableDatasource transferedPathWithIndexPath:indexPath];
    if ((indexPath.section == 0
        || indexPath.section == 6
        || indexPath.section == 7)
        && indexPath.row == 0)
    {
        return 55;
    }
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //统一使用界面完全展开情况下的indexPath来进行数据管理
    indexPath = [self.tableDatasource transferedPathWithIndexPath:indexPath];
    
    if (indexPath.section == 0)
    {
        HYCITableViewConfirmExpandCell *expandCell = [tableView dequeueReusableCellWithIdentifier:@"expandCell"];
        expandCell.nameLab.text = @"订单信息";
        return expandCell;
    }
    else if (indexPath.section == 1)
    {
        //车主信息
        HYCITableViewConfirmDetailCell *detailCell = [tableView dequeueReusableCellWithIdentifier:@"detailCell"];
        if (!detailCell)
        {
            detailCell = [[HYCITableViewConfirmDetailCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"detailCell"];
        }
        if (indexPath.row == 0)
        {
            detailCell.textLabel.text = @"车主信息";
            detailCell.detailTextLabel.text = nil;
        }
        else
        {
            [self configureCarOwnerCell:detailCell withIndexPath:indexPath];
        }
        return detailCell;
    }
    else if (indexPath.section == 2)
    {
        //投保人信息
        if (indexPath.row == 0)
        {
            HYCICheckBoxCell* cell = [tableView dequeueReusableCellWithIdentifier:@"checkBoxCell"];
            if (!cell)
            {
                cell = [[HYCICheckBoxCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                               reuseIdentifier:@"checkBoxCell"];
            }
            [[(HYCICheckBoxCell *)cell textLabel] setText:@"投保人信息："];
            cell.detailTextLabel.text = @"同车主";
            cell.isChecked = ![self.tableDatasource sectionIsExpanded:HYCiConfirmSectionApplicant];
            cell.delegate = self;
            cell.path = indexPath;
            return cell;
        }
        else
        {
            HYCITableViewInputCell *detailCell = [tableView dequeueReusableCellWithIdentifier:@"inputCell"];
            detailCell.nameLab.font = [UIFont systemFontOfSize:14.0];
            [self configureApplicantCell:detailCell withIndexPath:indexPath];
            return detailCell;
        }
    }
    else if (indexPath.section == 3)
    {
        //被保人信息
        if (indexPath.row == 0)
        {
            HYCICheckBoxCell* cell = [tableView dequeueReusableCellWithIdentifier:@"checkBoxCell"];
            if (!cell)
            {
                cell = [[HYCICheckBoxCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                               reuseIdentifier:@"checkBoxCell"];
            }
            [[(HYCICheckBoxCell *)cell textLabel] setText:@"被保人信息："];
            cell.detailTextLabel.text = @"同车主";
            cell.isChecked = ![self.tableDatasource sectionIsExpanded:HYCiConfirmSectionRecognizor];
            cell.delegate = self;
            cell.path = indexPath;
            return cell;
        }
        else
        {
            HYCITableViewInputCell *detailCell = [tableView dequeueReusableCellWithIdentifier:@"inputCell"];
            detailCell.nameLab.font = [UIFont systemFontOfSize:14.0];
            [self configureRecognizorCell:detailCell withIndexPath:indexPath];
            return detailCell;
        }
    }
    else if (indexPath.section == 4)
    {
        //车辆信息
        HYCITableViewConfirmDetailCell *detailCell = [tableView dequeueReusableCellWithIdentifier:@"detailCell"];
        if (!detailCell)
        {
            detailCell = [[HYCITableViewConfirmDetailCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"detailCell"];
        }
        if (indexPath.row == 0)
        {
            detailCell.textLabel.text = @"车辆信息";
            detailCell.detailTextLabel.text = nil;
        }
        else
        {
            [self configureCarinfoCell:detailCell withIndexPath:indexPath];
        }
        return detailCell;
    }
    else if (indexPath.section == 5)
    {
        //保单信息
        HYCITableViewConfirmDetailCell *detailCell = [tableView dequeueReusableCellWithIdentifier:@"detailCell"];
        if (!detailCell)
        {
            detailCell = [[HYCITableViewConfirmDetailCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"detailCell"];
        }
        if (indexPath.row == 0)
        {
            detailCell.textLabel.text = @"保单信息";
            detailCell.detailTextLabel.text = nil;
        }
        else
        {
            [self configurePolicyCell:detailCell withIndexPath:indexPath];
        }
        return detailCell;
    }
    else if (indexPath.section == 6)
    {
        if (indexPath.row == 0)
        {
            HYCITableViewConfirmExpandCell *expandCell = [tableView dequeueReusableCellWithIdentifier:@"expandCell"];
            expandCell.nameLab.text = @"配送信息";
            return expandCell;
        }
        else
        {
            HYCITableViewConfirmDetailCell *detailCell = [tableView dequeueReusableCellWithIdentifier:@"detailCell"];
            if (!detailCell)
            {
                detailCell = [[HYCITableViewConfirmDetailCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"detailCell"];
            }
            [self configureDeliverCell:detailCell withIndexPath:indexPath];
            return detailCell;
        }
    }
    else if (indexPath.section == 7 )
    {
        HYCITableViewConfirmExpandCell *expandCell = [tableView dequeueReusableCellWithIdentifier:@"expandCell"];
        expandCell.nameLab.text = @"投保声明";
        return expandCell;
    }
    
    return nil;
}

- (void)configureDeliverCell:(HYCITableViewConfirmDetailCell *)cell withIndexPath:(NSIndexPath *)path
{
    switch (path.row)
    {
        case 1:
            cell.textLabel.text = @"收件人姓名";
            cell.detailTextLabel.text = self.deliverInfo.addressseeName;
            break;
        case 2:
            cell.textLabel.text = @"收件人电话";
            cell.detailTextLabel.text = self.deliverInfo.addressseeMobilephone;
            break;
        case 3:
            cell.textLabel.text = @"详细地址";
            cell.detailTextLabel.text = self.deliverInfo.addresseeDetails;
            break;
        case 4:
            cell.textLabel.text = @"被保人身份证地址";
            cell.detailTextLabel.text = self.deliverInfo.insuredAddresseeDetails;
            break;
        case 5:
            cell.textLabel.text = @"收件人姓名";
            cell.detailTextLabel.text = @"唐阳红";
            break;
        case 6:
            cell.textLabel.text = @"收件人姓名";
            cell.detailTextLabel.text = @"唐阳红";
            break;
        default:
            break;
    }
}

//车主信息
- (void)configureCarOwnerCell:(HYCITableViewConfirmDetailCell *)cell withIndexPath:(NSIndexPath *)path
{
    switch (path.row)
    {
        case 1:
            cell.textLabel.text = @"姓名:";
            cell.detailTextLabel.text = self.ownerInfo.ownerName;
            break;
        case 2:
            cell.textLabel.text = @"身份证:";
            cell.detailTextLabel.text = self.ownerInfo.ownerIdNo;
            break;
        case 3:
            cell.textLabel.text = @"手机:";
            cell.detailTextLabel.text = self.ownerInfo.ownerMobilephone;
            break;
        case 4:
            cell.textLabel.text = @"邮箱:";
            cell.detailTextLabel.text = self.ownerInfo.email;
            break;
        default:
            break;
    }
}

//投保人信息
- (void)configureApplicantCell:(HYCITableViewInputCell *)cell withIndexPath:(NSIndexPath *)path
{
    switch (path.row)
    {
        case 1:
            cell.nameLab.text = @"姓名:";
            cell.inputField.placeholder = self.applicantInfo.name;
            cell.inputField.delegate = self;
            cell.inputField.tag = path.section*100 + path.row;
            break;
        case 2:
            cell.nameLab.text = @"身份证号:";
            cell.inputField.placeholder = self.applicantInfo.idCardNo;
            cell.inputField.delegate = self;
            cell.inputField.tag = path.section*100 + path.row;
            break;
        case 3:
            cell.nameLab.text = @"手机号码:";
            cell.inputField.placeholder = self.applicantInfo.mobilephone;
            cell.inputField.delegate = self;
            cell.inputField.tag = path.section*100 + path.row;
            break;
        case 4:
            cell.nameLab.text = @"邮箱:";
            cell.inputField.placeholder = self.applicantInfo.email;
            cell.inputField.delegate = self;
            cell.inputField.tag = path.section*100 + path.row;
            break;
        default:
            break;
    }
}

//被保人信息
- (void)configureRecognizorCell:(HYCITableViewInputCell *)cell withIndexPath:(NSIndexPath *)path
{
    switch (path.row)
    {
        case 1:
            cell.nameLab.text = @"姓名:";
            cell.inputField.placeholder = self.insuredInfo.name;
            cell.inputField.delegate = self;
            cell.inputField.tag = path.section*100 + path.row;
            break;
        case 2:
            cell.nameLab.text = @"身份证号:";
            cell.inputField.placeholder = self.insuredInfo.idCardNo;
            cell.inputField.delegate = self;
            cell.inputField.tag = path.section*100 + path.row;
            break;
        case 3:
            cell.nameLab.text = @"手机号码:";
            cell.inputField.placeholder = self.insuredInfo.mobilephone;
            cell.inputField.delegate = self;
            cell.inputField.tag = path.section*100 + path.row;
            break;
        case 4:
            cell.nameLab.text = @"邮箱:";
            cell.inputField.placeholder = self.insuredInfo.email;
            cell.inputField.delegate = self;
            cell.inputField.tag = path.section*100 + path.row;
            break;
        default:
            break;
    }
}

//车辆信息
- (void)configureCarinfoCell:(HYCITableViewConfirmDetailCell *)cell withIndexPath:(NSIndexPath *)path
{
    switch (path.row)
    {
        case 1:
            cell.textLabel.text = @"车牌号:";
            cell.detailTextLabel.text = self.ownerInfo.plateNumber;
            break;
        case 2:
            cell.textLabel.text = @"车架号:";
            cell.detailTextLabel.text = self.carInfo.vehicleFrameNo;
            break;
        case 3:
            cell.textLabel.text = @"品牌型号:";
            cell.detailTextLabel.text = self.carInfo.vehicleModelName;
            break;
        case 4:
            cell.textLabel.text = @"发动机号:";
            cell.detailTextLabel.text = self.carInfo.engineNo;
            break;
        default:
            break;
    }
}

//保单信息
- (void)configurePolicyCell:(HYCITableViewConfirmDetailCell *)cell withIndexPath:(NSIndexPath *)path
{
    if (path.row == 1)
    {
        cell.textLabel.text = @"总价:";
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f", self.totalAmount];
    }
    else if (path.row == 2)
    {
        cell.textLabel.text = @"商业险投保日期:";
        if (self.insureDates.count > 0)
        {
            HYCICarInfoFillType *filltype = [self.insureDates objectAtIndex:0];
            cell.detailTextLabel.text = filltype.value;
        }
    }
    else if (path.row < (_commercialInsureInfos.count+2))
    {
        NSInteger index = path.row - 2;
        HYCICarInfoFillType *filltype = [_commercialInsureInfos objectAtIndex:index];
        cell.textLabel.text = filltype.inputShowName;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f",
                                     filltype.serverValue.floatValue];
    }
    else if (path.row == 2 + _commercialInsureInfos.count)
    {
        cell.textLabel.text = @"交强险投保日期:";
        if (self.insureDates.count > 1)
        {
            HYCICarInfoFillType *filltype = [self.insureDates objectAtIndex:1];
            cell.detailTextLabel.text = filltype.value;
        }
    }
    else
    {
        NSInteger index = path.row - 3 - _commercialInsureInfos.count;
        if (index < [self.forceInsureInfos count])
        {
            HYCICarInfoFillType *filltype = [self.forceInsureInfos objectAtIndex:index];
            cell.textLabel.text = filltype.inputShowName;
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f",
                                         filltype.serverValue.floatValue];
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //统一使用完全展开情况下的indexPath来进行判断
    NSIndexPath* transferedPath = [self.tableDatasource transferedPathWithIndexPath:indexPath];
    
    //配送信息
    if (transferedPath.section == 6 && transferedPath.row == 0)
    {
        BOOL expand = [self.tableDatasource sectionIsExpanded:HYCiConfirmSectionDeliver];
        [self.tableDatasource setSection:HYCiConfirmSectionDeliver isExpanded:!expand];
        NSArray *insertRows = [NSArray arrayWithObjects:
                               [NSIndexPath indexPathForRow:1 inSection:indexPath.section],
                               [NSIndexPath indexPathForRow:2 inSection:indexPath.section],
                               [NSIndexPath indexPathForRow:3 inSection:indexPath.section],
                               [NSIndexPath indexPathForRow:4 inSection:indexPath.section], nil];
        if (expand)
        {
            [tableView deleteRowsAtIndexPaths:insertRows
                             withRowAnimation:UITableViewRowAnimationLeft];
        }
        else
        {
            [tableView insertRowsAtIndexPaths:insertRows
                             withRowAnimation:UITableViewRowAnimationLeft];
        }
        
        HYCITableViewConfirmExpandCell *expandCell = (HYCITableViewConfirmExpandCell *)[tableView cellForRowAtIndexPath:indexPath];
        [expandCell setExpand:!expand];
    }
    
    //订单信息
    if (transferedPath.section == 0)
    {
        BOOL expand = [self.tableDatasource sectionIsExpanded:HYCiConfirmSectionOrder];
        [self.tableDatasource setSection:HYCiConfirmSectionOrder isExpanded:!expand];
        //1到5是展开订单信息时展开的section
        NSIndexSet *indexset = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1, 5)];
        if (expand)
        {
            [tableView deleteSections:indexset withRowAnimation:UITableViewRowAnimationLeft];
        }
        else
        {
            [tableView insertSections:indexset withRowAnimation:UITableViewRowAnimationLeft];
        }
        HYCITableViewConfirmExpandCell *expandCell = (HYCITableViewConfirmExpandCell *)[tableView cellForRowAtIndexPath:indexPath];
        [expandCell setExpand:!expand];
    }
    else if (transferedPath.section == 7)
    {
        HYCIQuoteDeclarationViewController *vc = [[HYCIQuoteDeclarationViewController alloc] initWithNibName:@"HYCIQuoteDeclarationViewController" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell isKindOfClass:[HYBaseLineCell class]])
    {
        NSInteger totalRow = [tableView numberOfRowsInSection:indexPath.section];
        if(indexPath.row == totalRow -1 || indexPath.row == 0)
        {
            HYBaseLineCell *lineCell = (HYBaseLineCell *)cell;
            lineCell.separatorLeftInset = 0.0f;
        }
        else
        {
            HYBaseLineCell *lineCell = (HYBaseLineCell *)cell;
            lineCell.separatorLeftInset = 15;
        }
    }
}

#pragma mark - scroll view
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.isDragging)
    {
        [self.view endEditing:YES];
    }
}

#pragma mark - text field
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.keyboardHandler.inputView = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSInteger section = textField.tag / 100;
    NSInteger row = textField.tag - section*100;
    HYCIPersonInfo *person = nil;
    if (section == 2)
    {
        person = self.applicantInfo;
    }
    else if (section == 3)
    {
        person = self.insuredInfo;
    }
    switch (row)
    {
        case 1:
            person.name = textField.text;
            break;
        case 2:
            person.idCardNo = textField.text;
            break;
        case 3:
            person.mobilephone = textField.text;
            break;
        case 4:
            person.email = textField.text;
            break;
        default:
            break;
    }
}

#pragma mark - keyboard
- (void)inputView:(UIView *)inputView willCoveredWithOffset:(CGFloat)offset
{
    NSLog(@"输入框被盖住");
    CGPoint contentOffset = self.tableView.contentOffset;
    contentOffset.y += offset;
    [self.tableView setContentOffset:contentOffset animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
