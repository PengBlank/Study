//
//  HYSeckillCancelRemindReq.m
//  Teshehui
//
//  Created by 成才 向 on 15/12/10.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYSeckillCancelRemindReq.h"
#import "HYSeckillCancelRemindResp.h"

@implementation HYSeckillCancelRemindReq

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kJavaRequestBaseURL, @"seckill/cancelRemind.action"];
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
    if (self.remindId) {
        [data setObject:self.remindId forKey:@"remindId"];
    }
    return data;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    return [[HYSeckillCancelRemindResp alloc] initWithJsonDictionary:info];
}

@end
