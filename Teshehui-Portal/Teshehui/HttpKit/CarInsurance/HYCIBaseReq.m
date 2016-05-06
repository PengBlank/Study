//
//  HYCIBaseReq.m
//  Teshehui
//
//  Created by HYZB on 15/7/2.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYCIBaseReq.h"

@implementation HYCIBaseReq

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null])
    {
        NSString *jsondata = [self.reqParam toJSONString];
        
        if ([jsondata length] > 0) {
            [newDic setObject:jsondata forKey:@"data"];
        }
    }
    return newDic;
}

@end
