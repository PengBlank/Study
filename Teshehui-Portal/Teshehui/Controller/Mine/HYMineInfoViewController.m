//
//  CQVIPViewController.m
//  Teshehui
//
//  Created by ChengQian on 13-10-25.
//  Copyright (c) 2013年 Charse. All rights reserved.
//

#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentApiInterface.h>

#import "HYChatManager.h"

#import "HYMineInfoViewController.h"
#import "HYMyInformationViewController.h"
#import "HYUserInfo.h"
#import "HYMineInfoCell.h"
#import "HYMineInfoWalletCell.h"
#import "HYMineInfoServiceCell.h"
#import "HYAppDelegate.h"
#import "HYGetPersonRequest.h"
#import "HYGetPersonResponse.h"
#import "METoast.h"
#import "PTHttpManager.h"
#import "HYEmployeesListViewController.h"
#import "HYMineCardViewController.h"
#import "HYGetRedpacketCountReq.h"
#import "HYInsuranceViewController.h"
#import "HYMineInfoHeadCell.h"
#import "HYMineInfoOrderCell.h"
#import "HYAfterSaleViewController.h"
#import "HYAccountBalanceViewController.h"
#import "UIImage+Addition.h"
#import "UIAlertView+BlocksKit.h"
#import "HYUserService.h"
#import "HYPaymentViewController.h"
#import "HYMallWebViewController.h"
#import "HYGetShareViewReq.h"

#import "HYSettingsViewController.h"
#import "HYVipUpdateViewController.h"
#import "HYSiRedPacketsViewController.h"
#import "Masonry.h"
#import "HYImageButton.h"

//新增订单列表入口和收藏入口
#import "HYHotelOrderListViewController.h"
#import "HYMallOrderListViewController.h"
#import "HYFlowerOrderListViewController.h"
#import "HYFlightOrderListViewController.h"
#import "HYMeituanOrderListViewController.h"
#import "HYMallFavoritesViewController.h"
#import "HYCIOrderListViewController.h"
#import "HYMallCartViewController.h"
#import "HYTaxiOrderListViewController.h"
#import "OrderGroupViewController.h"

//会员福利界面
#import "HYBenefitViewController.h"
#import "HYUpgradeAlertView.h"

//头像
#import "HYImageUtilGetter.h"
#import "HYUserPortraitRequest.h"


#import "HYUpdateToOfficialUserViewController.h"

//两个帐户余额
#import "HYUserVirtualAccountInfoRequest.h"
#import "HYUserCashAccountInfoRequest.h"

//分享送现金券
#import "HYShareGetPointViewController.h"
#import "HYShareGetPointView.h"

#import "HYVipUpdateViewController.h"

//帮我买
#import "HYMyDesirePoolViewController.h"
#import "UIImage+Addition.h"

#import "HYShakeViewController.h"

#import "HYMallApplyAfterSaleServiceViewController.h"

#import "HYDataManager.h"

/// 我的钱包
#import "HYWalletViewController.h"
#import "HYRedpacketsHomeViewController.h"
#import "HYPointsViewController.h"

/// 订单选择
#import "HYOrderSelectView.h"
#import "HYMineAllOrderViewController.h"


#import "HYQueryUserBadgeDataService.h"

#import "HYPhoneChargeViewController.h"

//O2O实体店余额
#import "UserBalanceRequest.h"
#import "StoreBalanceViewController.h"

//检查是否登录
#define CHECK_LOGIN if (!_isLogin) \
{\
    [self loginEvent:nil];\
    return;\
}\

#define kOrderBadgeService  @"OrderBadgeService"
#define kCartBadgeService  @"CartBadgeService"

@interface HYMineInfoViewController ()
<
UIActionSheetDelegate,
HYMineInfoHeadCellDelegate,
HYMineInfoWalletCellDelegate,
HYMineINfoServiceCellDelegate,
HYVipUpdateViewControllerDelegate
>
{
    HYGetPersonRequest* _getUserInfoReq;
    HYGetRedpacketCountReq *_getRedpacketReq;
    HYUserPortraitRequest *_portraitRequest;
    HYUserVirtualAccountInfoRequest *_virtualAccountRequest;
    HYUserCashAccountInfoRequest *_cashAccountRequest;
    UserBalanceRequest *_userO2OBalanceRequest;
    HYGetShareViewReq *_getShareViewReq;
    
    BOOL _isLogin;
    
    //标志位是否显示订单cell
    BOOL _showOrderCells;
    
    /// 数量
    NSInteger _redPacketCount;
    NSInteger _cartCount;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) HYUserInfo  *userInfo;
@property (nonatomic, strong) HYUserService *userService;
@property (nonatomic, strong) UIBarButtonItem *settingItem;
@property (nonatomic, strong) UIImageView *guide;
@property (nonatomic, strong) HYImageButton *cartBtn;
@property (nonatomic, assign) BOOL hasNewRedPacket;

@property (nonatomic, assign) NSInteger unPayOrderCount;
@property (nonatomic, assign) NSInteger unSendOrderCount;
@property (nonatomic, assign) NSInteger unRecvOrderCount;

@property (nonatomic, assign) NSInteger sendRPCount;
@property (nonatomic, assign) NSInteger recvRPCount;

@property (nonatomic, assign) NSInteger shoppingCartCount;

//现金和现金券帐户
@property (nonatomic, strong) HYUserCashAccountInfo *cashAccount;
@property (nonatomic, strong) HYUserVirutalAccountInfo *virtualAccount;
@property (nonatomic, assign) double o2oBalance;    ///实体店余额


@property (nonatomic, strong) NSDictionary *badgeServiceDic;

@end

UIKIT_EXTERN NSString * const LoginStatusChangeNotification;

@implementation HYMineInfoViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:LoginStatusChangeNotification object:nil];
    
    [HYLoadHubView dismiss];
    
    [_getUserInfoReq cancel];
    _getUserInfoReq = nil;
    
    [_getRedpacketReq cancel];
    _getRedpacketReq = nil;
    
    [_portraitRequest cancel];
    _getRedpacketReq = nil;
    
    [_virtualAccountRequest cancel];
    _virtualAccountRequest = nil;
    
    [_cashAccountRequest cancel];
    _cashAccountRequest = nil;
    
    [_userO2OBalanceRequest cancel];
    _userO2OBalanceRequest = nil;
    
    [_getShareViewReq cancel];
    _getShareViewReq = nil;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _showOrderCells = NO;
        self.title = @"我";
    }
    return self;
}

- (void)loadView
{
    CGRect frame = [[UIScreen mainScreen] bounds];
    frame.size.height -= 64;
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor colorWithRed:237.0f/255.0f
                                           green:237.0f/255.0f
                                            blue:237.0f/255.0f
                                           alpha:1.0];
    self.view = view;
    
    //tableview
    frame.size.height -= TFScalePoint(kTabBarHeight);
    UITableView *tableview = [[UITableView alloc] initWithFrame:frame
                                                          style:UITableViewStylePlain];
    tableview.delegate = self;
    tableview.dataSource = self;
    tableview.backgroundColor = [UIColor clearColor];
    tableview.backgroundView = nil;
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIImageView *lineView = [[UIImageView alloc] initWithFrame:TFRectMakeFixWidth(0, 0, 320, 1.0)];
    lineView.image = [[UIImage imageNamed:@"line_cell_bottom"] stretchableImageWithLeftCapWidth:2
                                                                                   topCapHeight:0];
    tableview.tableHeaderView = lineView;
    [tableview registerClass:[HYMineInfoOrderCell class] forCellReuseIdentifier:@"orderCell"];
    [tableview registerClass:[HYMineInfoWalletCell class] forCellReuseIdentifier:@"walletCell"];
    [self.view addSubview:tableview];
    self.tableView = tableview;
    
    //购物车button
    WS(weakSelf);
    HYImageButton *cartBtn = [HYImageButton buttonWithType:UIButtonTypeCustom];
    [cartBtn setImage:[UIImage imageNamed:@"mine_shoppingCart"]
             forState:UIControlStateNormal];
    [self.view addSubview:cartBtn];
    [cartBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.view.mas_right).with.offset(-30);
        make.bottom.equalTo(weakSelf.view.mas_bottom).with.offset(-70);
        make.width.equalTo(@40);
        make.height.equalTo(@40);
    }];
//    cartBtn.hidden = !_isLogin;
    [cartBtn addTarget:self action:@selector(goToCart) forControlEvents:UIControlEventTouchUpInside];
    self.cartBtn = cartBtn;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = self.settingItem;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"HYMineInfoHeadCell" bundle:nil]
         forCellReuseIdentifier:@"headCell"];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:LoginStatusChangeNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                              selector:@selector(updateWithLoginChange:)
                                                  name:LoginStatusChangeNotification object:nil];
    
    _isLogin = [[NSUserDefaults standardUserDefaults] boolForKey:kIsLogin];
    
//    [[HYDataManager sharedManager] queryNewRedpacketCount:^(NSInteger newCount)
//    {
//        _redPacketCount = newCount;
//        _hasNewRedPacket = newCount > 0;
//        [self.tableView reloadData];
//    } needRefresh:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [HYLoadHubView dismiss];
    
    [self.baseViewController setTabbarShow:YES];
    
    if (_isLogin)   //已登陆则更新用户信息，成功后会刷新界面
    {
        self.userInfo = [HYUserInfo getUserInfo];
        [self updateUserInfo];  //更新用户信息
        [self updateUserAccount];  //更新用户钱包
        [self updateO2OBalace];
        [self resetBadgeCount];
        [self getViewMarkDataWithType:WalletAndOrderbadge];  //更新订单信息
        [self getViewMarkDataWithType:ShoppingCartBadge];//购物车信息
    }
    else    //否则直接刷新界面
    {
        [self resetBadgeCount];
        self.cashAccount = nil;
        self.virtualAccount = nil;
        self.o2oBalance = 0;
        [self.tableView reloadData];
    }
    
    [self updatetabbarItem];
}

- (void)resetBadgeCount
{
    self.unPayOrderCount = 0;
    self.unSendOrderCount = 0;
    self.unRecvOrderCount = 0;
    self.sendRPCount = 0;
    self.recvRPCount = 0;
    self.shoppingCartCount = 0;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    /// 分享赚现金券
//    if (_isLogin)
    {
        [[HYShareGetPointView sharedView] showInView:self.view];
        [HYShareGetPointView sharedView].didCheck = ^
        {
            CHECK_LOGIN
            [MobClick event:kMineShareToEarnBtn];
            
            HYShareGetPointViewController *vc = [[HYShareGetPointViewController alloc] init];
            [self.baseViewController setTabbarShow:NO];
            [self.navigationController pushViewController:vc animated:YES];
        };
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"PageHYMineInfoViewController"];
    [[HYShareGetPointView sharedView] dismiss];
}

#pragma mark setter/getter
- (UIBarButtonItem *)settingItem
{
    if (!_settingItem)
    {
        UIImage *back_s = [UIImage imageNamed:@"mine_setting"];
        
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        backButton.frame = CGRectMake(0, 0, 35, 35);
        
        [backButton setAdjustsImageWhenHighlighted:NO];
        [backButton setImage:back_s forState:UIControlStateNormal];
        [backButton addTarget:self
                       action:@selector(setting)
             forControlEvents:UIControlEventTouchUpInside];
        _settingItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    }
    
    return _settingItem;
}

- (NSDictionary *)badgeServiceDic
{
    if (!_badgeServiceDic)
    {
        HYQueryUserBadgeDataService *order = [[HYQueryUserBadgeDataService alloc] init];
        HYQueryUserBadgeDataService *cart = [[HYQueryUserBadgeDataService alloc] init];
        _badgeServiceDic = [[NSDictionary alloc] initWithObjectsAndKeys:order,
                            [NSNumber numberWithInteger:WalletAndOrderbadge],
                            cart,
                            [NSNumber numberWithInteger:ShoppingCartBadge], nil];
    
    }
    
    return _badgeServiceDic;
}

#pragma mark private methods
- (void)goToCart
{
    CHECK_LOGIN
    [MobClick event:kMineShoppingBtn];
    
    HYMallCartViewController *vc = [[HYMallCartViewController alloc]init];
    [self.baseViewController setTabbarShow:NO];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didClickPhone
{
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:@"特奢汇客服竭诚为您服务"
                                                        delegate:self
                                               cancelButtonTitle:NSLocalizedString(@"cancel", nil)
                                          destructiveButtonTitle:@"拨打电话 400-806-6528"
                                               otherButtonTitles:nil];
    action.tag = 1;
    [action showInView:self.view.superview.superview];
}

- (void)didClickQQ
{
    //检查登录
    [[HYChatManager sharedManager] chatLogin];

    ChatViewController *vc = [[ChatViewController alloc] initWithChatter:kCustomerHXId
                                                                    type:ePreSaleType];
    [self.baseViewController setTabbarShow:NO];
    [self.navigationController pushViewController:vc
                                         animated:YES];
}

- (void)dismissGuideImage:(id)sender
{
    [_guide removeFromSuperview];
}

- (void)loginEvent:(id)sender
{
    HYAppDelegate *appDelegate = (HYAppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate loadLoginView];
}

- (void)updatetabbarItem
{
    if (_isLogin)
    {
        [self updateViewWithRedpacketCount:0];
//        [self getRedpacketCount];
    }
}

- (void)updateViewWithRedpacketCount:(NSInteger)count
{
    [[NSUserDefaults standardUserDefaults] setInteger:count
                                               forKey:kRedpacketCount];
    HYAppDelegate *appDelegate = (HYAppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.baseContentView setStatus:[self shouldShowRedTag] atIndex:4];
    [self.tableView reloadData];
}

-(void)updateUserInfo
{
    if (_isLogin)
    {
        if (!_getUserInfoReq)
        {
            [_getUserInfoReq cancel];
            _getUserInfoReq = nil;
        }
        _getUserInfoReq = [[HYGetPersonRequest alloc] init];
        _getUserInfoReq.userId = [HYUserInfo getUserInfo].userId;
        
        [HYLoadHubView show];
        __weak typeof(self) b_self = self;
        [_getUserInfoReq sendReuqest:^(id result, NSError *error)
        {
            [HYLoadHubView dismiss];
            HYUserInfo* info = nil;
            if (result && [result isKindOfClass:[HYGetPersonResponse class]])
            {
                HYGetPersonResponse *response = (HYGetPersonResponse *)result;
                if (response.status == 200)
                {
                    info = response.userInfo;
                }
            }
            [b_self updateViewWithData:info error:error];
        }];
    }
}

- (void)updateViewWithData:(HYUserInfo *)info error:(NSError *)error
{
    if (info)
    {
        [info updateUserInfo];
        self.userInfo = info;
        
        [_tableView reloadData];
    }
    else
    {
        [METoast toastWithMessage:@"获取个人信息失败"];
    }
}

- (void)updateUserAccount
{
    BOOL isLogin = [[NSUserDefaults standardUserDefaults] boolForKey:kIsLogin];
    if (isLogin)
    {
        __weak typeof(self) b_self = self;
        if (_virtualAccountRequest)
        {
            [_virtualAccountRequest cancel];
        }
        
        _virtualAccountRequest = [[HYUserVirtualAccountInfoRequest alloc] init];
        [_virtualAccountRequest sendReuqest:^(id result, NSError *error)
        {
            HYUserVirtualAccountResponse *response = (HYUserVirtualAccountResponse *)result;
            b_self.virtualAccount = response.accountInfo;
            [b_self.tableView reloadData];
        }];
        
        if (_cashAccountRequest)
        {
            [_cashAccountRequest cancel];
        }
        
        _cashAccountRequest = [[HYUserCashAccountInfoRequest alloc] init];
        [_cashAccountRequest sendReuqest:^(id result, NSError *error)
        {
            HYUserCashAccountInfoResponse *response = (HYUserCashAccountInfoResponse *)result;
            b_self.cashAccount = response.cashAccountInfo;
            [b_self.tableView reloadData];
        }];
    }
}

/// 请在此请求接口，并对o2oBalance属性赋值
- (void)updateO2OBalace
{
    WS(weakSelf)
    HYUserInfo *userInfo = [HYUserInfo getUserInfo];
    _userO2OBalanceRequest               = [[UserBalanceRequest alloc] init];
    _userO2OBalanceRequest.interfaceURL  = [NSString stringWithFormat:@"%@/v4/Member/GetMemberTotalBalance",BASEURL];
    _userO2OBalanceRequest.interfaceType = DotNET2;
    _userO2OBalanceRequest.postType      = JSON;
    _userO2OBalanceRequest.httpMethod    = @"POST";
    _userO2OBalanceRequest.userId        = userInfo.userId;
    _userO2OBalanceRequest.cardNo        = userInfo.number ? : @"";
    [_userO2OBalanceRequest sendReuqest:^(id result, NSError *error) {
        
        if (result) {
            NSDictionary *objDic = [result jsonDic];
            int code = [objDic[@"code"] intValue];
            if (code == 0) {//状态值为0 代表请求成功
                NSDictionary *dic = objDic[@"data"];
                if (dic.allKeys.count != 0) {
                    NSString *balanceStr = dic[@"totalBalance"];
                    weakSelf.o2oBalance = balanceStr.doubleValue;
                    [weakSelf.tableView reloadData];
                }
            }
        }
    }];
}

//设置界面
- (void)setting
{
    
//
    CHECK_LOGIN
    [MobClick event:kMineSettingBtn];
    HYSettingsViewController *setting = [[HYSettingsViewController alloc] init];
    [self.baseViewController setTabbarShow:NO];
    [self.navigationController pushViewController:setting animated:YES];
}

#pragma mark pulice methods
- (void)getRedpacketCount
{
    if (_isLogin)
    {
        if (_getRedpacketReq)
        {
            [_getRedpacketReq cancel];
            _getRedpacketReq = nil;
        }
        
        __weak typeof(self) bself = self;
        _getRedpacketReq = [[HYGetRedpacketCountReq alloc] init];
        [_getRedpacketReq sendReuqest:^(id result, NSError *error) {
            if (!error)
            {
                HYGetRedpacketCountResp *resp = (HYGetRedpacketCountResp *)result;
                NSInteger count = resp.count;
                [bself updateViewWithRedpacketCount:count];
            }
        }];
    }
}

//更新用户登录状态
- (void)updateWithLoginChange:(NSNotification*)notiy
{
    _isLogin = [[NSUserDefaults standardUserDefaults] boolForKey:kIsLogin];
    if (_isLogin)
    {
        self.userInfo = [HYUserInfo getUserInfo];
    }
    
    [_tableView reloadData];
}

- (void)getViewMarkDataWithType:(HYQueryBadgeDataType)type
{
    HYQueryUserBadgeDataService *service = [self.badgeServiceDic objectForKey:[NSNumber numberWithInteger:type]];
    if (service)
    {
        [service cancel];
    }
    
    WS(weakSelf);
    
    [service queryUserInfoViewBadgeWithType:type
                                   callback:^(NSArray *countInfo, NSError *err) {
                                       if (countInfo && !err)
                                       {
                                           if (OrderBadge == type)
                                           {
                                               weakSelf.unSendOrderCount = [HYQueryUserBadgeDataService getBadgeWithInfo:countInfo
                                                                                                                    type:UnSendOrderBadge];
                                               weakSelf.unRecvOrderCount = [HYQueryUserBadgeDataService getBadgeWithInfo:countInfo
                                                                                                                    type:UnRecvOrderBadge];
                                               weakSelf.unPayOrderCount = [HYQueryUserBadgeDataService getBadgeWithInfo:countInfo
                                                                                                                   type:UnPayOrderBadge];
                                           }
                                           else if (ShoppingCartBadge == type)
                                           {
                                               weakSelf.shoppingCartCount = [HYQueryUserBadgeDataService getBadgeWithInfo:countInfo
                                                                                                                     type:ShoppingCartBadge];
                                               [_cartBtn setLabelCount:weakSelf.shoppingCartCount];
                                           }
                                           else
                                           {
                                               weakSelf.sendRPCount = [HYQueryUserBadgeDataService getBadgeWithInfo:countInfo
                                                                                                               type:SendRedPagket];
                                               weakSelf.recvRPCount = [HYQueryUserBadgeDataService getBadgeWithInfo:countInfo
                                                                                                               type:RecvRedPagket];
                                               weakSelf.unPayOrderCount = [HYQueryUserBadgeDataService getBadgeWithInfo:countInfo type:UnPayOrderBadge];
                                               weakSelf.unRecvOrderCount = [HYQueryUserBadgeDataService getBadgeWithInfo:countInfo type:UnRecvOrderBadge];
                                               weakSelf.unSendOrderCount = [HYQueryUserBadgeDataService getBadgeWithInfo:countInfo type:UnSendOrderBadge];
                                           }
                                           
                                           [weakSelf.tableView reloadData];
                                       }
                                       else
                                       {
                                           DebugNSLog(@"queryUserInfoViewBadgeWithType err %@", err);
                                       }
                                   }];
}

/**
 *  Table结构
 *  头像
 *  订单
 *  钱包
 *  愿望、收藏
 *  服务反馈
 */

#pragma mark - Table view data source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 1;
    }
    else if (section == 1)  //订单
    {
        return 2;
    }
    else if (section == 2)  //钱包
    {
        return 2;
    }
    else if (section == 3)  //愿望
    {
        return 2;
    }
    else if (section == 4)
    {
        return 1;
    }
    else
    {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return 145;
    }
    else if (indexPath.section == 1)
    {
        return indexPath.row == 0 ? 50 : 60;
    }
    else if (indexPath.section == 2)
    {
        return indexPath.row == 0 ? 50 : 50;
    }
    else
    {
        return 50;
    }
}

/*
- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger totalRow = [tableView numberOfRowsInSection:indexPath.section];//first get total rows in that section by current indexPath.
    if ([cell isKindOfClass:[HYBaseLineCell class]])
    {
        if(indexPath.row == totalRow -1)
        {
            //this is the last row in section.
            HYBaseLineCell *lineCell = (HYBaseLineCell *)cell;
            lineCell.separatorLeftInset = 0.0f;
        }
        else
        {
            HYBaseLineCell *lineCell = (HYBaseLineCell *)cell;
            lineCell.separatorLeftInset = 20;
        }
    }
}
 */

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIImageView *v = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 10)];
    v.image = [[UIImage imageNamed:@"ticket_bg_gray_g5"] stretchableImageWithLeftCapWidth:2
                                                                             topCapHeight:4];
    
    return v;
}

//footer高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat height = 0;
    if (section != 0)
    {
        height = 10;
    }
    return height;
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
    if (indexPath.section == 0) //头像
    {
        static NSString *userCellIdentifier = @"headCell";
        HYMineInfoHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:userCellIdentifier];
        cell.isLogin = _isLogin;
        cell.userinfo = [HYUserInfo getUserInfo];
        cell.delegate = self;
        return cell;
    }
    else if (indexPath.section == 1)    //订单
    {
        if (indexPath.row == 0)
        {
            static NSString *mineCellIdentifier = @"mineCellIdentifier";
            HYMineInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:mineCellIdentifier];
            if (cell == nil)
            {
                cell = [[HYMineInfoCell alloc]initWithStyle:UITableViewCellStyleValue1
                                            reuseIdentifier:mineCellIdentifier];
            }
            [cell.textLabel setText:@"我的订单"];
            cell.imageView.image = [UIImage imageNamed:@"mine_icon_order"];
            cell.detailTextLabel.text = @"查看全部订单";
            return cell;
        }
        else
        {
            HYMineInfoOrderCell *orderCell = [tableView dequeueReusableCellWithIdentifier:@"orderCell"];
            WS(weakSelf);
            orderCell.orderCellCallback = ^(HYMineInfoOrderActionType actionType)
            {
                [weakSelf checkMallOrderWithType:actionType];
            };
            [orderCell setCount:self.unPayOrderCount
                        forType:HYMineInfoOrderActionPay];
            [orderCell setCount:self.unSendOrderCount
                        forType:HYMineInfoOrderActionSend];
            [orderCell setCount:self.unRecvOrderCount
                        forType:HYMineInfoOrderActionRecieve];
            
            return orderCell;
        }
    }
    else if (indexPath.section == 2)    //钱包
    {
        if (indexPath.row == 0)
        {
            static NSString *mineCellIdentifier = @"mineCellIdentifier";
            HYMineInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:mineCellIdentifier];
            if (cell == nil)
            {
                cell = [[HYMineInfoCell alloc]initWithStyle:UITableViewCellStyleValue1
                                            reuseIdentifier:mineCellIdentifier];
            }
            [cell.textLabel setText:@"我的钱包"];
            cell.imageView.image = [UIImage imageNamed:@"mine_icon_wallet"];
            cell.detailTextLabel.text = @"查看我的钱包";
            
            return cell;
        }
        else
        {
            HYMineInfoWalletCell *walletCell = [tableView dequeueReusableCellWithIdentifier:@"walletCell"];
            walletCell.points = self.virtualAccount.balance.integerValue;
            walletCell.balance = self.cashAccount.balance.doubleValue;
            walletCell.o2obalance = self.o2oBalance;
            
            //分别表示收到的红包/发出的红包；
            [walletCell setSendPackets:self.sendRPCount
                                  recv:self.recvRPCount];
            WS(weakSelf);
            walletCell.didCheckSubType = ^(NSInteger type) {
                [weakSelf checkWalletSubType:type];
            };
            return walletCell;
        }
    }
    else if (indexPath.section == 3)
    {
        static NSString *mineCellIdentifier = @"mineCellIdentifier";
        HYMineInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:mineCellIdentifier];
        if (cell == nil)
        {
            cell = [[HYMineInfoCell alloc]initWithStyle:UITableViewCellStyleValue1
                                        reuseIdentifier:mineCellIdentifier];
        }
        if (indexPath.row == 0)
        {
            [cell.textLabel setText:@"帮我买"];
            cell.detailTextLabel.text = nil;
            cell.imageView.image = [UIImage imageNamed:@"mine_icon_desire"];
        }
        else if (indexPath.row == 1)
        {
            [cell.textLabel setText:@"我的收藏"];
            cell.detailTextLabel.text = nil;
            cell.imageView.image = [UIImage imageNamed:@"mine_icon_favourite"];
        }
//        else
//        {
//            [cell.textLabel setText:@"摇一摇"];
//            cell.detailTextLabel.text = nil;
//            cell.imageView.image = [UIImage imageNamed:@"icon_entry_shake"];
//        }
        return cell;
        
        }
    else
    {
        static NSString *mineCellIdentifier = @"mineCellIdentifier";
        HYMineInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:mineCellIdentifier];
        if (cell == nil)
        {
            cell = [[HYMineInfoCell alloc]initWithStyle:UITableViewCellStyleValue1
                                        reuseIdentifier:mineCellIdentifier];
        }
        [cell.textLabel setText:@"服务与反馈"];
        cell.detailTextLabel.text = nil;
        cell.imageView.image = [UIImage imageNamed:@"mine_icon_service"];
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1)
    {
        CHECK_LOGIN
        if (indexPath.row == 0)
        {
            [MobClick event:kMineOrderChoosingBrand];
            [self checkAllOrders];
        }
    }
    else if (indexPath.section == 2)
    {
        CHECK_LOGIN
        [MobClick event:kMineWalletChoosingBrand];
        [self checkWallet];
    }
    else if (indexPath.section == 3)
    {
        CHECK_LOGIN
        if (indexPath.row == 0)
        {
            [MobClick event:kMineDesireChoosingBrand];
            [self checkDesire];
        }
        else if (indexPath.row == 1)
        {
            [MobClick event:kMineFavoriteChoosingBrand];
            [self checkFavourite];
        }
        else
        {
            [self checkShake];
        }
    }
    else if (indexPath.section == 4)
    {
        [MobClick event:kMineServiceAndFeedBackChoosingBrand];
        [self checkService];
    }
}

/// 进入钱包界面
- (void)checkWallet
{
    HYWalletViewController *wallet = [[HYWalletViewController alloc] init];
    wallet.balance = self.cashAccount.balance.doubleValue;
    wallet.points = self.virtualAccount.balance.integerValue;
    wallet.packetNew = self.recvRPCount;
    wallet.packetTotal = self.sendRPCount;
    wallet.o2obalance = self.o2oBalance;
    [self.navigationController pushViewController:wallet animated:YES];
    [self.baseViewController setTabbarShow:NO];
}

/// 直接进入钱包子界面
- (void)checkWalletSubType:(NSInteger)type
{
    CHECK_LOGIN
    switch (type)
    {
        case 0:
        {
            //现金券
            [MobClick event:kMineCashTicket];
            
            HYPointsViewController *vc = [[HYPointsViewController alloc] init];
            vc.points = self.virtualAccount.balance.integerValue;
            [self.navigationController pushViewController:vc animated:YES];
            [self.baseViewController setTabbarShow:NO];
            break;
        }
        case 1:
        {
            //账户余额
            [MobClick event:kMineAccountBalance];
            
            HYAccountBalanceViewController *vc = [[HYAccountBalanceViewController alloc] init];
//            vc.balance = self.cashAccount.balance.doubleValue;
            [self.navigationController pushViewController:vc animated:YES];
            [self.baseViewController setTabbarShow:NO];
            break;
        }
        case 2:
        {
            /// 实体店余额入口
            StoreBalanceViewController *vc = [[StoreBalanceViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            [self.baseViewController setTabbarShow:NO];
            
            break;
        }
        case 3:
        {
            //红包
            [MobClick event:kMineRedPacket];
            
            HYRedpacketsHomeViewController *vc = [[HYRedpacketsHomeViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            [self.baseViewController setTabbarShow:NO];
            break;
        }
        default:
            break;
    }
}

/// 进入帮我买
- (void)checkDesire
{
//    HYPhoneChargeViewController *vc = [[HYPhoneChargeViewController alloc]init];
    HYMyDesirePoolViewController *vc = [[HYMyDesirePoolViewController alloc]init];
    [self.baseViewController setTabbarShow:NO];
    [self.navigationController pushViewController:vc
                                         animated:YES];
}

/// 我的收藏
- (void)checkFavourite
{
    HYMallFavoritesViewController *vc = [[HYMallFavoritesViewController alloc] init];
    [self.baseViewController setTabbarShow:NO];
    [self.navigationController pushViewController:vc
                                         animated:YES];
}

// 摇一摇
- (void)checkShake
{
    HYShakeViewController *vc = [[HYShakeViewController alloc] init];
    [self.baseViewController setTabbarShow:NO];
    [self.navigationController pushViewController:vc animated:YES];
}

/// 查看全部订单，显示订单类型
- (void)checkAllOrders
{
    HYOrderSelectView *view = [HYOrderSelectView getView];
    [view showWithAnimation:YES];
    view.didGetOrderController = ^(UIViewController *child)
    {
        if (child)
        {
            HYMineAllOrderViewController *ordervc = [[HYMineAllOrderViewController alloc] init];
            [self.navigationController pushViewController:ordervc animated:YES];
            [self.baseViewController setTabbarShow:NO];
            [ordervc showOrderViewController:child];
        }
    };
}

- (UIViewController *)checkOrderListWithBusiness:(BusinessType)type
{
    HYTabbarViewController *tab = (HYTabbarViewController*)[UIApplication sharedApplication].keyWindow.rootViewController;
    if ([tab isKindOfClass:[HYTabbarViewController class]])
    {
        [tab setCurrentSelectIndex:3];
    }
    if (self.navigationController.viewControllers.count > 1)
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    HYMineAllOrderViewController *ordervc = [[HYMineAllOrderViewController alloc] init];
    [self.navigationController pushViewController:ordervc animated:YES];
    [self.baseViewController setTabbarShow:NO];
    
    return [ordervc showOrderViewWithType:type];
}

/// 服务反馈
- (void)checkService
{
//#warning 上线时删除
//    Class class = NSClassFromString(@"HYActivateV2ValidateViewController");
//    id vc = [[class alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
//    [self.baseViewController setTabbarShow:NO];
//    return;
    
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:nil
                                                      delegate:self
                                             cancelButtonTitle:@"取消"
                                        destructiveButtonTitle:@"小秘书"
                                             otherButtonTitles:@"客服电话", nil];;

    sheet.tag = 0;
    [sheet showInView:self.view];
}

/// 显示商城订单
- (void)checkMallOrderWithType:(HYMineInfoOrderActionType)actionType
{
    CHECK_LOGIN
    if (actionType == HYMineInfoOrderActionAfter)
    {
        [MobClick event:kMineOrderAfterSaleService];
        
        HYAfterSaleViewController *after = [[HYAfterSaleViewController alloc] init];
        [self.baseViewController setTabbarShow:NO];
        [self.navigationController pushViewController:after animated:YES];
    }
    else
    {
        HYMallOrderListViewController *mallOrderList = [[HYMallOrderListViewController alloc] init];
        mallOrderList.showOrderType = actionType + 1;
        HYMineAllOrderViewController *orderContainer = [[HYMineAllOrderViewController alloc] init];
        [self.navigationController pushViewController:orderContainer animated:YES];
        [self.baseViewController setTabbarShow:NO];
        [orderContainer showOrderViewController:mallOrderList];
    }
}

//决定是否显示红点  如没有显示过，则显示，否则根据是否有红包决定
- (BOOL)shouldShowRedTag
{
    BOOL _isShow = [[NSUserDefaults standardUserDefaults] boolForKey:kIsShowRedpacket];
    if (!_isShow) {
        return YES;
    }
    else
    {
        return self.hasNewRedPacket;
    }
}


#pragma mark - head delegate
//菜单回调，点击我的名片、续保、升级等按钮时调用
- (void)headCellDidClickWithMenuType:(HYMineInfoMenuType)menuType
{
    switch (menuType)
    {
        case MyCard:
        {
            //进入我的名片
            HYMineCardViewController *vc = [[HYMineCardViewController alloc] init];
            [self.baseViewController setTabbarShow:NO];
            [self.navigationController pushViewController:vc
                                                 animated:YES];
        }
            break;
        case Xubao:
        {
            //进入续保
            HYInsuranceViewController *vc = [[HYInsuranceViewController alloc]init];
            [self.baseViewController setTabbarShow:NO];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case Member:
        {
            //进入我的员工
            HYEmployeesListViewController *vc = [[HYEmployeesListViewController alloc] init];
            [self.baseViewController setTabbarShow:NO];
            [self.navigationController pushViewController:vc
                                                   animated:YES];
        }
            break;
        case Upgrade:
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
                             payVC.productDesc = [NSString stringWithFormat:@"【特奢汇】在线激活: %@", response.orderNumber]; //商品描述
                             
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
            
        }
            break;
        case Fuli:
        {
            //福利
            HYBenefitViewController *vc = [[HYBenefitViewController alloc] init];
            [self.baseViewController setTabbarShow:NO];
            [self.navigationController pushViewController:vc
                                                 animated:YES];
            break;
        }
        default:
            break;
    }
}
- (void)headCellDidClickLogin
{
    [self loginEvent:nil];
}

- (void)headCellDidClickPhoto
{
    [self headCellDidClickUserName];
}

- (void)headCellDidClickUserName
{
    CHECK_LOGIN
    //用户中心
//    HYPersonViewController *vc = [[HYPersonViewController alloc] init];
    HYMyInformationViewController *vc = [[HYMyInformationViewController alloc]initWithNibName:@"HYMyInformationViewController" bundle:nil];
    [self.baseViewController setTabbarShow:NO];
    vc.userInfo = [HYUserInfo getUserInfo];
//    vc.delegate = self;
    [self.navigationController pushViewController:vc
                                           animated:YES];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 0)
    {
        switch (buttonIndex) {
            case 0:
            {
                [MobClick event:kMineServiceQQService];
                [self didClickQQ];
            }
                break;
            case 1:
            {
                [MobClick event:kMineServiceTelService];
                [self didClickPhone];
            }
                break;
            default:
                break;
        }
    }
    else
    {
        if (buttonIndex != actionSheet.cancelButtonIndex)
        {
            NSString *phone = [NSString stringWithFormat:@"telprompt://4008066528"];
            NSURL *url = [NSURL URLWithString:phone];
            [[UIApplication sharedApplication] openURL:url];
        }
    }
    
}

- (HYUserService *)userService
{
    if (!_userService) {
        _userService = [[HYUserService alloc] init];
    }
    return _userService;
}

#pragma mark - HYVipUpdateViewControllerDelegate
- (void)didSelectUpgrad
{
    HYUpdateToOfficialUserViewController *vc = [HYUpdateToOfficialUserViewController new];
//    HYMemberUpgradeViewController *vc = [[HYMemberUpgradeViewController alloc] init];
    [self.navigationController pushViewController:vc
                                         animated:YES];
}

+ (HYMineInfoViewController *)sharedMineInfoViewController
{
    HYTabbarViewController *tab = [HYTabbarViewController sharedTabbarController];
    if (tab.viewControllers.count > 3) {
        UINavigationController *nav = [[tab viewControllers] objectAtIndex:3];
        return [[nav viewControllers] objectAtIndex:0];
    }
    return nil;
}


@end
