//
//  NSDate+Addition.h
//  Teshehui
//
//  Created by ChengQian on 13-11-17.
//  Copyright (c) 2013年 Charse. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Addition)

+ (NSDate*)dateFromString:(NSString*)string;
+ (NSString*)nowDataToString;

//毫秒时间
- (NSString*)toStringWithFormat:(NSString*)format;
- (NSString *)timeDescription;
- (NSString *)loaclDescription;
- (NSString *)timeDescriptionFull;
- (NSString *)timeIntervalSince1970String;

- (NSUInteger)getWeekday;
- (NSUInteger)getYears;
- (NSUInteger)getMonth;
- (NSUInteger)getDay;
- (NSUInteger)getIntervalOtherDate:(NSDate *)other;

- (NSString *)formatDateToAvatar;
- (NSString *)formatDateToViewShow;

+ (NSDate *)formateDateWithString:(NSString *)str;

- (BOOL)isSameDay:(NSDate*)date2;



@end
