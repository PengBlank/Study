//
//  PTDateFormatrer.h
//  ContactHub
//
//  Created by ChengQian on 13-4-17.
//  Copyright (c) 2013年 www.putao.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PTDateFormatrer : NSObject

/**
 *	@brief 静态方法返回一个全局时间格式化对象
 *
 *	@return	NSDateFormatter 对象
 */
+ (NSDateFormatter *)dateformatter;

/**
 *	@brief	将时间按照指定格式转换为字符串
 *
 *	@param 	date 	将要转换的日期
 *	@param 	format 	需要输出的日期格式
 *
 *	@return	指定格式的字符串
 */
+ (NSString *)stringFromDate:(NSDate*)date format:(NSString*)format;

/**
 *	@brief	将时间字符串按照指定格式转换为日期对象
 *
 *	@param 	string 	将要转换的字符串
 *	@param 	format 	字符串对应的时间格式
 *
 *	@return	日期对象
 */
+ (NSDate*)dateFromString:(NSString *)string format:(NSString*)format;

+ (NSString *)treatDateStringFromDate:(NSString *)string format:(NSString *)format;


/**
 *	@brief	星期数
 *
 *	@param 	n 	<#n description#>
 *
 *	@return	<#return value description#>
 */
+ (NSString*)weekChinese:(int)n;

+ (NSString*)timeMsStringSince1970;
+ (NSNumber *)timeMsSince1970;

@end
