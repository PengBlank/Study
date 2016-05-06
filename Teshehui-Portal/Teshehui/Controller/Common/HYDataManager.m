//
//  HYDataManager.m
//  Teshehui
//
//  Created by 成才 向 on 15/12/21.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYDataManager.h"
#import "HYGetRedpacketCountReq.h"
#import "HYGetCartGoodsAmountRequest.h"

@interface HYDataManager ()
{
    HYGetRedpacketCountReq *_getRedpacketReq;
}


@end

@implementation HYDataManager

+ (instancetype)sharedManager
{
    static HYDataManager *__sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __sharedManager = [[HYDataManager alloc] init];
    });
    return __sharedManager;
}

- (void)queryNewRedpacketCount:(void (^)(NSInteger))callback needRefresh:(BOOL)refresh
{
    NSNumber *count = [[NSUserDefaults standardUserDefaults] objectForKey:kRedpacketCount];
    if (!count || refresh)
    {
        _getRedpacketReq = [[HYGetRedpacketCountReq alloc] init];
        [_getRedpacketReq sendReuqest:^(id result, NSError *error) {
            if (!error)
            {
                HYGetRedpacketCountResp *resp = (HYGetRedpacketCountResp *)result;
                NSInteger count = resp.count;
                [[NSUserDefaults standardUserDefaults] setObject:@(count) forKey:kRedpacketCount];
                callback(count);
            }
            else
            {
                callback(0);
            }
        }];
    }
    else
    {
        callback(count.integerValue);
    }
}

- (void)queryCartCount:(void (^)(NSInteger))callback needRefresh:(BOOL)refresh
{
    NSNumber *count = [[NSUserDefaults standardUserDefaults] objectForKey:kShoppingCarHasNew];
    if (!count || refresh)
    {
        //查看购物车
        HYGetCartGoodsAmountRequest *req = [[HYGetCartGoodsAmountRequest alloc] init];
        [req sendReuqest:^(id result, NSError *error) {
            if (!error && [result isKindOfClass:[HYGetCartGoodsAmountResponse class]])
            {
                HYGetCartGoodsAmountResponse *response = (HYGetCartGoodsAmountResponse *)result;
                if (response.amount > 0)
                {
                    [[NSUserDefaults standardUserDefaults] setObject:@(response.amount) forKey:kShoppingCarHasNew];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    callback(response.amount);
                }
            }
        }];
    }
    else
    {
        callback(count.integerValue);
    }
}

@end
