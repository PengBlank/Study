//
//  HYFlightLIstSummary.m
//  Teshehui
//
//  Created by HYZB on 15/5/25.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYFlightListSummary.h"
#import "PTDateFormatrer.h"
#import "NSDate+Addition.h"

@interface HYFlightListSummary ()

@property (nonatomic, assign) NSTimeInterval startTimestamp;

@end

@implementation HYFlightListSummary

#pragma mark setter/getter
- (NSTimeInterval)startTimestamp
{
    if (_startTimestamp<=0 && self.startDatetime.length>0)
    {
        NSDate *date = [PTDateFormatrer dateFromString:self.startDatetime
                                                format:@"yyyy-MM-dd HH:mm:ss"];
        _startTimestamp = [date timeIntervalSinceNow];
    }
    
    return _startTimestamp;
}

@end
