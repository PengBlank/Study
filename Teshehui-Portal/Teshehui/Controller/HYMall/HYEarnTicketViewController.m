//
//  HYEarnTicketViewController.m
//  Teshehui
//
//  Created by 成才 向 on 15/10/8.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYEarnTicketViewController.h"
#import "HYEarnTicketCell.h"
#import "HYVipUpdateViewController.h"
#import "HYUserInfo.h"
#import "HYFlightSearchViewController.h"
#import "HYHotelMainViewController.h"
#import "HYQRCodeEncoderViewController.h"
#import "HYGroupProtocolViewController.h"
#import "HYAppDelegate.h"
#import "HYUpdateToOfficialUserViewController.h"
#import "HYCIBaseInfoViewController.h"
#import "HYEarnTicketHeaderView.h"
#import "HYCallTaxiViewController.h"
#import "HYUpgradeAlertView.h"
#import "HYUserService.h"
#import "HYPaymentViewController.h"
#import "HYSiRedPacketsViewController.h"
#import "HYBusinessTypeDao.h"
#import "HYPhoneChargeViewController.h"

@interface HYEarnTicketViewController ()
<HYEarnTicketDelegate,
UITableViewDataSource,
UITableViewDelegate,
HYVipUpdateViewControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) HYUserService *userService;
@property (nonatomic, strong) NSArray<HYBusinessType *> *businessTypes;

@end

@implementation HYEarnTicketViewController

- (HYUserService *)userService
{
    if (!_userService) {
        _userService = [[HYUserService alloc] init];
    }
    return _userService;
}

- (void)loadView
{
    CGRect frame = [[UIScreen mainScreen] bounds];
    frame.size.height -= (64);
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor colorWithRed:237.0/255.0
                                           green:237.0/255.0
                                            blue:237.0/255.0
                                           alpha:1.0];
    self.view = view;
    
    //tableview
    frame.size.height -= TFScalePoint(kTabBarHeight);

    UITableView *tableview = [[UITableView alloc] initWithFrame:frame
                                                          style:UITableViewStylePlain];
    tableview.delegate = self;
    tableview.dataSource = self;
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableview.backgroundColor = [UIColor clearColor];
    tableview.backgroundView = nil;
    tableview.rowHeight = 0.29 * frame.size.width;
    tableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [tableview registerClass:[HYEarnTicketCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:tableview];
    self.tableView = tableview;
    
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"HYEarnTicketFooterView" owner:nil options:nil];
    if (views.count > 0)
    {
        tableview.tableFooterView = [views objectAtIndex:0];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"1:1赚现金券,可以当钱花哦";
    
    HYBusinessTypeDao *dao = [[HYBusinessTypeDao alloc] init];
    self.businessTypes = [dao queryEntitiesWhere:@"isBusinessTypeOpen = 1"];
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.baseViewController setTabbarShow:YES];
    HYUserInfo *user = [HYUserInfo getUserInfo];
    //体验用户
    BOOL isExperienceUser = (user && user.userLevel == 0);
    if (isExperienceUser)
    {
        HYEarnTicketHeaderView *head = [[HYEarnTicketHeaderView alloc]
                                        initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
        self.tableView.tableHeaderView = head;
        __weak typeof(self) weakSelf = self;
        head.didClickUpdate = ^
        {
            [weakSelf didSelectUpgrad];
        };
    }
    else
    {
        self.tableView.tableHeaderView = nil;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    BOOL hasAir = NO;
    for (HYBusinessType *type in self.businessTypes)
    {
        if ([type.businessTypeCode isEqualToString:BusinessType_Flight])
        {
            hasAir = YES;
            break;
        }
    }
    NSInteger count = self.businessTypes.count;
    if (hasAir) {
        /// 如果有飞机，那么 count = (count - 1 + 1) / 2 + 1.即，减去飞机数，+1/2算得行数，再加上单个飞机行
        count = count / 2 + 1;
    }
    else {
        /// 没有飞机，那么 +1 / 2即算出总行数
        count = (count + 1) / 2;
    }
    return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HYEarnTicketCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.delegate = self;
    HYBusinessType *leftType = nil;
    HYBusinessType *rightType = nil;
    HYBusinessType *firstType = nil;
    if (self.businessTypes.count > 0) {
        firstType = [self.businessTypes objectAtIndex:0];
    }
    /// 如果有飞机行，那么分开算第一行和其他行
    if (firstType && [firstType.businessTypeCode isEqualToString:BusinessType_Flight])
    {
        if (indexPath.section == 0)
        {
            leftType = firstType;
            cell.isFull = YES;
        }
        else
        {
            cell.isFull = NO;
            NSMutableArray *tmp = [self.businessTypes mutableCopy];
            [tmp removeObjectAtIndex:0];
            NSInteger section = indexPath.section - 1;
            if (section * 2 < tmp.count) {
                leftType = [tmp objectAtIndex:(section*2)];
            }
            if (section * 2 + 1 < tmp.count) {
                rightType = [tmp objectAtIndex:(section*2+1)];
            }
        }
    }
    else
    {
        cell.isFull = NO;
        if (indexPath.section * 2 < self.businessTypes.count) {
            leftType = [self.businessTypes objectAtIndex:(indexPath.section*2)];
        }
        if (indexPath.section * 2 + 1 < self.businessTypes.count) {
            rightType = [self.businessTypes objectAtIndex:(indexPath.section*2+1)];
        }
    }
    cell.leftBusinessType = leftType;
    cell.rightBusinessType = rightType;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section)
    {
        return 10;
    }
    return 0;
}

- (void)didSelectWithEarnType:(HYBusinessType*)type
{
    if ([type.businessTypeCode isEqualToString:BusinessType_Flight]) {
        HYFlightSearchViewController *vc = [[HYFlightSearchViewController alloc] init];
        [self.baseViewController setTabbarShow:NO];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([type.businessTypeCode isEqualToString:BusinessType_Hotel]) {
        HYHotelMainViewController *vc = [[HYHotelMainViewController alloc] init];
        [self.baseViewController setTabbarShow:NO];
        vc.navbarTheme = HYNavigationBarThemeBlue;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([type.businessTypeCode isEqualToString:BusinessType_Flower]) {
        HYGroupProtocolViewController *webBrowser = [[HYGroupProtocolViewController alloc] init];
        [self.baseViewController setTabbarShow:NO];
        webBrowser.type = Flower;
        [self.navigationController pushViewController:webBrowser animated:YES];
    }
    else if ([type.businessTypeCode isEqualToString:BusinessType_O2O_QRScan]) {
        HYQRCodeEncoderViewController *vc = [[HYQRCodeEncoderViewController alloc] init];
        [self.baseViewController setTabbarShow:NO];
        vc.showBottom = YES;
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent
                                                    animated:YES];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([type.businessTypeCode isEqualToString:BusinessType_Yangguang]) {
        NSString *userid = [HYUserInfo getUserInfo].userId;
        if (userid)
        {
            HYCIBaseInfoViewController *webBrowser = [[HYCIBaseInfoViewController alloc] init];
            [self.baseViewController setTabbarShow:NO];
            
            [self.navigationController pushViewController:webBrowser animated:YES];
        }
        else
        {
            HYAppDelegate *appDelegate = (HYAppDelegate *)[[UIApplication sharedApplication] delegate];
            [appDelegate loadLoginView];
        }
    }
    else if ([type.businessTypeCode isEqualToString:BusinessType_Meituan]) {
        HYGroupProtocolViewController *webBrowser = [[HYGroupProtocolViewController alloc] init];
        webBrowser.type = Meituan;
        [self.baseViewController setTabbarShow:NO];
        
        [self.navigationController pushViewController:webBrowser animated:YES];
    }
    else if ([type.businessTypeCode isEqualToString:BusinessType_DidiTaxi]) {
        NSString *userid = [HYUserInfo getUserInfo].userId;
        if (userid)
        {
            HYCallTaxiViewController *vc = [[HYCallTaxiViewController alloc] initWithNibName:@"HYCallTaxiViewController" bundle:nil];
            [self.baseViewController setTabbarShow:NO];
            
            [self.navigationController pushViewController:vc animated:YES];
        }
        else
        {
            HYAppDelegate *appDelegate = (HYAppDelegate *)[[UIApplication sharedApplication] delegate];
            [appDelegate loadLoginView];
        }
    }
    else if ([type.businessTypeCode isEqualToString:BusinessType_MeiQiqi]) {
        
//        HYPhoneChargeViewController *vc = [[HYPhoneChargeViewController alloc] init];
//        [self.baseViewController setTabbarShow:NO];
//        [self.navigationController pushViewController:vc animated:YES];
//        return;
        
        HYGroupProtocolViewController *webBrowser = [[HYGroupProtocolViewController alloc] init];
        webBrowser.type = MeiWeiQiQi;
        [self.baseViewController setTabbarShow:NO];
        
        [self.navigationController pushViewController:webBrowser animated:YES];
    }
    /// 话费充值入口点
    else if ([type.businessTypeCode isEqualToString:BusinessType_PhoneCharge])
    {
        BOOL login = [[NSUserDefaults standardUserDefaults] boolForKey:kIsLogin];
        if (login)
        {
            HYPhoneChargeViewController *vc = [[HYPhoneChargeViewController alloc] init];
            [self.baseViewController setTabbarShow:NO];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else
        {
            HYAppDelegate *appDelegate = (HYAppDelegate *)[[UIApplication sharedApplication] delegate];
            [appDelegate loadLoginView];
        }
    }
    /// 电影票入口点
    else if ([type.businessTypeCode isEqualToString:BusinessType_MovieTicket])
    {
        HYGroupProtocolViewController *webBrowser = [[HYGroupProtocolViewController alloc] init];
        webBrowser.type = MovieTicket;
        [self.baseViewController setTabbarShow:NO];
        [self.navigationController pushViewController:webBrowser animated:YES];
    }
}

#pragma mark - HYVipUpdateViewControllerDelegate
- (void)didSelectUpgrad
{
    HYUpgradeAlertView *alert = [[HYUpgradeAlertView alloc] initWithFrame:CGRectMake(0, 0, 240, 100)];
    [alert showWithAnimation:YES];
    alert.handler = ^(NSInteger buttonIndex)
    {
        if (buttonIndex == 0)
        {
            [HYLoadHubView show];
            WS(weakSelf);
            [self.userService upgradeWithNoPolicy:^(HYUserUpgradeResponse *response)
             {
                 [HYLoadHubView dismiss];
                 if (response.status == 200)
                 {
                     HYPaymentViewController* payVC = [[HYPaymentViewController alloc]init];
                     payVC.navbarTheme = weakSelf.navbarTheme;
                     payVC.amountMoney = response.orderAmount;
                     payVC.orderID = response.orderId;
                     payVC.orderCode = response.orderNumber;
                     payVC.type = Pay_Upgrad;
                     payVC.productDesc = [NSString stringWithFormat:@"【特奢汇】在线购卡: %@", response.orderNumber]; //商品描述
                     
                     [weakSelf.navigationController pushViewController:payVC animated:YES];
                     [weakSelf.baseViewController setTabbarShow:NO];
                     
                     payVC.paymentCallback = ^(HYPaymentViewController *payvc, id data)
                     {
                         [payvc.navigationController popToRootViewControllerAnimated:YES];
                         [HYSiRedPacketsViewController showWithPoints:@"1000" completeBlock:nil];
                     };
                 }
                 else
                 {
                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:response.suggestMsg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                     [alert show];
                 }
             }];
        }
        else if (buttonIndex == 1)
        {
            //升级会员
            HYUpdateToOfficialUserViewController *vc = [HYUpdateToOfficialUserViewController new];
            //            HYMemberUpgradeViewController *vc = [[HYMemberUpgradeViewController alloc] init];
            [self.baseViewController setTabbarShow:NO];
            [self.navigationController pushViewController:vc
                                                 animated:YES];
        }
    };
    
//    HYUpdateToOfficialUserViewController *vc =[HYUpdateToOfficialUserViewController new];
//    //    HYMemberUpgradeViewController *vc = [[HYMemberUpgradeViewController alloc] init];
//    [self.navigationController pushViewController:vc
//                                         animated:YES];
}

- (void)didSelectContinue:(HYVipUpdateViewController *)vc
{
    
    switch (vc.curType)
    {
        case AirTickets:
        {
            HYFlightSearchViewController *vc = [[HYFlightSearchViewController alloc] init];
            [self.baseViewController setTabbarShow:NO];
            //            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent
            //                                                        animated:YES];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case Hotel:
        {
            HYHotelMainViewController *vc = [[HYHotelMainViewController alloc] init];
            [self.baseViewController setTabbarShow:NO];
            vc.navbarTheme = HYNavigationBarThemeBlue;
            //            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent
            //                                                        animated:YES];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case Flower:
        {
            HYGroupProtocolViewController *webBrowser = [[HYGroupProtocolViewController alloc] init];
            [self.baseViewController setTabbarShow:NO];
            webBrowser.type = Flower;
            [self.navigationController pushViewController:webBrowser animated:YES];
            
            /*            HYFlowerMainViewController *vc = [[HYFlowerMainViewController alloc] init];
             [self.baseViewController setTabbarShow:NO];
             [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent
             animated:YES];
             [self.navigationController pushViewController:vc animated:YES];
             */
        }
            break;
        case QRScanInfo:
        {
            HYQRCodeEncoderViewController *vc = [[HYQRCodeEncoderViewController alloc] init];
            [self.baseViewController setTabbarShow:NO];
            vc.showBottom = YES;
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent
                                                        animated:YES];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case CarInsurance:
        {
            NSString *userid = [HYUserInfo getUserInfo].userId;
            if (userid)
            {
                HYCIBaseInfoViewController *webBrowser = [[HYCIBaseInfoViewController alloc] init];
                [self.baseViewController setTabbarShow:NO];
                
                [self.navigationController pushViewController:webBrowser animated:YES];
            }
            else
            {
                HYAppDelegate *appDelegate = (HYAppDelegate *)[[UIApplication sharedApplication] delegate];
                [appDelegate loadLoginView];
            }
        }
            break;
        case Meituan:
        {
            HYGroupProtocolViewController *webBrowser = [[HYGroupProtocolViewController alloc] init];
            webBrowser.type = Meituan;
            [self.baseViewController setTabbarShow:NO];
            
            [self.navigationController pushViewController:webBrowser animated:YES];
        }
            break;
        default:
            break;
    }
}

/*
- (void)checkBusinessType:(NSString *)buisinessType
{
    BusinessType type = 0;
    if ([buisinessType isEqualToString:BusinessType_Flight]) {
        type = AirTickets;
    }
    else if ([buisinessType isEqualToString:BusinessType_Hotel]) {
        type = Hotel;
    }
    else if ([buisinessType isEqualToString:BusinessType_Flower]) {
        type = Flower;
    }
    else if ([buisinessType isEqualToString:BusinessType_DidiTaxi]) {
        type = DidiTaxi;
    }
    else if ([buisinessType isEqualToString:BusinessType_Meituan]) {
        type = Meituan;
    }
    else if ([buisinessType isEqualToString:BusinessType_MeiQiqi]) {
        type = MeiWeiQiQi;
    }
    else if ([buisinessType isEqualToString:BusinessType_Yangguang]) {
        type = CarInsurance;
    }
    
//    if (type > 0)
//    {
//        [self didSelectWithEarnType:type];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [self.baseViewController setTabbarShow:NO];
//        });
//    }
}
 */

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
