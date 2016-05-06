//
//  PTSimilarUtils.h
//  Boyer-Moore
//
//  Created by ChengQian on 13-6-6.
//  Copyright (c) 2013年 Charse. All rights reserved.
//

/**
 *模糊匹配字符串,规则
 英文最小拆词长度：4
 中文最小拆词长度：3
 如果中英文混排，去掉英文只算中文
 */

#import <Foundation/Foundation.h>


@interface PTSimilarUtils : NSObject

- (float)sim:(NSString *)str1 str2:(NSString *)str2;
- (NSArray *)cutStringWithStep:(NSString *)sourceStr stepSize:(int)stepSize;

@end
