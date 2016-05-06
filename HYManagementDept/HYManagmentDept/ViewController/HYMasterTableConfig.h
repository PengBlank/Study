//
//  HYMasterTableViewDataSource.h
//  HYManagmentDept
//
//  Created by Ray on 14-12-9.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HYSummaryDetailViewController.h"
#import "HYAccountViewController.h"  //帐户
#import "HYOrderListViewController.h" //订单列表
#import "HYAgencyCenterViewController.h"//代理运营中心
#import "HYCardListViewController.h"    //会员卡列表
#import "HYAddCardViewController.h"     //批发会员卡
#import "HYVIPListViewController.h"     //会员列表
#import "HYCompanyIncomeViewController.h"//公司心益
#import "HYAgencyIncomeViewController.h"//中心收益
#import "HYEnterpriseMemberListViewController.h"
#import "HYEnterpriseApplyViewController.h"//申请
#import "HYEnterpriseCardPublishViewController.h"//批发
#import "HYPremoterListViewController.h"
#import "HYPromoterAddViewController.h" //添加操作员
#import "HYPromoterIncomeViewController.h" //操作员收益
#import "HYPromoterCardMoveViewController.h" //操作员会员卡转移
#import "HYQuickActiveViewController.h" //快速激活
#import "HYQuickActive2ViewController.h"
#import "HYHelpViewController.h"
#import "HYOutOrderListViewController.h"

#import "HYUserInfo.h"

@interface HYMasterTableConfig : NSObject

@property (nonatomic, strong) UINavigationController *summaryNav;
@property (nonatomic, strong) UINavigationController *accountNav;
@property (nonatomic, strong) UINavigationController *orderListNav;
@property (nonatomic, strong) UINavigationController *agencyCenterNav;
@property (nonatomic, strong) UINavigationController *cardListNav;
@property (nonatomic, strong) UINavigationController *addCardNav;
@property (nonatomic, strong) UINavigationController *vipListNav;
@property (nonatomic, strong) UINavigationController *companyIncomeNav;
@property (nonatomic, strong) UINavigationController *agencyIncomeNav;
@property (nonatomic, strong) UINavigationController *enterpriseMemberNav;
@property (nonatomic, strong) UINavigationController *enterpriseApplyNav;
@property (nonatomic, strong) UINavigationController *enterprisePublicNav;
@property (nonatomic, strong) UINavigationController *premoterListNav;
@property (nonatomic, strong) UINavigationController *promoterAddNav;
@property (nonatomic, strong) UINavigationController *promoterIncomeNav;
@property (nonatomic, strong) UINavigationController *promoterMoveNav;
@property (nonatomic, strong) UINavigationController *quickActiveNav;
@property (nonatomic, strong) UINavigationController *onlinePurchaseNav;
@property (nonatomic, strong) UINavigationController *outOrderListNav;

- (NSInteger)masterRowCount;
- (NSArray *)masterTitles;
- (BOOL)masterRowIsExpandable:(NSInteger)rowIdx;

- (NSInteger)subRowCountForRow:(NSInteger)masterIdx;
- (NSArray *)subRowTitlesForRow:(NSInteger)masterIdx;
- (UIImage *)iconForRow:(NSInteger)masterIdx;

- (UINavigationController *)controllerForRow:(NSInteger)row subrow:(NSInteger)subrow;

- (BOOL)indexPathIsHelp:(NSIndexPath *)path;

+ (HYMasterTableConfig *)configWithOrganType:(OrganType)organType;

@end
