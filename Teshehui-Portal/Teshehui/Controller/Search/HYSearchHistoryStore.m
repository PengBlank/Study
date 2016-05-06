//
//  HYSearchHistoryStore.m
//  Teshehui
//
//  Created by apple on 15/1/26.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYSearchHistoryStore.h"

#define kSearchHistoryKey @"kSearchHistory"

@implementation HYSearchHistoryStore

+ (instancetype)sharedStore
{
    static HYSearchHistoryStore *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[HYSearchHistoryStore alloc] init];
    });
    
    return _sharedInstance;
}

- (NSArray *)addSearchRecord:(NSString *)record
{
    NSArray *records = [[NSUserDefaults standardUserDefaults] arrayForKey:kSearchHistoryKey];
    if (!records)
    {
        records = [NSMutableArray array];
    }
    if (records && [records isKindOfClass:[NSArray class]])
    {
        NSMutableArray *recordsarr = [NSMutableArray arrayWithArray:records];
        if ([recordsarr containsObject:record])
        {
            [recordsarr removeObject:record];
        }
        if (record) {
            [recordsarr insertObject:record atIndex:0];
        }
        if (recordsarr.count > 10) {
            [recordsarr removeLastObject];
        }
        [[NSUserDefaults standardUserDefaults] setObject:recordsarr forKey:kSearchHistoryKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return recordsarr;
    }
    return nil;
}

- (void)clearSearchRecords
{
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:kSearchHistoryKey];
}

- (NSArray *)getHistoryRecords
{
    return [self addSearchRecord:nil];
}

@end
