//
//  HYMasterTableViewDataSource.m
//  HYManagmentDept
//
//  Created by Ray on 14-12-9.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYMasterTableConfig.h"
#import "HYMasterCompanyConfig.h"
#import "HYMasterAgencyConfig.h"
#import "HYMasterPromotersConfig.h"

@interface HYMasterTableConfig ()

@end

@implementation HYMasterTableConfig

- (NSInteger)masterRowCount
{
    return 0;
}
- (NSArray *)masterTitles
{
    return nil;
}
- (BOOL)masterRowIsExpandable:(NSInteger)rowIdx
{
    return NO;
}
- (NSArray *)subRowTitlesForRow:(NSInteger)masterIdx
{
    return nil;
}

- (UIImage *)iconForRow:(NSInteger)masterIdx
{
    return [UIImage imageNamed:@"list_i1"];
    return nil;
}

- (NSInteger)subRowCountForRow:(NSInteger)masterIdx
{
    return 0;
}

- (UINavigationController *)controllerForRow:(NSInteger)row subrow:(NSInteger)subrow
{
    return nil;
}

#pragma mark -
#pragma mark ViewControllers
- (void)didReceiveMemoryWarning
{
    
}


- (UINavigationController *)summaryNav
{
    if (!_summaryNav) {
        HYSummaryDetailViewController *overviewViewController = [[HYSummaryDetailViewController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:overviewViewController];
        //nav.navigationBarHidden = YES;
        _summaryNav = nav;
    }
    return _summaryNav;
}

- (UINavigationController *)accountNav
{
    if (!_accountNav) {
        HYAccountViewController *account = [[HYAccountViewController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:account];
        _accountNav = nav;
    }
    return _accountNav;
}

- (UINavigationController *)orderListNav
{
    if (!_orderListNav) {
        HYOrderListViewController *order = [[HYOrderListViewController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:order];
        _orderListNav = nav;
    }
    return _orderListNav;
}

- (UINavigationController *)agencyCenterNav
{
    if (!_agencyCenterNav) {
        HYAgencyCenterViewController *agency = [[HYAgencyCenterViewController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:agency];
        _agencyCenterNav = nav;
    }
    return _agencyCenterNav;
}

- (UINavigationController *)cardListNav
{
    if (!_cardListNav) {
        HYCardListViewController *agency = [[HYCardListViewController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:agency];
        _cardListNav = nav;
    }
    return _cardListNav;
}

- (UINavigationController *)addCardNav
{
    if (!_addCardNav) {
        HYAddCardViewController *agency = [[HYAddCardViewController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:agency];
        _addCardNav = nav;
    }
    return _addCardNav;
}

#define GetMember(member, memberc) - (UINavigationController *)member \
{ \
if(!_##member) { \
memberc *account = [[memberc alloc] init];\
UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:account];\
_##member = nav;\
}\
return _##member;\
}

GetMember(vipListNav, HYVIPListViewController)
GetMember(companyIncomeNav, HYCompanyIncomeViewController)
GetMember(agencyIncomeNav, HYAgencyIncomeViewController)
GetMember(enterpriseMemberNav, HYEnterpriseMemberListViewController)
GetMember(enterpriseApplyNav, HYEnterpriseApplyViewController)
GetMember(enterprisePublicNav, HYEnterpriseCardPublishViewController)
GetMember(premoterListNav, HYPremoterListViewController)
GetMember(promoterAddNav, HYPromoterAddViewController)
GetMember(promoterIncomeNav, HYPromoterIncomeViewController)
GetMember(promoterMoveNav, HYPromoterCardMoveViewController)
GetMember(quickActiveNav, HYQuickActiveViewController)
GetMember(outOrderListNav, HYOutOrderListViewController)
//GetMember(onlinePurchaseNav, HYQuickActive2ViewController)

#pragma mark -

+ (HYMasterTableConfig *)configWithOrganType:(OrganType)organType
{
    HYMasterTableConfig *ret = nil;
    switch (organType) {
        case OrganTypeCompany:
            ret = [[HYMasterCompanyConfig alloc] init];
            break;
        case OrganTypeAgency:
            ret = [[HYMasterAgencyConfig alloc] init];
            break;
        case OrganTypePromoter:
            ret = [[HYMasterPromotersConfig alloc] init];
            break;
        default:
            break;
    }
    return ret;
}

- (BOOL)indexPathIsHelp:(NSIndexPath *)path
{
    return NO;
}

@end
