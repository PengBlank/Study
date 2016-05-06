//
//  HYMallHomeBoard.m
//  Teshehui
//
//  Created by HYZB on 15/5/8.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYMallHomeBoard.h"
#import "PTDateFormatrer.h"

@implementation HYMallHomeBoard

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

- (HYHomeBoardType)boardType
{
    return (HYHomeBoardType)self.boardCode.integerValue;
}

- (NSDate *)lastUpdateDate
{
    if (_lastUpdateTime)
    {
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:_lastUpdateTime.longLongValue/1000];
        return date;
    }
    return nil;
}

@end
