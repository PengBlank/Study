//
//  HYLoginInfoCache.h
//  HYManagmentDept
//
//  Created by RayXiang on 14-5-21.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HYLoginInfoCache : NSObject<NSCoding>

@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *passWord;

+ (instancetype)loginInfoWithName:(NSString *)name passWord:(NSString *)pass shouldCache:(BOOL)aBool;

+ (instancetype)cachedLoginInfo;

+ (void)deleteCachedLoginInfo;

@end
