//
//  HYQueryUserBadgeDataService.h
//  Teshehui
//
//  Created by Charse on 15/12/28.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

/**
 *  查询app里面各种标记的管理对象
 */
#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, HYQueryBadgeDataType)
{
    UnPayOrderBadge     = 1,     //未付款
    UnSendOrderBadge    = 1<<2,  //未发货
    UnRecvOrderBadge    = 1<<3,  //未收货
    OrderBadge       = UnPayOrderBadge|UnSendOrderBadge|UnRecvOrderBadge,   //订单
    RedPagketTotal     = 1<<4,  //红包总数
    SendRedPagket        = 1<<5,  //发出的红包数
    RecvRedPagket           = 1<<6,  //收到的红包数
    WalletBadge       = RedPagketTotal|SendRedPagket|RecvRedPagket,   //钱包
    WalletAndOrderbadge = OrderBadge|WalletBadge,
    ShoppingCartBadge   = 1<<7,  //购物车
};

/**
 *  <#Description#>
 *
 *  @param countInfo badge数据的组合，里面存的默认是dic
 *  @param err       <#err description#>
 */
typedef void(^HYQueryBadgeCallback)(NSArray *countInfo, NSError *err);

@interface HYQueryUserBadgeDataService : NSObject

+ (NSInteger)getBadgeWithInfo:(NSArray *)countList
                         type:(HYQueryBadgeDataType)type;

- (void)queryUserInfoViewBadgeWithType:(HYQueryBadgeDataType)type
                              callback:(HYQueryBadgeCallback)callback;
- (void)cancel;

@end
