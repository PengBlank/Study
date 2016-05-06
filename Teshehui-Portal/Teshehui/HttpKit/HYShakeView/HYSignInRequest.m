//
//  HYSignInRequest.m
//  Teshehui
//
//  Created by HYZB on 16/3/28.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYSignInRequest.h"
#import "HYSignInResponse.h"

@implementation HYSignInRequest

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kJavaRequestBaseURL, @"shake/queryUserSignStatus.action"];
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
    return [[HYSignInResponse alloc] initWithJsonDictionary:info];
}

@end
