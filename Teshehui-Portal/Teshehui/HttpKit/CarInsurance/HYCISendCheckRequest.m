//
//  HYCISendCheckRequest.m
//  Teshehui
//
//  Created by Kris on 15/7/16.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYCISendCheckRequest.h"
#import "HYCISendCheckResponse.h"
#import "JSONKit_HY.h"

@implementation HYCISendCheckRequest

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@",kJavaRequestBaseURL,@"insurance/car/getInsuranceCheckCode.action"];
        self.httpMethod = @"POST";
    }
    
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null])
    {
        NSMutableDictionary *data = [NSMutableDictionary dictionary];
        
        if ([self.sessionId length] > 0)
        {
            [data setObject:self.sessionId forKey:@"sessionId"];
        }
        
        NSString *jsondata = [data JSONString];
        DebugNSLog(@"json:%@", jsondata);
        
        if ([jsondata length] > 0)
        {
            [newDic setObject:jsondata forKey:@"data"];
        }
    }
    return newDic;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYCISendCheckResponse *respose = [[HYCISendCheckResponse alloc]initWithJsonDictionary:info];
    return respose;
}

@end
