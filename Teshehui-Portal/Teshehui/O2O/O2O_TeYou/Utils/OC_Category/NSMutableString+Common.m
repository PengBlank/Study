//
//  NSMutableString+Common.m
//  Coding_iOS
//
//  Created by ??? on 15/5/26.
//  Copyright (c) 2015年 ???. All rights reserved.
//

#import "NSMutableString+Common.h"

@implementation NSMutableString (Common)
- (void)saveAppendString:(NSString *)aString{
    if (aString.length > 0) {
        [self appendString:aString];
    }
}
@end
