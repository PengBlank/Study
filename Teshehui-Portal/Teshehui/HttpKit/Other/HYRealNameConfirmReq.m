//
//  HYRealNameConfirmReq.m
//  Teshehui
//
//  Created by Kris on 15/9/12.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYRealNameConfirmReq.h"
#import "HYRealNameResponse.h"
#import "JSONKit_HY.h"

@implementation HYRealNameConfirmReq

- (id)init
{
    self = [super init];
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/user/authentication.action", kJavaRequestBaseURL];
//        self.interfaceURL = @"http://192.168.0.50:8080/tsh-portal-web/user/authentication.action";
//        self.postType = JSON;
        self.httpMethod = @"POST";
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null])
    {
        if ([_certificateNumber length]>0
            && [_realName length]>0 && (self.userId))
        {
            NSDictionary *dict = @{@"userId":self.userId,
                                   @"certificateCode":@"01",
                                   @"certificateNumber":_certificateNumber,
                                   @"realName":_realName};
            NSString *data = [dict JSONString];
            if ([data length]>0)
            {
                [newDic setObject:data forKey:@"data"];
            }
        }
    }
    return newDic;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYRealNameResponse *respose = [[HYRealNameResponse alloc]initWithJsonDictionary:info];
    return respose;
}

@end
