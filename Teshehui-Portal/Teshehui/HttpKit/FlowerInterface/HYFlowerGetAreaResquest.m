//
//  HYFlowerGetAreaResquest.m
//  Teshehui
//
//  Created by ichina on 14-2-18.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYFlowerGetAreaResquest.h"
#import "HYFlowerGetAreaResponse.h"

@implementation HYFlowerGetAreaResquest

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/common/getRemoteService.action?httpUrl=%@/%@", kJavaRequestBaseURL, kFlowerRequestBaseURL, @"api/products/AreaSubCategory"];
        self.httpMethod = @"POST";
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    
    if (newDic && (NSNull *)newDic != [NSNull null])
    {
        if ([self.ParentID length] > 0)
        {
            [newDic setObject:self.ParentID forKey:@"ParentID"];
        }
    }
    
    return newDic;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYFlowerGetAreaResponse *respose = [[HYFlowerGetAreaResponse alloc]initWithJsonDictionary:info];
    return respose;
}


@end
