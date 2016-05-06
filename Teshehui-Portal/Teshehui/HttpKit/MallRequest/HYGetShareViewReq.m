//
//  HYGetShareViewReq.m
//  Teshehui
//
//  Created by HYZB on 16/4/6.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYGetShareViewReq.h"

@implementation HYGetShareViewReq

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/api/default/getUrl",kMallRequestBaseURL];
        self.httpMethod = @"POST";
    }
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null])
    {
        if (self.type)
        {
            [newDic setObject:@(self.type) forKey:@"type"];
        }
    }
    
    return newDic;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYGetShareViewResp *respose = [[HYGetShareViewResp alloc]initWithJsonDictionary:info];
    return respose;
}

@end


@implementation HYGetShareViewResp

- (id)initWithJsonDictionary:(NSDictionary *)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    if (self)
    {
        NSDictionary *data = GETOBJECTFORKEY(dictionary, @"data", NSDictionary);
        self.shareTitle = GETOBJECTFORKEY(data, @"shareTitle", [NSString class]);
        self.shareUrl = GETOBJECTFORKEY(data, @"shareUrl", [NSString class]);
    }
    
    return self;
}

@end
