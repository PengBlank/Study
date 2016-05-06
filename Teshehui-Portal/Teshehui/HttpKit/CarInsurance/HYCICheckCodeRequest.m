//
//  HYCICheckCodeRequest.m
//  Teshehui
//
//  Created by 成才 向 on 15/7/16.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYCICheckCodeRequest.h"
#import "JSONKit_HY.h"
#import "HYCICheckCodeResponse.h"

@implementation HYCICheckCodeRequest

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@",kJavaRequestBaseURL,@"insurance/car/validateInsuranceCheckCode.action"];
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
        
        if ([self.sessionid length] > 0)
        {
            [data setObject:self.sessionid forKey:@"sessionId"];
        }
        if (self.checkcode.length > 0)
        {
            [data setObject:self.checkcode forKey:@"checkCode"];
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
    HYCICheckCodeResponse *respose = [[HYCICheckCodeResponse alloc]initWithJsonDictionary:info];
    return respose;
}


@end
