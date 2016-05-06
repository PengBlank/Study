//
//  HYGetPolicyListRequest.m
//  Teshehui
//
//  Created by Kris on 15/11/11.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYGetPolicyListRequest.h"
#import "HYGetPolicyListResponse.h"
#import "JSONKit_HY.h"

@implementation HYGetPolicyListRequest

- (id)init
{
    self = [super init];
    
    if (self)
    {
        
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kJavaRequestBaseURL, @"insurance/getInsuranceTypeList.action"];
        self.httpMethod = @"POST";
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null])
    {
        if ([self.type length] > 0) {
            NSDictionary *dict = @{@"applicationType":self.type
                                   };
            NSString *data = [dict JSONString];
            [newDic setObject:data forKey:@"data"];
        }
    }
    return newDic;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYGetPolicyListResponse *respose = [[HYGetPolicyListResponse alloc]
                                        initWithJsonDictionary:info];
    return respose;
}

@end
