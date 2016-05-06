//
//  HYMallHomePageRequest.m
//  Teshehui
//
//  Created by HYZB on 14-10-17.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYMallHomePageRequest.h"

@implementation HYMallHomePageRequest

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
        if (self.whetherChange) {
            [newDic setObject:@(_whetherChange) forKey:@"whetherChange"];
        }
        if (_tags) {
            [newDic setObject:_tags forKey:@"tags"];
        }
    }
    return newDic;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYMallHomePageResponse *respose = [[HYMallHomePageResponse alloc]initWithJsonDictionary:info];
    return respose;
}

@end
