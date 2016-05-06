//
//  HYMovieGetURLRequest.m
//  Teshehui
//
//  Created by 成才 向 on 16/3/7.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYMovieGetURLRequest.h"

@implementation HYMovieGetURLRequest

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kJavaRequestBaseURL, @"maizuo/getVisitUrl.action"];
        self.httpMethod = @"POST";
        self.businessType = @"50";
        self.version = @"1.0.0";
    }
    
    return self;
}

- (NSMutableDictionary *)getDataDictionary
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    if (self.userId)
    {
        dict[@"account"] = self.userId;
        dict[@"userId"] = self.userId;
    }
    return dict;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    return [[HYMovieGetURLResponse alloc] initWithJsonDictionary:info];
}

@end
