//
//  HYModifyPassengerRequest.m
//  Teshehui
//
//  Created by 回亿资本 on 14-2-27.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYModifyPassengerRequest.h"

@implementation HYModifyPassengerRequest

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kJavaRequestBaseURL, @"user/updateContactDetail.action"];
        self.httpMethod = @"POST";
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null] &&
        [self.passengerId length] > 0)
    {
        [newDic setObject:self.passengerId forKey:@"contactId"];
    }
#ifndef __OPTIMIZE__
    else
    {
        DebugNSLog(@"编辑常用旅客缺少必须参数");
    }
#endif
    return newDic;
}
@end
