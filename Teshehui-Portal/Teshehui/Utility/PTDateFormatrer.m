//
//  PTDateFormatrer.m
//  ContactHub
//
//  Created by ChengQian on 13-4-17.
//  Copyright (c) 2013年 www.putao.cn. All rights reserved.
//

#import "PTDateFormatrer.h"

@implementation PTDateFormatrer

static NSDateFormatter *df;

+ (NSDateFormatter *)dateformatter
{
    if (!df) {
        df = [[NSDateFormatter alloc] init];
    }
    [df setTimeZone:[NSTimeZone systemTimeZone]];
    return df;
}

+ (NSString*)stringFromDate:(NSDate*)date format:(NSString*)format
{
    NSDateFormatter *f = [[self class] dateformatter];
	[f setDateFormat:format];
	return [f stringFromDate:date];
}

+ (NSDate*)dateFromString:(NSString*)string format:(NSString*)format
{
    if (!string)
    {
        return nil;
    }
    
    NSDateFormatter *f = [[self class] dateformatter];
	[f setDateFormat:format];
	return [f dateFromString:string];
}

+ (NSString *)treatDateStringFromDate:(NSString *)string
                               format:(NSString *)format
{
    NSDate *timedate = [[self class] dateFromString:string
                                             format:format];
    
    double time =  [timedate timeIntervalSince1970];
    
    double now  = [[NSDate date]timeIntervalSince1970];
    
    NSString *timestr = nil;
    //一天之内
    if(now - time <= 24 * 60 * 60)
    {
        timestr = @"今天";
    }
    //两天之内
    else if(now - time <= 24 * 60 * 60 * 2)
    {
        timestr = @"昨天";
    }
    //一年之内
    else if(now - time <= 24 * 60 * 60 * 365)
    {
        timestr = [[self class] stringFromDate:timedate
                                        format:@"M.dd"];
    }
    else
    {
        timestr = [[self class] stringFromDate:timedate
                                        format:@"M.dd/yyyy"];//string;
    }
    return timestr;
}

+ (NSString*)weekChinese:(int)weekday
{
    //系统NSDateComponents 的weekday是是1~7 1是星期日
	switch (weekday) {
		case 1:
			return NSLocalizedString(@"周日", nil);
		case 2:
            return NSLocalizedString(@"周一", nil);
		case 3:
            return NSLocalizedString(@"周二", nil);
		case 4:
            return NSLocalizedString(@"周三", nil);
		case 5:
            return NSLocalizedString(@"周四", nil);
		case 6:
            return NSLocalizedString(@"周五", nil);
        case 7:
			return NSLocalizedString(@"周六", nil);
	}
	return NSLocalizedString(@"未知", nil);
}

+ (NSString*)timeMsStringSince1970
{
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970] * 1000;
    long long dTime = [[NSNumber numberWithDouble:time] longLongValue];
    NSString *curTime = [NSString stringWithFormat:@"%llu",dTime];
    return curTime;
}

+ (NSNumber *)timeMsSince1970
{
    long long time = [[NSDate date] timeIntervalSince1970] * 1000;
    NSNumber *llTime = [NSNumber numberWithLongLong:time];
    return llTime;
}

@end
