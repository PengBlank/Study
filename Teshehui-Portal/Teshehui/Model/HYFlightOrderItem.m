//
//  HYFightOrderItem.m
//  Teshehui
//
//  Created by 成才 向 on 15/5/29.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYFlightOrderItem.h"
#import "PTDateFormatrer.h"

@implementation HYFlightOrderItem

+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

- (NSString *)flightDate
{
    if (_flightDate)
    {
        NSDate *flightdate = [PTDateFormatrer dateFromString:_flightDate format:@"yyyy-MM-dd HH:mm:ss"];
        NSString *flightdatestr = [PTDateFormatrer stringFromDate:flightdate format:@"yyyy-MM-dd"];
        return flightdatestr;
    }
    return nil;
}

@end
