//
//  HYMasterAgencyConfig.m
//  HYManagmentDept
//
//  Created by Ray on 14-12-9.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYMasterAgencyConfig.h"

@implementation HYMasterAgencyConfig

- (UIImage *)iconForRow:(NSInteger)masterIdx
{
    static NSArray *icons = nil;
    if (!icons)
    {
        icons = [NSArray arrayWithObjects:[UIImage imageNamed:@"ic_kongzhitai"], [UIImage imageNamed:@"ic_dingdan"],  [UIImage imageNamed:@"ic_huiyuanka"], [UIImage imageNamed:@"ic_huiyuan"], [UIImage imageNamed:@"ic_shouyi"], [UIImage imageNamed:@"ic_qiyehuiyuan"], [UIImage imageNamed:@"ic_caozuoyuan"], [UIImage imageNamed:@"ic_bangzhu"], [UIImage imageNamed:@"ic_wode"], nil];
    }
    return [icons objectAtIndex:masterIdx];
}

- (NSInteger)masterRowCount
{
    return 9;
}

- (NSArray *)masterTitles
{
    static NSArray *masterTitles = nil;
    if (!masterTitles) {
        masterTitles = @[@"概览", @"订单列表", @"会员卡", @"会员列表", @"月结收益", @"企业会员", @"我的操作员", @"帮助中心", @"我的帐户"];
    }
    return masterTitles;
}

- (BOOL)masterRowIsExpandable:(NSInteger)rowIdx
{
    BOOL expandable = NO;
    static NSSet *set = nil;
    if (!set) {
        set = [NSSet setWithObjects:@1,@2, @5, @6, @7, nil];
    }
    expandable = [set containsObject:[NSNumber numberWithInteger:rowIdx]];
    return expandable;
}

- (NSInteger)subRowCountForRow:(NSInteger)masterIdx
{
    switch (masterIdx) {
        case 1:
            return 2;
            break;
        case 2:
            
            return 1;
        case 3:
            return 0;
            break;
        case 5:
        {
            return 3;
            break;
        }
        case 6:
        {
            return 4;
            break;
        }
        case 7:
        {
            return 4;
            break;
        }
        case 8:
        {
            return 0;
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
                   @2: @[@"会员卡列表"],
                   @5: @[@"企业会员列表", @"企业会员申请", @"指定企业"],
                   @6: @[@"操作员列表", @"添加操作员", @"操作员补贴", @"指定操作员"],
                   @7: @[@"特奢汇", @"运营中心帮助文档", @"会员帮助文档", @"消费扫码说明"]
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
            break;
        case 2: //会员卡
            if (subRow == 1) {
                return self.cardListNav;
            }
            break;
        case 3: //会员列表
            return self.vipListNav;
            break;
        case 4: //我的收益(中心收益)
        {
            HYAgencyIncomeViewController *income = [self.agencyIncomeNav.viewControllers objectAtIndex:0];
            income.title = @"月结收益";
            return self.agencyIncomeNav;
        }
            break;
        case 5: //企业会员
            if (subRow == 1)
            {
                return self.enterpriseMemberNav;
            }
            else if (subRow == 2)
            {
                HYEnterpriseApplyViewController *etApply = [[self.enterpriseApplyNav viewControllers] objectAtIndex:0];
                [etApply reloadDatas];
                return self.enterpriseApplyNav;
            } else if (subRow == 3)
            {
                HYEnterpriseCardPublishViewController *addcard = [[self.enterprisePublicNav viewControllers] objectAtIndex:0];
                [addcard loadAgencyList];
                return self.enterprisePublicNav;
            }
            break;
        case 6: //我的操作员
            switch (subRow) {
                case 1:
                {
                    return self.premoterListNav;
                    break;
                }
                case 2:
                {
                    HYPromoterAddViewController *cardMove = [self.promoterAddNav.viewControllers objectAtIndex:0];
                    [cardMove clearInfo];
                    return self.promoterAddNav;
                    break;
                }
                case 3:
                {
                    return self.promoterIncomeNav;
                    break;
                }
                case 4:
                {
                    HYPromoterCardMoveViewController *cardMove = [self.promoterMoveNav.viewControllers objectAtIndex:0];
                    [cardMove loadPromoterList];
                    return self.promoterMoveNav;
                    break;
                }
                default:
                    return nil;
                    break;
            }
            break;
        case 8: //帐户
            return self.accountNav;
            break;
        case 7:
            //[self showHelpViewWithIndex:subRow];
            return nil;
            break;
        default:
            return nil;
            break;
    }
    return nil;
}

- (BOOL)indexPathIsHelp:(NSIndexPath *)path
{
    return path.row == 7;
}

@end
