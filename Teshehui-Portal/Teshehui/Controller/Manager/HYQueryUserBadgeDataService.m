//
//  HYQueryUserBadgeDataService.m
//  Teshehui
//
//  Created by Charse on 15/12/28.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYQueryUserBadgeDataService.h"
#import "HYGetCartGoodsAmountRequest.h"
#import "HYGetCartGoodsAmountResponse.h"
#import "HYGetUserDataCountReq.h"  //获取“我”界面各个需要标记的数据

@interface HYQueryUserBadgeDataService()
{
    HYGetUserDataCountReq *_getUserDataReq;
    HYGetCartGoodsAmountRequest *_getCartAmountReq;
}

@end

@implementation HYQueryUserBadgeDataService

- (void)dealloc
{
    [_getUserDataReq cancel];
    _getUserDataReq = nil;
    
    [_getCartAmountReq cancel];
    _getCartAmountReq = nil;
}

+ (NSInteger)getBadgeWithInfo:(NSArray *)countList
                         type:(HYQueryBadgeDataType)type;
{
    if ([countList count])
    {
        NSInteger tempType = 0;
        switch (type)
        {
            case UnPayOrderBadge:
                tempType = 11;
                break;
            case UnSendOrderBadge:
                tempType = 12;
                break;
            case UnRecvOrderBadge:
                tempType = 13;
                break;
            case RedPagketTotal:
                tempType = 20;
                break;
            case SendRedPagket:
                tempType = 21;
                break;
            case RecvRedPagket:
                tempType = 22;
                break;
            case ShoppingCartBadge:
            {
                return [countList[0] integerValue];
            }
                break;
            default:
                break;
        }
        
        
        /*
         {
         dataCountValue = 3;
         dataType = 22;
         }
         */
        NSString *count = nil;
        for (NSDictionary *dic in countList)
        {
            NSString *typeStr = [dic objectForKey:@"dataType"];

            if (typeStr.integerValue == tempType)
            {
                count = [dic objectForKey:@"dataCountValue"];
                break;
            }
        }
        
        return count.integerValue;
    }
    //购物车数量
    
    
    return 0;
}
/**
 *  <#Description#>
 *
 *  @param type     <#type description#>
 *  @param callback <#callback description#>
 
 "数据类型标识，mallOrderWaitPay(\"11\",\"订单待付款\"),mallOrderWaitDelivery(\"12\",\"订单待发货\"),mallOrderWaitSign(\"13\",\"订单待收货\"),     red(\"20\",\"红包\"),redSend(\"21\",\"红包发送\"),redReceive(\"22\",\"红包接收\")"
 
 */
- (void)queryUserInfoViewBadgeWithType:(HYQueryBadgeDataType)type
                              callback:(HYQueryBadgeCallback)callback
{
    _getUserDataReq = [[HYGetUserDataCountReq alloc] init];
    
    NSArray *types = nil;
    switch (type)
    {
        case OrderBadge:
            types = @[@"11", @"12", @"13"];
            break;
        case WalletBadge:
            types = @[@"21", @"22"];
            break;
        case WalletAndOrderbadge:
            types = @[@"11", @"12", @"13", @"21", @"22"];
            break;
        case ShoppingCartBadge:
        {
            if (!_getCartAmountReq)
            {
                _getCartAmountReq = [[HYGetCartGoodsAmountRequest alloc]init];
            }
            [_getCartAmountReq cancel];
            
            [_getCartAmountReq sendReuqest:^(HYGetCartGoodsAmountResponse *result, NSError *error) {
                if (!error && [result isKindOfClass:[HYGetCartGoodsAmountResponse class]])
                {
                    HYGetCartGoodsAmountResponse *resp = (HYGetCartGoodsAmountResponse *)result;
                    callback(@[@(resp.amount)], nil);
                }
                else
                {
                    callback(nil, error);
                }
            }];
            return;
        }
        default:
            break;
    }
    
    _getUserDataReq.dataType = types;
    
    [_getUserDataReq sendReuqest:^(id result, NSError *error) {
        if (!error && [result isKindOfClass:[HYGetUserDataCountResp class]])
        {
            HYGetUserDataCountResp *resp = (HYGetUserDataCountResp *)result;
            callback(resp.countInfo, nil);
        }
        else
        {
            callback(nil, error);
        }
    }];
}

- (void)cancel
{
    [_getUserDataReq cancel];
    _getUserDataReq = nil;
    
    [_getCartAmountReq cancel];
    _getCartAmountReq = nil;
}

@end
