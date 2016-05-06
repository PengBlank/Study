//
//  HYCheckDidiOrderRequest.m
//  Teshehui
//
//  Created by Kris on 15/11/19.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYCheckDidiOrderRequest.h"
#import "HYCheckDidiOrderResponse.h"
#import "HYUserInfo.h"
#import "JSONKit_HY.h"

@implementation HYCheckDidiOrderRequest

- (id)init
{
    self = [super init];
    
    if (self)
    {
        
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kJavaRequestBaseURL, @"traffic/didi/checkUserDidiPermission.action"];
        self.httpMethod = @"POST";
        self.businessType = @"22";
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null])
    {
        NSDictionary *dict = @{@"userId" : self.userId};
        NSString *data = [dict JSONString];
        if (data)
        {
           [newDic setObject:data forKey:@"data"];
        }
    }
    return newDic;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYCheckDidiOrderResponse *respose = [[HYCheckDidiOrderResponse alloc]initWithJsonDictionary:info];
    return respose;
}

@end
