//
//  HYGetHelpRequest.m
//  Teshehui
//
//  Created by ichina on 14-3-7.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYGetHelpRequest.h"
#import "HYGetHelpResponse.h"

@implementation HYGetHelpRequest

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/common/getRemoteService.action?httpUrl=%@/%@", kJavaRequestBaseURL, kMallRequestBaseURL, @"api/help/get_help_info"];
        self.httpMethod = @"POST";
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null])
    {
        
        if ([self.version_no length] > 0) {
            
            [newDic setObject:self.version_no forKey:@"version_no"];
        }
        
        if ([self.type length ]> 0) {
             [newDic setObject:self.type forKey:@"type"];
        }
        
    }
    
    return newDic;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYGetHelpResponse *respose = [[HYGetHelpResponse alloc]initWithJsonDictionary:info];
    return respose;
}

@end
