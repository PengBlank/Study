//
//  NSURL+Common.h
//  Coding_iOS
//
//  Created by ??? on 15/2/3.
//  Copyright (c) 2015年 ???. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (Common)
+(BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL;
- (NSDictionary *)queryParams;
@end
