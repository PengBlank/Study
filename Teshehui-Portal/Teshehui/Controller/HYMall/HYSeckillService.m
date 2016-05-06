//
//  HYSeckillService.m
//  Teshehui
//
//  Created by 成才 向 on 15/12/10.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYSeckillService.h"
#import "HYSeckillActivityListReq.h"

@interface HYSeckillService ()

@property (nonatomic, strong) HYSeckillActivityListReq *activityListReq;

@end

@implementation HYSeckillService

- (void)dealloc
{
    [_activityListReq cancel];
}

- (void)getSeckillActivities:(void (^)(NSArray<HYSeckillActivityModel *> *, NSString *))callback
{
    if (_activityListReq) {
        [_activityListReq cancel];
    }
    _activityListReq = [[HYSeckillActivityListReq alloc] init];
    [_activityListReq sendReuqest:^(id result, NSError *error)
    {
        if ([result isKindOfClass:[HYSeckillActivityListResp class]])
        {
            HYSeckillActivityListResp *resp = (HYSeckillActivityListResp *)result;
            if (resp.status == 200)
            {
                callback(resp.activityList, nil);
            }
            else
            {
                callback(nil, error.domain);
            }
        }
        else
        {
            callback(nil, error.domain);
        }
    }];
}

@end
