//
//  NSData+Addition.h
//  ContactHub
//
//  Created by ChengQian on 13-3-20.
//  Copyright (c) 2013年 www.putao.cn. All rights reserved.
//

/**
 * NSData对象的扩展方法
 */

#import <Foundation/Foundation.h>

@interface NSData (Addition)

- (NSString *)MD5EncodedString;
- (NSData *)HMACSHA1EncodedDataWithKey:(NSString *)key;
- (NSString *)base64EncodedString;

@end
