//
//  HYSeckillAddRemindReq.m
//  Teshehui
//
//  Created by 成才 向 on 15/12/10.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYSeckillAddRemindReq.h"
#import "HYSeckillAddRemindResp.h"

@implementation HYSeckillAddRemindReq

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kJavaRequestBaseURL, @"seckill/addRemind.action"];
        self.httpMethod = @"POST";
        self.businessType = @"01";
    }
    
    return self;
}

- (NSMutableDictionary *)getDataDictionary
{
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    if (self.userId) {
        [data setObject:self.userId forKey:@"userId"];
    }
    if (self.activityId) {
        [data setObject:self.activityId forKey:@"activityId"];
    }
    if (self.productCode) {
        [data setObject:self.productCode forKey:@"productCode"];
    }
    return data;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    return [[HYSeckillAddRemindResp alloc] initWithJsonDictionary:info];
}

@end
