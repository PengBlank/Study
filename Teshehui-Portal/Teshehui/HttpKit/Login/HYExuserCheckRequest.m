//
//  HYExuserCheckRequest.m
//  Teshehui
//
//  Created by 成才 向 on 15/8/17.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYExuserCheckRequest.h"
#import "JSONKit_HY.h"

@implementation HYExuserCheckRequest

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/user/experienceUserRegisterCheck.action", kJavaRequestBaseURL];
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
        if (self.mobilephone)
        {
            [data setObject:_mobilephone forKey:@"mobilephone"];
        }
        
        NSString *datajson = [data JSONString];
        if (datajson.length > 0)
        {
            [newDic setObject:datajson forKey:@"data"];
        }
    }
    
    return newDic;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYExuserCheckResponse *respose = [[HYExuserCheckResponse alloc]initWithJsonDictionary:info];
    return respose;
}


@end
