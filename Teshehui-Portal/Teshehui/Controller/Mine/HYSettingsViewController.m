//
//  HYAccoutSecurityViewController.m
//  Teshehui
//
//  Created by Kris on 15/5/6.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYAccoutSecurityViewController.h"
#import "HYTabbarViewController.h"
#import "HYBaseLineCell.h"
#import "HYAppDelegate.h"
#import "HYMallOrderListViewController.h"
#import "HYMineInfoViewController.h"
#import "HYMineCardViewController.h"
#import "HYModiyPsdViewController.h"
#import "HYSignoutRequest.h"
#import "HYSignoutResponse.h"
#import "METoast.h"
#import "HYBusinessCardInfo.h"
#import "PTHttpManager.h"
#import "HYAppDelegate.h"
#import "HYGetPersonRequest.h"
#import "HYGetPersonResponse.h"
#import "UIImage+Addition.h"
#import "HYMineInfoCell.h"
#import "HYPassengerListViewController.h"
#import "HYDeliveryAddressViewController.h"
#import "HYEmployeesListViewController.h"
#import "HYMyInformationViewController.h"
#import "HYRealnameConfirmViewController.h"
#import "HYGetUserInfoRequest.h"
#import "HYMyAccountViewController.h"
#import "HYNewAccountSecurityViewController.h"
#import <TencentOpenAPI/TencentApiInterface.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import "UMSocial.h"
#import "HYAboutViewController.h"
#import "HYHelpViewController.h"
#import "HYSettingsViewController.h"
#import "SDWebImageManager.h"

@interface HYSettingsViewController ()
<GetUserInfoDelegate,
UMSocialUIDelegate,
UIActionSheetDelegate>
{
    HYSignoutRequest* _signoutRequest;
    HYGetPersonRequest* _getUserInfoReq;
    //    HYGetRedpacketCountReq *_getRedpacketReq;
    BOOL _isLogin;
    BOOL _isLoading;
}
@property(nonatomic, strong)UITableView *tableview;
@property (nonatomic, weak) HYTabbarViewController *baseViewController;
@property(nonatomic, strong)HYUserInfo *userInfo;
@property (nonatomic, assign) BOOL isShare;

@end

UIKIT_EXTERN NSString * const LoginStatusChangeNotification;

@implementation HYSettingsViewController

- (void)dealloc
{
    [_signoutRequest cancel];
    _signoutRequest = nil;
    
    [HYLoadHubView dismiss];
    
    [_getUserInfoReq cancel];
    _getUserInfoReq = nil;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"设置";
        //        [self.baseViewController setTabbarShow:YES];
    }
    return self;
}

- (void)loadView
{
    CGRect frame = [[UIScreen mainScreen] bounds];
    frame.size.height -= 64;
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor colorWithWhite:.91f alpha:1.0f];
    self.view = view;
    
    //tableview
    UITableView *tableview = [[UITableView alloc] initWithFrame:frame
                                                          style:UITableViewStyleGrouped];
    tableview.delegate = self;
    tableview.dataSource = self;
    tableview.backgroundColor = [UIColor clearColor];
    tableview.backgroundView = nil;
//    tableview.contentInset = UIEdgeInsetsZero;
    tableview.rowHeight = 60;
    
    /*
    UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 1.0)];
    lineView.image = [[UIImage imageNamed:@"line_cell_bottom"] stretchableImageWithLeftCapWidth:2 topCapHeight:0];
    tableview.tableHeaderView = lineView;
     */
    [self.view addSubview:tableview];
    self.tableview = tableview;
    
    UIView *container = [UIView new];
    container.frame = TFRectMake(0, 0, 320, 60);
    UIButton *logoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    logoutBtn.frame = CGRectMake(TFScalePoint(20), 8, TFScalePoint(280), 44);
    UIImage *loginimage = [UIImage imageNamed:@"mine_login"];
    loginimage = [loginimage utilResizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    [logoutBtn setBackgroundImage:loginimage
                         forState:UIControlStateNormal];
    
    [logoutBtn setTitle:@"退出账号" forState:UIControlStateNormal];
    [logoutBtn addTarget:self
                  action:@selector(Signout:)
        forControlEvents:UIControlEventTouchUpInside];
    [logoutBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [logoutBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
    [container addSubview:logoutBtn];
    self.tableview.tableFooterView = container;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    _isLogin = [[NSUserDefaults standardUserDefaults] boolForKey:kIsLogin];
    
    [self updateUserInfo];
}

/**
 *  @brief 滑动返回时，去除分享界面。by:成才
 */
- (BOOL)canDragBack
{
    if (_isShare) {
        return NO;
    }
    return YES;
}


#pragma mark - Table view data source
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0 == section ? 9 : 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    /*
     HYUserInfo *userinfo = [HYUserInfo getUserInfo];
     if (0 == section)
     {
     if (userinfo.userType == Normal_User || userinfo.userType == Enterprise_User)
     {
     //            HYUserInfo *userinfo = [HYUserInfo getUserInfo];
     NSString *idAuth = _userInfo.idAuthentication;
     if ([idAuth isEqualToString:@"1"])
     {
     return 5;
     }else
     {
     return 6;
     }
     
     }
     else
     {
     return 5;
     }
     }else
     {
     return 1;
     }
     */
    return section == 3 ? 3 : (section == 2)? 1 : 2;
}

//- (void)tableView:(UITableView *)tableView
//  willDisplayCell:(UITableViewCell *)cell
//forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSInteger totalRow = [tableView numberOfRowsInSection:indexPath.section];//first get total rows in that section by current indexPath.
//    if(indexPath.row == totalRow -1){
//        //this is the last row in section.
//        HYBaseLineCell *lineCell = (HYBaseLineCell *)cell;
//        lineCell.separatorLeftInset = 45.0;
//    }
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    HYMineInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[HYMineInfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell setHasNew:NO];
    }
    cell.hiddenLine = YES;
    //
    //    HYUserInfo *userinfo = [HYUserInfo getUserInfo];
    //    NSInteger index = indexPath.row;
    //    if (userinfo.userType!=Normal_User &&
    //        userinfo.userType!=Enterprise_User &&
    //        indexPath.row >= 1)
    //    {
    //        index = indexPath.row + 1;
    //    }
    
    if (0 == indexPath.section)
    {
        if (indexPath.row == 0)
        {
            [cell.textLabel setText:@"我的账户"];
            cell.imageView.image = [UIImage imageNamed:@"setting_myAccount"];
            return cell;
        }
        else
        {
            [cell.textLabel setText:@"账户安全"];
            cell.imageView.image = [UIImage imageNamed:@"setting_accountSecurity"];
            return cell;
        }
        
    }
    else if (1 == indexPath.section)
    {
        if (indexPath.row == 0)
        {
            [cell.textLabel setText:@"管理地址"];
            cell.imageView.image = [UIImage imageNamed:@"setting_manageAddr"];
            return cell;
        }
        else
        {
            [cell.textLabel setText:@"管理旅客"];
            cell.imageView.image = [UIImage imageNamed:@"setting_manageTourist"];
            return cell;
        }
    }
    else if (2 == indexPath.section)
    {
        [cell.textLabel setText:@"清除缓存"];
        cell.imageView.image = [UIImage imageNamed:@"setting_clearCache"];
        return cell;
    }
    else
    {
        if (indexPath.row == 0)
        {
            [cell.textLabel setText:@"关于我们"];
            cell.imageView.image = [UIImage imageNamed:@"setting_aboutUs"];
            return cell;
        }
        else if (indexPath.row == 1)
        {
            [cell.textLabel setText:@"帮助"];
            cell.imageView.image = [UIImage imageNamed:@"newSetting_help"];
            return cell;
        }
        else
        {
            [cell.textLabel setText:@"分享"];
            cell.imageView.image = [UIImage imageNamed:@"setting_sharement"];
            return cell;
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    if (!_isLogin)
//    {
//        HYAppDelegate *appDelegate = (HYAppDelegate *)[[UIApplication sharedApplication] delegate];
//        [appDelegate loadLoginView];
//    }
//    else
//    {
        if (0 == indexPath.section)
        {
            if (indexPath.row == 0)
            {
                [MobClick event:kSettingMineAccountClick];
                HYMyAccountViewController *vc = [[HYMyAccountViewController alloc]init];
                [self.baseViewController setTabbarShow:NO];
                vc.idAuth = _userInfo.idAuthentication;
                [self.navigationController pushViewController:vc
                                                     animated:YES];
            }
            else
            {
                [MobClick event:kSettingMineAccountSecurityClick];
                
                HYNewAccountSecurityViewController *vc = [[HYNewAccountSecurityViewController alloc]init];
                [self.baseViewController setTabbarShow:NO];
                //                vc.userInfo = [HYUserInfo getUserInfo];
                [self.navigationController pushViewController:vc
                                                     animated:YES];
                
            }
            
        }
        else if (1 == indexPath.section)
        {
            if (indexPath.row == 0)
            {
                [MobClick event:kSettingMasterAddrClick];
                
                HYDeliveryAddressViewController *vc = [[HYDeliveryAddressViewController alloc] init];
                vc.navbarTheme = self.navbarTheme;
                vc.type = 2;
                vc.title = @"管理地址";
                [self.navigationController pushViewController:vc
                                                     animated:YES];
            }
            else
            {
                [MobClick event:kSettingMasterTouristClick];
                
                HYPassengerListViewController *vc = [[HYPassengerListViewController alloc] init];
                vc.navbarTheme = self.navbarTheme;
                vc.type = Unknow;
                vc.title = @"管理旅客";
                [self.navigationController pushViewController:vc
                                                     animated:YES];
            }
        }
        else if (2 == indexPath.section)
        {
            [MobClick event:kSettingClearCacheClick];
            
            UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"确定要清除缓存?" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil];
            [sheet showInView:self.view];
        }
        else if (3 == indexPath.section)
        {
            NSInteger index = indexPath.row;
           
            switch (index)
            {
                    /*
                case 0:
                {
                    QQApiWPAObject *wpaObj = [QQApiWPAObject objectWithUin:kFeedbackQQ];
                    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:wpaObj];
                    [QQApiInterface sendReq:req];
                    break;
                }
                     */
                case 0:
                {
                    [MobClick event:kSettingAbountUsClick];
                    
                    HYAboutViewController* vc = [[HYAboutViewController alloc]init];
                    vc.title = @"关于我们";
                    [self.navigationController pushViewController:vc animated:YES];
                    break;
                }
                case 1:
                {
                    [MobClick event:kSettingHelpClick];
                    
                    HYHelpViewController *vc = [[HYHelpViewController alloc] init];
                    vc.title = @"帮助";
                    HYNavigationController *nav = [[HYNavigationController alloc] initWithRootViewController:vc];
                    [self presentViewController:nav animated:YES completion:nil];
                }
                    break;
                    
                case 2:
                {
                    [MobClick event:kSettingSharementClick];
                    
                    if (!_isShare)
                    {
                        _isShare = YES;
                        [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;  //使用app类型的时候分享到会话无法跳转
                        [UMSocialData defaultData].extConfig.title = @"我发现了一款超赞的应用《特奢汇》";
                        [UMSocialData defaultData].extConfig.wechatSessionData.url = @"http://a.app.qq.com/o/simple.jsp?pkgname=com.hy.teshehui&g_f=991653";
                        [UMSocialData defaultData].extConfig.wechatTimelineData.url = @"http://a.app.qq.com/o/simple.jsp?pkgname=com.hy.teshehui&g_f=991653";
                        
                        [UMSocialData defaultData].extConfig.qqData.qqMessageType = UMSocialQQMessageTypeDefault;
                        [UMSocialData defaultData].extConfig.qqData.url = @"http://a.app.qq.com/o/simple.jsp?pkgname=com.hy.teshehui&g_f=991653";
                        [UMSocialData defaultData].extConfig.qzoneData.title = @"我发现了一款超赞的应用《特奢汇》";
                        [UMSocialData defaultData].extConfig.qzoneData.url = @"http://a.app.qq.com/o/simple.jsp?pkgname=com.hy.teshehui&g_f=991653";
                        [UMSocialData defaultData].extConfig.qqData.title = @"我发现了一款超赞的应用《特奢汇》";
                        //                [UMSocialData defaultData].extConfig.qqData.qqMessageType = UMSocialQQMessageTypeImage;
                        
                        [UMSocialSnsService presentSnsIconSheetView:self
                                                             appKey:uMengAppKey
                                                          shareText:kUMengShareContent
                                                         shareImage:[UIImage imageNamed:@"share_icon"]
                                                    shareToSnsNames:[NSArray arrayWithObjects:UMShareToQQ,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina,nil]
                                                           delegate:self];
                    }
                    
                }
                    break;
                default:
                    break;
            }
            
        }
    }
//}

#pragma mark UMeng
-(void)didCloseUIViewController:(UMSViewControllerType)fromViewControllerType
{
    _isShare = NO;
}

/**
 各个页面执行授权完成、分享完成、或者评论完成时的回调函数
 
 @param response 返回`UMSocialResponseEntity`对象，`UMSocialResponseEntity`里面的viewControllerType属性可以获得页面类型
 */
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    _isShare = NO;
}

-(void)didSelectSocialPlatform:(NSString *)platformName withSocialData:(UMSocialData *)socialData;
{
    if (UMShareToQQ == platformName)
    {
        [MobClick event:kSettingSharementQQClick];
    }
    else if (UMShareToWechatSession == platformName)
    {
        [MobClick event:kSettingSharementWeChatFriendClick];
    }
    else if (UMShareToWechatTimeline == platformName)
    {
        [MobClick event:kSettingSharementWeChatFriendCircleClick];
    }
    else if (UMShareToSina == platformName)
    {
        [MobClick event:kSettingSharementWeiboClick];
    }
}

#pragma mark private methods
-(void)Signout:(UIButton*)sender
{
    [MobClick event:kSettingLogoutClick];
    
    if (!_signoutRequest)
    {
        _signoutRequest = [[HYSignoutRequest alloc] init];
    }
    __weak typeof(self) b_self = self;
    [HYLoadHubView show];
    [_signoutRequest sendReuqest:^(id result, NSError *error)
     {
         [HYLoadHubView dismiss];
         if (!error && [result isKindOfClass:[HYSignoutResponse class]])
         {
             
         }
         
         HYAppDelegate *appDelegate = (HYAppDelegate *)[[UIApplication sharedApplication] delegate];
         [appDelegate logoutFinished];
         [b_self.navigationController popToRootViewControllerAnimated:YES];
     }];
}

-(void)updateUserInfo
{
    if (_isLogin)
    {
        if (!_getUserInfoReq)
        {
            _getUserInfoReq = [[HYGetPersonRequest alloc] init];
            
        }
        [_getUserInfoReq cancel];
        
        _getUserInfoReq.userId = [HYUserInfo getUserInfo].userId;
        
        [HYLoadHubView show];
        __weak typeof(self) b_self = self;
        [_getUserInfoReq sendReuqest:^(id result, NSError *error)
         {
             [HYLoadHubView dismiss];
             if (result && [result isKindOfClass:[HYGetPersonResponse class]])
             {
                 HYGetPersonResponse *response = (HYGetPersonResponse *)result;
                 if (response.status == 200)
                 {
                     b_self.userInfo = response.userInfo;
                     [b_self.tableview reloadData];
                 }else
                 {
                     [METoast toastWithMessage:response.suggestMsg];
                 }
             }
         }];
    }
}

- (void)clearCache
{
    [HYBusinessCardInfo cleanCache];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:LoginStatusChangeNotification
                                                        object:nil];
    
    //重新获取地理位置
    //            [self updateLocationinfo];
    
    //取消所有请求
    [[PTHttpManager getInstantane] cancelAll];
    
    //清除http缓存
    [[PTHttpManager getInstantane] cleanCache];
    
    //清除图片缓存
    [[SDImageCache sharedImageCache] clearMemory];
    [[SDImageCache sharedImageCache] clearDisk];
}

#pragma mark actionSheet
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        [self clearCache];
        [METoast toastWithMessage:@"清除成功"];
    }
}

@end
