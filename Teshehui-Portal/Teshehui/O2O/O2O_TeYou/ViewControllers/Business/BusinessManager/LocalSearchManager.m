//
//  LocalSearchManager.m
//  Teshehui
//
//  Created by apple_administrator on 16/4/8.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#define BusinessSearchKey @"BusinessSearchKey"

#import "LocalSearchManager.h"

@implementation LocalSearchManager
+ (instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    static LocalSearchManager *__sharedManager = nil;
    dispatch_once(&onceToken, ^{
        __sharedManager = [[LocalSearchManager alloc] init];
    });
    return __sharedManager;
}

- (NSMutableArray *)getSearchHistory{

    NSMutableArray *historys = [[NSUserDefaults standardUserDefaults] arrayForKey:BusinessSearchKey].mutableCopy;
    return historys;
}

- (void)saveSearchKey:(NSString *)key{
  
    NSMutableArray *currentHistorys = [[NSUserDefaults standardUserDefaults] arrayForKey:BusinessSearchKey].mutableCopy;
    if (!currentHistorys)
    {
        currentHistorys = [NSMutableArray array];
    }
    
    if (currentHistorys && [currentHistorys isKindOfClass:[NSArray class]])
    {

        if ([currentHistorys containsObject:key]) {
            [currentHistorys removeObject:key];
        }
        
        [currentHistorys insertObject:key atIndex:0];
        
        if (currentHistorys.count > 10) {
            [currentHistorys removeLastObject];
        }

        [[NSUserDefaults standardUserDefaults] setObject:currentHistorys forKey:BusinessSearchKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
  
    }
}

- (void)clearSearchOneKey:(NSString *)key{
    
    NSMutableArray *currentHistorys = [[NSUserDefaults standardUserDefaults] arrayForKey:BusinessSearchKey].mutableCopy;
    if (!currentHistorys)
    {
        currentHistorys = [NSMutableArray array];
    }
    
    if (currentHistorys && [currentHistorys isKindOfClass:[NSArray class]])
    {
        
        if ([currentHistorys containsObject:key]) {
            [currentHistorys removeObject:key];
        }
        [[NSUserDefaults standardUserDefaults] setObject:currentHistorys forKey:BusinessSearchKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
}

- (void)clearSearchKey{

    [[NSUserDefaults standardUserDefaults] removeObjectForKey:BusinessSearchKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}





@end
