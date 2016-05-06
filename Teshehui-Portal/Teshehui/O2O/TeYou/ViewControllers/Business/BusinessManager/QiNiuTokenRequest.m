//
//  QiNiuTokenRequest.m
//  Teshehui
//
//  Created by apple_administrator on 15/9/15.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "QiNiuTokenRequest.h"

@implementation QiNiuTokenRequest
- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    [newDic removeAllObjects];
    
    return newDic;
}
@end
