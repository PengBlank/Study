//
//  HYFlowerTypeListRequest.m
//  Teshehui
//
//  Created by 回亿资本 on 14-2-7.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYFlowerTypeListRequest.h"

@implementation HYFlowerTypeListRequest

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kJavaRequestBaseURL, @"category/queryCategory.action"];
        self.httpMethod = @"POST";
        self.businessType = @"04";
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    
    if (newDic && (NSNull *)newDic != [NSNull null])
    {
        [newDic setObject:self.businessType
                   forKey:@"businessType"];
        
        if ([self.categoryId length] > 0)
        {
            [newDic setObject:self.categoryId forKey:@"categoryId"];
        }
        
        if ([self.level length] > 0)
        {
            [newDic setObject:self.level forKey:@"level"];
        }
    }
    
    return newDic;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYFlowerTypeListResponse *respose = [[HYFlowerTypeListResponse alloc]initWithJsonDictionary:info];
    return respose;
}

@end
