//
//  HYGetFunctionModuleTipsRequest.m
//  Teshehui
//
//  Created by HYZB on 15/12/28.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYGetFunctionModuleTipsRequest.h"

@implementation HYGetFunctionModuleTipsRequest

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kJavaRequestBaseURL, @"index/getFunctionModuleTips.action"];
        self.httpMethod = @"POST";
    }
    
    return self;
}

- (NSMutableDictionary *)getDataDictionary
{
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    
    if (self.moduleCode) {
        [data setObject:self.moduleCode forKey:@"moduleCode"];
    }
    
    return data;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYGetFunctionModuleTipsResponse *response = [[HYGetFunctionModuleTipsResponse alloc] initWithJsonDictionary:info];
    return response;
}

@end

@implementation HYGetFunctionModuleTipsResponse

- (id)initWithJsonDictionary:(NSDictionary*)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    
    if (self)
    {
        self.mwqq_tips = GETOBJECTFORKEY(dictionary, @"data", [NSString class]);
        
    }
    
    return self;
}


@end
