//
//  HYGetMessageRequest.m
//  Teshehui
//
//  Created by ichina on 14-3-4.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYGetMessageRequest.h"
#import "HYGetMessageResponse.h"

@implementation HYGetMessageRequest

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/common/getRemoteService.action?httpUrl=%@/%@", kJavaRequestBaseURL, kMallRequestBaseURL, @"api/users/message_list"];
        self.httpMethod = @"POST";
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null])
    {
        
        if ([self.page length] > 0) {
            
            [newDic setObject:self.page forKey:@"page"];
        }
        
        if ([self.num_per_page length] > 0) {
            
            [newDic setObject:self.num_per_page forKey:@"num_per_page"];
        }
    }
    
    return newDic;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
   HYGetMessageResponse *respose = [[HYGetMessageResponse alloc]initWithJsonDictionary:info];
    return respose;
}


@end
