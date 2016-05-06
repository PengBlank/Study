//
//  HYGetTranscationTypeRequest.m
//  Teshehui
//
//  Created by Kris on 15/7/21.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYGetTranscationTypeRequest.h"

@implementation HYGetTranscationTypeRequest
- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@:80/index/getBusinessType.action", kJavaRequestBaseURL];
        self.postType = JSON;
        self.httpMethod = @"POST";
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null])
    {
        
        if (self.clientVersion)
        {
            NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:self.clientVersion, @"clientVersion", nil];
            
            [newDic setObject:dic
                       forKey:@"data"];
        }
    }
    return newDic;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYGetTranscationTypeResponse *respose = [[HYGetTranscationTypeResponse alloc]initWithJsonDictionary:info];
    return respose;
}
@end
