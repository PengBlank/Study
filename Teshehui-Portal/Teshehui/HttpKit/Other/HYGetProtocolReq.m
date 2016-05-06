//
//  HYGetProtocolReq.m
//  Teshehui
//
//  Created by HYZB on 15/4/28.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYGetProtocolReq.h"

@implementation HYGetProtocolReq

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/common/getRemoteService.action?httpUrl=%@/%@", kJavaRequestBaseURL, kMallRequestBaseURL, @"api/default/get_copywriting"];
        self.httpMethod = @"POST";
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null])
    {
        if (self.copywriting_key)
        {
            [newDic setObject:self.copywriting_key forKey:@"copywriting_key"];
        }
    }
    return newDic;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYGetProtocolResp *respose = [[HYGetProtocolResp alloc]initWithJsonDictionary:info inputKey:self.copywriting_key];
    return respose;
}

@end

@implementation HYGetProtocolResp

- (id)initWithJsonDictionary:(NSDictionary *)dictionary inputKey:(NSString *)key
{
    self = [super initWithJsonDictionary:dictionary];
    
    if (self)
    {
        NSDictionary *data = GETOBJECTFORKEY(dictionary, @"data", [NSDictionary class]);
        self.meituan_tips = GETOBJECTFORKEY(data, @"meituan_tips", [NSString class]);
        self.guijiupei = GETOBJECTFORKEY(data, @"guijiupei", [NSString class]);
        self.lightning = GETOBJECTFORKEY(data, @"lightning", [NSString class]);
        self.official = GETOBJECTFORKEY(data, @"official", [NSString class]);
        self.flower_tips = GETOBJECTFORKEY(data, @"flower_tips", [NSString class]);
        self.user_agreement = GETOBJECTFORKEY(data, @"user_agreement", [NSString class]);
        
        self.resTips = GETOBJECTFORKEY(data, key, NSString);
    }
    
    return self;
}


@end