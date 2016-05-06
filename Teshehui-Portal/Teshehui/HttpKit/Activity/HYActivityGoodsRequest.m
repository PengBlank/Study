//
//  HYActivityGoodsRequest.m
//  Teshehui
//
//  Created by RayXiang on 14-8-4.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYActivityGoodsRequest.h"
#import "NSString+Addition.h"

@interface HYActivityGoodsRequest ()

@property (nonatomic,copy) NSString *reqParam;

@end

@implementation HYActivityGoodsRequest

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kJavaRequestBaseURL, @"index/getActivityProductList.action"];
        self.httpMethod = @"POST";
        self.pageSize = 10;
    }
    
    return self;
}

- (id)initReqWithParamStr:(NSString *)paramStr
{
    if ([self init])
    {
        self.reqParam = paramStr;
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null])
    {
        [newDic setObject:@"app" forKey:@"source"];
        if (self.activityCode.length > 0)
        {
            [newDic setObject:self.activityCode
                       forKey:@"activityCode"];
        }
        
        [newDic setObject:[NSNumber numberWithInteger:self.pageNo]
                   forKey:@"pageNo"];
        [newDic setObject:[NSNumber numberWithInteger:self.pageSize]
                   forKey:@"pageSize"];
        
        if ([self.reqParam length] > 0)
        {
            NSDictionary *dic = [self.reqParam urlParamToDic];
            [newDic addEntriesFromDictionary:dic];
        }
    }
    return newDic;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYActivityGoodsResponse *respose = [[HYActivityGoodsResponse alloc]initWithJsonDictionary:info];
    return respose;
}

@end
