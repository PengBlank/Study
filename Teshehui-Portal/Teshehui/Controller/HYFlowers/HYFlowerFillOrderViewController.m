//
//  HYFlowerFillOrderViewController.m
//  Teshehui
//
//  Created by 回亿资本 on 14-4-18.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYFlowerFillOrderViewController.h"
#import "HYFlowerFillMessageViewController.h"
#import "HYPaymentViewController.h"
#import "HYFlowerOrderListViewController.h"
#import "HYFlightDateViewController.h"
#import "HYFlowerFullBuyerViewController.h"
#import "HYFlowerSummaryCell.h"
#import "HYFlowerMessageTableViewCell.h"
#import "HYFlowerTranInfoCell.h"
#import "HYFolwerDeliveryDateCell.h"
#import "HYLoadHubView.h"
#import "HYPickerToolView.h"
#import "HYUserInfo.h"
#import "NSDate+Addition.h"
#import "HYFlowerSetAddressViewController.h"
#import "HYAppDelegate.h"
#import "HYFlowerAddressInfo.h"

#import "HYFlowerFinishOrderRequest.h"
#import "HYFlowerFinishOrderResponse.h"

@interface HYFlowerFillOrderViewController ()
<
HYFlightDateViewControllerDelegate,
HYFlowerFillMessageViewControllerDelegate,
HYFlowerFullBuyerDelegate,
HYPickerToolViewDelegate,
HYFolwerSetAdressDelegate
>
{
    HYFlowerFinishOrderRequest *_orderRequest;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSString *deliveryDate;
@property (nonatomic, copy) NSString *message;

@property (nonatomic, strong) HYFlowerAddressInfo *recvAddress;

@property (nonatomic, assign) BOOL needSig;

@property (nonatomic, copy) NSString *sendUserName;
@property (nonatomic, copy) NSString *sendUserMobile;

@property(nonatomic, strong) HYFlowerOrderInfo *orderInfo;
@property(nonatomic, strong) HYUserInfo *userInfo;

@property (nonatomic, assign) HYSpendingPatterns spendPattern;  //消费方式
@property (nonatomic, strong) HYPickerToolView *spPickerView;

@end

@implementation HYFlowerFillOrderViewController

- (void)dealloc
{
    [_orderRequest cancel];
    _orderRequest = nil;
    [HYLoadHubView dismiss];
    
    [_spPickerView dismissWithAnimation:NO];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"填写订单";
        _needSig = NO;
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
    tableview.sectionFooterHeight = 10;
    tableview.sectionHeaderHeight = 0;
    tableview.backgroundColor = [UIColor clearColor];
    tableview.backgroundView = nil;
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 64)];
    
    UIButton* FinishOrderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    FinishOrderBtn.frame = TFRectMake(60, 18, 200, 44);
    [FinishOrderBtn setBackgroundImage:[[UIImage imageNamed:@"flower_bg_title_bar_88"] stretchableImageWithLeftCapWidth:2
                                                                                                           topCapHeight:10]
                              forState:UIControlStateNormal];
    [FinishOrderBtn setTitle:@"提交订单" forState:UIControlStateNormal];
    [FinishOrderBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    FinishOrderBtn.titleLabel.font = [UIFont systemFontOfSize:18.0f];
    [FinishOrderBtn addTarget:self
                       action:@selector(completeFlowerOrderEvent:)
             forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:FinishOrderBtn];
    tableview.tableFooterView = footerView;
    
    [self.view addSubview:tableview];
	self.tableView = tableview;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initDefDate];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    if (![self.view window])
    {
        [_tableView removeFromSuperview];
        _tableView = nil;
        
        self.view = nil;
    }
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

#pragma mark setter/getter
- (HYUserInfo *)userInfo
{
    if (!_userInfo)
    {
        _userInfo = [HYUserInfo getUserInfo];
    }
    
    return _userInfo;
}

- (HYPickerToolView *)spPickerView
{
    if (!_spPickerView)
    {
        _spPickerView = [[HYPickerToolView alloc] initWithFrame:TFRectMake(0, 0, CGRectGetWidth(self.view.frame), 260)];
        _spPickerView.delegate = self;
        _spPickerView.dataSouce = @[@"个人消费", @"企业消费"];
        _spPickerView.title = @"请选择消费种类";
    }
    
    return _spPickerView;
}

#pragma mark private methods
- (void)completeFlowerOrderEvent:(id)sender
{
    BOOL _isLogin = [[NSUserDefaults standardUserDefaults] boolForKey:kIsLogin];
    if (!_isLogin)
    {
        HYAppDelegate *appDelegate = (HYAppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate loadLoginView];
    }
    else
    {
        if (!self.recvAddress)
        {
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"请完善收货人信息"
                                                           message:nil
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil];
            [alert show];
        }
        else if (self.userInfo.enterpriseId.intValue>0 && self.spendPattern<=Undefind_SP)
        {
            [self.spPickerView showWithAnimation:YES];
        }
        else
        {
            [HYLoadHubView show];
            
            _orderRequest = [[HYFlowerFinishOrderRequest alloc] init];
            _orderRequest.userId = self.userInfo.userId;
            _orderRequest.itemTotalAmount = self.flowerDetailInfo.price;
            _orderRequest.productSKUCode = self.flowerDetailInfo.currentsSUK.productSKUId;
            _orderRequest.quantity = self.buyTotal;
            _orderRequest.price = self.flowerDetailInfo.currentsSUK.price;
            _orderRequest.bless = self.message;
            _orderRequest.deliveryTime = self.deliveryDate;
            _orderRequest.isAnonymous = !self.needSig;
            
            _orderRequest.presentName = self.sendUserName;
            _orderRequest.presentPhone = self.sendUserMobile;
            _orderRequest.receiverName = self.recvAddress.userName;
            _orderRequest.receiverPhone = self.recvAddress.mobile;
            _orderRequest.receiverAddress = self.recvAddress.detaillInfo;
            _orderRequest.provinceId =  self.recvAddress.province.adressid;
            _orderRequest.provinceName = self.recvAddress.province.name;
            _orderRequest.cityId = self.recvAddress.city.adressid;
            _orderRequest.cityName = self.recvAddress.city.name;
            _orderRequest.regionId = self.recvAddress.area.adressid;
            _orderRequest.regionName = self.recvAddress.area.name;
            
            if (self.spendPattern == Enterprise_SP)
            {
                _orderRequest.isEnterprise = self.userInfo.enterpriseId;
            }
            
            __weak typeof(self) b_self = self;
            [_orderRequest sendReuqest:^(id result, NSError *error) {
                
                HYFlowerFinishOrderResponse *response = nil;
                
                if (result && [result isKindOfClass:[HYFlowerFinishOrderResponse class]])
                {
                    response = ( HYFlowerFinishOrderResponse *)result;
                }
                
                [b_self flowerOrderFinished:response];
            }];
        }
    }
}

- (void)initDefDate
{
    if (!self.deliveryDate)
    {
        NSDate *date = [NSDate date];
        NSString *today = [date timeDescription];
        NSDate *nextDay = [NSDate dateFromString:today];
        nextDay = [NSDate dateWithTimeInterval:(24*60*60) sinceDate:nextDay];
        self.deliveryDate = [nextDay timeDescription];
    }
}

- (void)selectDeliveryDate
{
    HYFlightDateViewController *vc = [[HYFlightDateViewController alloc] init];
    vc.title = @"选择发货日期";
    vc.delegate = self;
    vc.singleWay = YES;
    vc.navbarTheme = self.navbarTheme;
    [self.navigationController pushViewController:vc
                                         animated:YES];
}

- (void)flowerOrderFinished:(HYFlowerFinishOrderResponse *)response
{
    [HYLoadHubView dismiss];
    
    if (response.status == 200)
    {
        self.orderInfo = response.orderInfo;
        
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                       message:@"添加订单成功!"
                                                      delegate:self
                                             cancelButtonTitle:nil
                                             otherButtonTitles:@"去支付",@"查看订单",nil];
        [alert show];
    }
    else
    {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                       message:@"添加订单失败!"
                                                      delegate:nil
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles:nil];
        [alert show];
    }
}

#pragma mark - HYPickerToolViewDelegate
- (void)selectComplete:(HYPickerToolView *)pickerView
{
    switch (pickerView.currentIndex)
    {
        case 0:
            self.spendPattern = Personal_SP;
            break;
        case 1:
            self.spendPattern = Enterprise_SP;
            break;
        default:
            break;
    }
    
    [self.tableView reloadData];
}

#pragma mark - Table view data source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = 1;
    if (section == 1)
    {
        if (self.userInfo.enterpriseId.intValue > 0)
        {
            count = 4;
        }
        else
        {
            count = 3;
        }
    }

    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 44.0f;
    
    if (indexPath.section == 0)
    {
        height = 160;
    }
    else if (indexPath.section==1)
    {
        if (indexPath.row == 1)
        {
            CGSize size = [self.recvAddress.fullAddress sizeWithFont:[UIFont systemFontOfSize:14]
                                                   constrainedToSize:CGSizeMake(220, 80)];
            size.height = (size.height>20) ? size.height : 20;
            height = size.height+40;
        }
        else if (indexPath.row == 2)
        {
            height = 60;
        }
    }
    else
    {
        CGSize size = [self.message sizeWithFont:[UIFont systemFontOfSize:14]
                               constrainedToSize:CGSizeMake(CGRectGetWidth(self.view.frame)-45, 80)];
        
        height = size.height+20;
        height = (height>40) ? height : 40;
    }
    
    return height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIImageView *v = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 30)];
    v.image = [[UIImage imageNamed:@"ticket_bg_gray_g5"] stretchableImageWithLeftCapWidth:2
                                                                             topCapHeight:4];
    UILabel *descLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 120, 20)];
    descLabel.font = [UIFont systemFontOfSize:14];
    descLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
    descLabel.backgroundColor = [UIColor clearColor];
    [v addSubview:descLabel];
    
    switch (section)
    {
        case 0:
            descLabel.text = @"鲜花信息";
            break;
        case 1:
            descLabel.text = @"配送信息";
            break;
        case 2:
            descLabel.text = @"祝福语";
            break;
            
        default:
            break;
    }
    return v;
}

//footer高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
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
    if (indexPath.section == 0)
    {
        static NSString *orderSummaryCellId = @"orderSummaryCellId";
        HYFlowerSummaryCell *cell = [tableView dequeueReusableCellWithIdentifier:orderSummaryCellId];
        if (cell == nil)
        {
            cell = [[HYFlowerSummaryCell alloc]initWithStyle:UITableViewCellStyleValue1
                                             reuseIdentifier:orderSummaryCellId];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        [cell setFlowerInfo:self.flowerDetailInfo];
        [cell setTotal:self.buyTotal];
        return cell;
    }
    else if (indexPath.section == 1)
    {
        if (indexPath.row == 0)
        {
            static NSString *deliveryDateCellId = @"deliveryDateCellId";
            HYFolwerDeliveryDateCell *cell = [tableView dequeueReusableCellWithIdentifier:deliveryDateCellId];
            if (cell == nil)
            {
                cell = [[HYFolwerDeliveryDateCell alloc]initWithStyle:UITableViewCellStyleSubtitle
                                                      reuseIdentifier:deliveryDateCellId];
                cell.textLabel.text = @"配送日期:";
                cell.selectionStyle = UITableViewCellSelectionStyleGray;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            
            cell.detailTextLabel.text = self.deliveryDate;
            return cell;
        }
        else if (indexPath.row == 3)
        {
            static NSString *spendingCellId = @"spendingCellId";
            HYBaseLineCell *cell = [tableView dequeueReusableCellWithIdentifier:spendingCellId];
            if (cell == nil)
            {
                cell = [[HYBaseLineCell alloc]initWithStyle:UITableViewCellStyleValue1
                                            reuseIdentifier:spendingCellId];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.selectionStyle = UITableViewCellSelectionStyleGray;
                cell.textLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
                cell.textLabel.font = [UIFont systemFontOfSize:15];
                cell.textLabel.backgroundColor = [UIColor clearColor];
                cell.textLabel.textAlignment = NSTextAlignmentLeft;
                cell.textLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
                cell.textLabel.text = @"消费类型";
                
                cell.detailTextLabel.textColor = [UIColor colorWithRed:23.0/255.0
                                                                 green:126.0/255.0
                                                                  blue:184.0/255.0
                                                                 alpha:1.0];
                cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
                cell.detailTextLabel.backgroundColor = [UIColor clearColor];
            }
            
            switch (self.spendPattern)
            {
                case Personal_SP:
                    cell.detailTextLabel.text = @"个人消费";
                    break;
                case Enterprise_SP:
                    cell.detailTextLabel.text = @"企业消费";
                    break;
                default:
                    break;
            }
            
            return cell;
        }
        else
        {
            static NSString *orderSettingCellId = @"orderSettingCellId";
            HYFlowerTranInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:orderSettingCellId];
            if (cell == nil)
            {
                cell = [[HYFlowerTranInfoCell alloc]initWithStyle:UITableViewCellStyleSubtitle
                                                  reuseIdentifier:orderSettingCellId];
                cell.selectionStyle = UITableViewCellSelectionStyleGray;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            
            if (indexPath.row == 1)
            {
                cell.textLabel.text = @"收花人: ";
                cell.detailTextLabel.text = @"配送地址: ";
                
                if ([self.recvAddress.userName length] > 0)
                {
                    cell.nameLabel.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
                    cell.nameLabel.text = self.recvAddress.userName;
                    
                    cell.descLabel.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
                    cell.descLabel.text = self.recvAddress.fullAddress;
                }
                else
                {
                    cell.nameLabel.textColor = [UIColor colorWithWhite:0.6 alpha:1.0];
                    cell.nameLabel.text = @"点击编辑收花人姓名";
                    
                    cell.descLabel.textColor = [UIColor colorWithWhite:0.6 alpha:1.0];
                    cell.descLabel.text = @"点击编辑收花地址";
                }
            }
            else
            {
                cell.textLabel.text = @"送花人: ";
                cell.detailTextLabel.text = @"电话: ";
                
                if ([self.sendUserName length] > 0)
                {
                    cell.nameLabel.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
                    cell.nameLabel.text = self.sendUserName;
                    
                    cell.descLabel.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
                    cell.descLabel.text = self.sendUserMobile;
                }
                else
                {
                    cell.nameLabel.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
                    cell.nameLabel.text = self.userInfo.realName;
                    
                    cell.descLabel.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
                    cell.descLabel.text = self.userInfo.mobilePhone;
                }
            }
            return cell;
        }
    }
    else
    {
        static NSString *MessageCellId = @"MessageCellId";
        HYFlowerMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MessageCellId];
        if (cell == nil)
        {
            cell = [[HYFlowerMessageTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault
                                                      reuseIdentifier:@"MessageCellId"];
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        if (self.message)
        {
            cell.textLabel.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
            cell.textLabel.text = self.message;
        }
        else
        {
            cell.textLabel.textColor = [UIColor colorWithWhite:0.6 alpha:1.0];
            cell.textLabel.text = @"点击编辑祝福语";
        }

        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
   
    if (indexPath.section==1)
    {
        if (indexPath.row == 0)
        {
            //设置配货时间
            [self selectDeliveryDate];
        }
        else if (indexPath.row == 1)
        {
            //现在下单只能使用地址id
            HYFlowerSetAddressViewController* vc = [[HYFlowerSetAddressViewController alloc]init];
            vc.delegate = self;
            vc.address = self.recvAddress;
            [self.navigationController pushViewController:vc animated:YES];
            /*
            HYDeliveryAddressViewController* addAdress = [[HYDeliveryAddressViewController alloc]init];
            addAdress.redThemeNavbar = self.redThemeNavbar;
            addAdress.type = 1;
            addAdress.delegate = self;
            [self.navigationController pushViewController:addAdress animated:YES];
             */
        }
        else if (indexPath.row == 3)
        {
            [self.spPickerView showWithAnimation:YES];
        }
        else
        {
            HYFlowerFullBuyerViewController *vc = [[HYFlowerFullBuyerViewController alloc] init];
            vc.delegate = self;
            if (!self.sendUserName)
            {
                vc.userName = self.userInfo.realName;
                vc.mobile = self.userInfo.mobilePhone;
            }
            else
            {
                vc.userName = self.sendUserName;
                vc.mobile = self.sendUserMobile;
            }
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    else if (indexPath.section == 2) //祝福语
    {
        HYFlowerFillMessageViewController *vc = [[HYFlowerFillMessageViewController alloc] init];
        vc.delegate = self;
        vc.message = self.message;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - HYFlowerFillMessageViewControllerDelegate
- (void)didFinishedMessage:(NSString *)message  needSig:(BOOL)needSig
{
    self.message = message;
    
    if ([message length] <= 0)
    {
        self.message = nil;
    }
    
    self.needSig = needSig;
    
    [self.tableView reloadData];
}

#pragma mark - HYFlightDateViewControllerDelegate
- (void)didSelectStartDate:(NSString *)start
                      week:(NSString *)week
{
    NSDate *now = [NSDate date];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    unsigned unitFlags = NSHourCalendarUnit;
    NSDateComponents* comp1 = [calendar components:unitFlags fromDate:now];
    
    //在当前下午5点之前的可以选择当天，不然无法选择当天
    if (comp1.hour >= 17)
    {
        NSDate *selectDay = [NSDate dateFromString:start];
        if ([selectDay isSameDay:now])
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提醒"
                                                                message:@"当前时间已经无法今日送达，请重新选择送花时间"
                                                               delegate:nil
                                                      cancelButtonTitle:nil
                                                      otherButtonTitles:@"确定", nil];
            [alertView show];
            return;
        }
    }
    
    self.deliveryDate = start;
    NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:1];
    if ([self.tableView cellForRowAtIndexPath:index])
    {
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:index]
                              withRowAnimation:UITableViewRowAnimationNone];
    }
}

#pragma mark - HYFolwerSetAdressDelegate
- (void)didSelectAdressInfo:(HYFlowerAddressInfo *)address
{
    self.recvAddress = address;
    
    NSIndexPath *index = [NSIndexPath indexPathForRow:1 inSection:1];
    if ([self.tableView cellForRowAtIndexPath:index])
    {
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:index]
                              withRowAnimation:UITableViewRowAnimationNone];
    }
}

#pragma mark - HYFlowerFullBuyerDelegate
- (void)didSelectedBuyerName:(NSString *)name mobile:(NSString *)mobile
{
    if (name)
    {
        self.sendUserMobile = mobile;
        self.sendUserName = name;
    }
    
    NSIndexPath *index = [NSIndexPath indexPathForRow:2 inSection:1];
    if ([self.tableView cellForRowAtIndexPath:index])
    {
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:index]
                              withRowAnimation:UITableViewRowAnimationNone];
    }
}

#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        if (self.orderInfo.order_no && self.orderInfo.order_id)
        {
            HYAlipayOrder *order = [[HYAlipayOrder alloc] init];
            order.partner = PartnerID;
            order.seller = SellerID;
            
            NSMutableString* nameStr = [[NSMutableString alloc]initWithCapacity:0];
            [nameStr appendString:@"【特奢汇鲜花】订单编号:"];
            
            order.tradeNO = self.orderInfo.order_no; //订单号（由商家自行制定）
            order.productName = [NSString stringWithFormat:@"%@%@",nameStr,self.orderInfo.order_no]; //商品标题
            order.productDescription = [NSString stringWithFormat:@"%@%@",nameStr,self.orderInfo.order_no]; //商品描述
            order.amount = self.orderInfo.pay_total; //商品价格
            HYPaymentViewController* payVC = [[HYPaymentViewController alloc]init];
            payVC.navbarTheme = self.navbarTheme;
            payVC.alipayOrder = order;
            payVC.amountMoney = self.orderInfo.pay_total;
            payVC.orderID = self.orderInfo.order_id;
            payVC.orderCode = self.orderInfo.order_no;
            payVC.type = Pay_Flower;
            [self.navigationController pushViewController:payVC animated:YES];
        }
    }
    else
    {
        HYFlowerOrderListViewController* orderList = [[HYFlowerOrderListViewController alloc]init];
        orderList.navbarTheme = self.navbarTheme;
        [self.navigationController pushViewController:orderList animated:YES];
    }
}

@end
