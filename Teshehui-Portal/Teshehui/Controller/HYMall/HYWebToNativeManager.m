//
//  HYWebToNativeManager.m
//  Teshehui
//
//  Created by 成才 向 on 16/2/23.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYWebToNativeManager.h"
#import "HYProductDetailViewController.h"
#import "HYActivityGoodsRequest.h"
#import "HYActivityProductListViewController.h"
#import "HYMallSearchGoodsRequest.h"
#import "HYMallProductListViewController.h"
#import "HYChannelViewController.h"
#import "HYSecondKillViewController.h"
#import "HYAnalyticsManager.h"
#import "JSONKit_HY.h"
#import "NSString+Addition.h"

@implementation HYWebToNativeManager

+ (UIViewController *)checkWebToNativeCall:(NSString *)callParam
{
    NSDictionary *paramDict = [callParam objectFromJSONStringWithParseOptionsHY:JKParseOptionIgnoreDatatypes
                                                                          error:nil];
    NSString *type = [paramDict objectForKey:@"type"];
    NSDictionary *data = [paramDict objectForKey:@"data"];
    NSDictionary *expand = [data objectForKey:@"expand"];
    NSString *stgidStr = [expand objectForKey:@"stg_id"];
        
    switch (type.integerValue)
    {
        case 1: ///商品
        {
            //  详情统计
            [[HYAnalyticsManager sharedManager] beginDetailVisitFromWAP:nil
                                                                  refId:nil];
            
            HYProductDetailViewController *vc = [[HYProductDetailViewController alloc] init];
            vc.goodsId = data[@"productCode"];
            vc.stgId = stgidStr;
            return vc;
            break;
        }
        case 2: ///活动
        {
            /// 活动分类统计插码
            NSString *url = data[@"activityUrl"];
            
            HYMallHomeItem *item = [[HYMallHomeItem  alloc] init];
            item.itemType = MallHomeItemActive;
            item.url = url;
            [HYAnalyticsManager sendProductListVisitWithBannerItem:item
                                                             board:nil
                                                          fromPage:3
                                                             stgid:stgidStr];
            
            [[HYAnalyticsManager sharedManager] beginDetailVisitFromWAP:@"3"
                                                                  refId:nil];
            
            HYActivityGoodsRequest *req = [[HYActivityGoodsRequest alloc] initReqWithParamStr:url];
            HYActivityProductListViewController *vc = [[HYActivityProductListViewController alloc] init];
            vc.getDataReq = req;
            vc.title = data[@"activityName"];
            vc.stgId = stgidStr;
            return vc;
            break;
        }
        case 4: ///二级分类
        {
            NSString *url = data[@"url"];
            
            HYMallHomeItem *item = [[HYMallHomeItem  alloc] init];
            item.itemType = MallHomeItemCategory;
            item.url = url;
            [HYAnalyticsManager sendProductListVisitWithBannerItem:item
                                                             board:nil
                                                          fromPage:3
                                                             stgid:stgidStr];
            
            [[HYAnalyticsManager sharedManager] beginDetailVisitFromWAP:@"3"
                                                                  refId:nil];
            
            HYMallSearchGoodsRequest *req = [[HYMallSearchGoodsRequest alloc] initReqWithParamStr:url];
            req.searchType = @"20";
            
            HYMallProductListViewController *vc = [[HYMallProductListViewController alloc] init];
            vc.title = data[@"name"];
            vc.getSearchDataReq = req;
            vc.stgId = stgidStr;
            return vc;
            break;
        }
        case 5: ///品牌列表
        {
            NSString *url = data[@"url"];
            HYMallHomeItem *item = [[HYMallHomeItem  alloc] init];
            item.itemType = MallHomeItemBrand;
            item.url = url;
            
            [HYAnalyticsManager sendProductListVisitWithBannerItem:item
                                                             board:nil
                                                          fromPage:3
                                                             stgid:stgidStr];
            [[HYAnalyticsManager sharedManager] beginDetailVisitFromWAP:@"3"
                                                                  refId:nil];
            
            HYMallSearchGoodsRequest *req = [[HYMallSearchGoodsRequest alloc] initReqWithParamStr:url];
            req.searchType = @"30";
            
            HYMallProductListViewController *vc = [[HYMallProductListViewController alloc] init];
            vc.title = data[@"name"];
            vc.getSearchDataReq = req;
            vc.stgId = stgidStr;
            return vc;
            break;
        }
        case 6: ///搜索列表
        {
            NSString *url = data[@"url"];
            
            HYMallHomeItem *item = [[HYMallHomeItem  alloc] init];
            item.itemType = MallHomeItemSearch;
            item.url = url;
            
            [HYAnalyticsManager sendProductListVisitWithBannerItem:item
                                                             board:nil
                                                          fromPage:3
                                                             stgid:stgidStr];
            
            NSMutableDictionary *params = [[url urlParamToDic] mutableCopy];
            [[HYAnalyticsManager sharedManager] beginDetailVisitFromWAP:@"4"
                                                                  refId:[params objectForKey:@"keyword"]];
            
            HYMallSearchGoodsRequest *req = [[HYMallSearchGoodsRequest alloc] initReqWithParamStr:url];
            req.searchType = @"10";
            
            HYMallProductListViewController *vc = [[HYMallProductListViewController alloc] init];
            vc.title = data[@"name"];
            vc.getSearchDataReq = req;
            vc.stgId = stgidStr;
            return vc;
            break;
        }
        case 12:    ///秒杀
        {
            HYSecondKillViewController *vc = [[HYSecondKillViewController alloc] init];
            vc.stgId = stgidStr;
            return vc;
            break;
        }
        case 11:    ///频道页
        {
            [[HYAnalyticsManager sharedManager] beginDetailVisitFromWAP:@"2"
                                                                  refId:nil];
            
            HYChannelViewController *vc = [[HYChannelViewController alloc] init];
            vc.channelCode = data[@"channelCode"];
            vc.channelName = data[@"channelName"];
            vc.stgId = stgidStr;
            
            return vc;
            break;
        }
        default:
            break;
    }
    return nil;
}

+ (UIViewController *)checkNativeControllerWithType:(NSString *)type productCode:(NSString *)code expand:(NSString *)expand expand1:(NSString *)expand1
{
    switch (type.integerValue)
    {
        case 1: ///商品
        {
            HYProductDetailViewController *vc = [[HYProductDetailViewController alloc] init];
            vc.goodsId = code;
            return vc;
            break;
        }
        case 2: ///活动
        {
            HYActivityGoodsRequest *req = [[HYActivityGoodsRequest alloc] initReqWithParamStr:expand];
            HYActivityProductListViewController *list = [[HYActivityProductListViewController alloc] init];
            list.getDataReq = req;
            list.title = code;
            return list;
            break;
        }
        case 4: ///二级分类
        {
            HYMallSearchGoodsRequest *req = [[HYMallSearchGoodsRequest alloc] initReqWithParamStr:expand];
            req.searchType = @"20";
            
            HYMallProductListViewController *vc = [[HYMallProductListViewController alloc] init];
            vc.title = code;
            vc.getSearchDataReq = req;
            
            return vc;
            break;
        }
        case 5: ///品牌列表
        {
            HYMallSearchGoodsRequest *req = [[HYMallSearchGoodsRequest alloc] initReqWithParamStr:expand];
            req.searchType = @"30";
            
            HYMallProductListViewController *vc = [[HYMallProductListViewController alloc] init];
            vc.title = code;
            vc.getSearchDataReq = req;
            return vc;
            break;
        }
        case 6: ///搜索列表
        {
            HYMallSearchGoodsRequest *req = [[HYMallSearchGoodsRequest alloc] initReqWithParamStr:expand];
            req.searchType = @"10";
            
            HYMallProductListViewController *vc = [[HYMallProductListViewController alloc] init];
            vc.title = code;
            vc.getSearchDataReq = req;
            return vc;
            break;
        }
        case 11:    ///秒杀
        {
            HYSecondKillViewController *vc = [[HYSecondKillViewController alloc] init];
            return vc;
            break;
        }
        case 12:    ///频道页
        {
            HYChannelViewController *vc = [[HYChannelViewController alloc] init];
            vc.channelCode = code;
            vc.channelName = expand;
            return vc;
            break;
        }
        default:
            break;
    }
    return nil;
}

@end
