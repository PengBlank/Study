//
//  HYMallAdsReq.m
//  Teshehui
//
//  Created by Kris on 16/1/6.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYMallAdsReq.h"

@implementation HYMallAdsReq

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kJavaRequestBaseURL, @"index/getBoardContent.action"];
        self.httpMethod = @"POST";
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null])
    {
        if (self.boardCodes)
        {
            [newDic setObject:self.boardCodes
                       forKey:@"boardCodes"];
        }
    }
    return newDic;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYMallAdsResponse *respose = [[HYMallAdsResponse alloc]initWithJsonDictionary:info];
    return respose;
}

@end
