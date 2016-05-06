//
//  HYShakeViewRequest.m
//  Teshehui
//
//  Created by HYZB on 16/3/24.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYShakeViewRequest.h"
#import "HYShakeViewResponse.h"

@implementation HYShakeViewRequest

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kJavaRequestBaseURL, @"shake/doShake.action"];
        self.httpMethod = @"POST";
    }
    return self;
}

//- (NSMutableDictionary *)getDataDictionary
//{
//    NSMutableDictionary *data = [NSMutableDictionary dictionary];
//    
//    if (self.userId)
//    {
//        [data setObject:self.userId forKey:@"userId"];
//    }
//    
//    return data;
//}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    return [[HYShakeViewResponse alloc] initWithJsonDictionary:info];
}

@end
