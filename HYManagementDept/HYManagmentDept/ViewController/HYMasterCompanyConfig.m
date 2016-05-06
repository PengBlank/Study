//
//  HYMasterTableCompanySource.m
//  HYManagmentDept
//
//  Created by Ray on 14-12-9.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYMasterCompanyConfig.h"

@implementation HYMasterCompanyConfig

- (NSInteger)masterRowCount
{
    return 10;
}

- (NSArray *)masterTitles
{
    static NSArray *masterTitles = nil;
    if (!masterTitles) {
        masterTitles = @[@"概览", @"订单列表", @"运营中心", @"会员卡", @"会员列表", @"月结收益", @"运营中心收益", @"企业会员", @"帮助中心", @"我的帐户"];
    }
    return masterTitles;
}

- (UIImage *)iconForRow:(NSInteger)masterIdx
{
    static NSArray *icons = nil;
    if (!icons)
    {
        icons = [NSArray arrayWithObjects:[UIImage imageNamed:@"ic_kongzhitai"], [UIImage imageNamed:@"ic_dingdan"], [UIImage imageNamed:@"ic_zhongxin"], [UIImage imageNamed:@"ic_huiyuanka"], [UIImage imageNamed:@"ic_huiyuan"], [UIImage imageNamed:@"ic_shouyi"], [UIImage imageNamed:@"ic_zhongxinshouyi"], [UIImage imageNamed:@"ic_qiyehuiyuan"], [UIImage imageNamed:@"ic_bangzhu"], [UIImage imageNamed:@"ic_wode"], nil];
    }
    return [icons objectAtIndex:masterIdx];
}

- (BOOL)masterRowIsExpandable:(NSInteger)rowIdx
{
    BOOL expandable = NO;
    static NSSet *company = nil;
    if (!company) {
        company = [NSSet setWithObjects:@1, @3, @7, @8, nil];
    }
    expandable = [company containsObject:[NSNumber numberWithInteger:rowIdx]];
    return expandable;
}

- (NSInteger)subRowCountForRow:(NSInteger)masterIdx
{
    switch (masterIdx) {
        case 1:
            return 2;
            break;
        case 3:
            return 2;
            break;
        case 7:
        {
            return 2;
            break;
        }
        case 8:
        {
            return 4;
        }
            break;
        default:
            return 0;
            break;
    }
}

- (NSArray *)subRowTitlesForRow:(NSInteger)masterIdx
{
    static NSDictionary *titles = nil;
    if (!titles) {
        titles = @{@1: @[@"已结算订单", @"待结算订单"],
                   @3: @[@"会员卡列表", @"分配会员卡"],
                   @7: @[@"企业会员列表", @"企业会员申请", @"指定企业"],
                   @8: @[@"特奢汇", @"运营中心帮助文档", @"会员帮助文档", @"消费扫码说明"]
                   };
    }
    return [titles objectForKey:[NSNumber numberWithInteger:masterIdx]];
}

- (UINavigationController *)controllerForRow:(NSInteger)row subrow:(NSInteger)subRow
{
    switch (row) {
        case 0:
            return self.summaryNav;
            break;
        case 1:
            if (subRow == 1)
            {
                return self.orderListNav;
            }
            else if (subRow == 2)
            {
                HYOutOrderListViewController *proInco = [self.outOrderListNav.viewControllers firstObject];
                proInco.title = @"待结算订单";
                return self.outOrderListNav;
            }
            if (subRow!=0 && subRow<3)
            {
                HYOrderListViewController *orderListVC = [[self.orderListNav viewControllers] objectAtIndex:0];
                NSArray *titles = @[@"商城订单列表", @"鲜花订单列表", @"机票订单列表", @"酒店订单列表", @"在线购卡订单", @"团购订单"];
                orderListVC.title = [titles objectAtIndex:subRow-1];
                orderListVC.orderType = (OrderType)subRow;
                [orderListVC reloadData];
                return self.orderListNav;
            }
            break;
        case 2: //运营中心
            return self.agencyCenterNav;
            break;
        case 3: //会员卡
            if (subRow == 1)    //列表
            {
                return self.cardListNav;
            }
            if (subRow == 2)    //批发
            {
                HYAddCardViewController *addcard = [[self.addCardNav viewControllers] objectAtIndex:0];
                [addcard loadAgencyList];
                return self.addCardNav;
            }
            break;
        case 4: //会员列表
            return self.vipListNav;
            break;
        case 5: //我的收益(公司收益)
        {
            HYCompanyIncomeViewController *income = [self.companyIncomeNav.viewControllers objectAtIndex:0];
            income.title = @"月结收益";
            return self.companyIncomeNav;
        }
            break;
        case 6: //中心收益
        {
            HYAgencyIncomeViewController *agency = [self.agencyIncomeNav.viewControllers objectAtIndex:0];
            agency.title = @"运营中心收益";
            return self.agencyIncomeNav;
            break;
        }
        case 7: //企业
            if (subRow == 1)    //列表
            {
                return self.enterpriseMemberNav;
            }
            else if (subRow == 2)   //审批
            {
                HYEnterpriseApplyViewController *etApply = [[self.enterpriseApplyNav viewControllers] objectAtIndex:0];
                [etApply reloadDatas];
                return self.enterpriseApplyNav;
            } else if (subRow == 3) //转移
            {
                HYEnterpriseCardPublishViewController *addcard = [[self.enterprisePublicNav viewControllers] objectAtIndex:0];
                [addcard loadAgencyList];
                return self.enterprisePublicNav;
            }
            break;
        case 9: //帐户
            return self.accountNav;
            break;
        default:
            break;
    }
    return nil;
}

- (BOOL)indexPathIsHelp:(NSIndexPath *)path
{
    return path.row == 8;
}

@end
