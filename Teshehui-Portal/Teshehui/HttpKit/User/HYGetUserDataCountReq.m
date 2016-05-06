//
//  HYGetUserDataCountReq.m
//  Teshehui
//
//  Created by HYZB on 15/12/26.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYGetUserDataCountReq.h"
#import "JSONKit_HY.h"

@implementation HYGetUserDataCountReq

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kJavaRequestBaseURL, @"userDataCount/getUserDataCount.action"];
        self.httpMethod = @"POST";
        self.postType = KeyValue;
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    
    if (newDic)
    {
        NSMutableDictionary *data = [NSMutableDictionary dictionary];
       
        if (self.userId.length)
        {
            [data setObject:self.userId forKey:@"userId"];
        }
        if ([self.dataType count])
        {
            [data setObject:self.dataType forKey:@"dataType"];
        }
        NSString *datastring = [data JSONString];
        [newDic setObject:datastring forKey:@"data"];
    }
    
    return newDic;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYGetUserDataCountResp *resp = [[HYGetUserDataCountResp alloc] initWithJsonDictionary:info];
    return resp;
}

@end

@implementation HYGetUserDataCountResp

- (id)initWithJsonDictionary:(NSDictionary *)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    
    if (self)
    {
        self.countInfo = GETOBJECTFORKEY(dictionary, @"data", [NSArray class]);
    }
    
    return self;
}

@end
