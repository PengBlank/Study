//
//  HYPhoneChargeStore.m
//  Teshehui
//
//  Created by 成才 向 on 16/2/29.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYPhoneChargeStore.h"
#import "HYUserInfo.h"

#define kSearchHistoryKey @"kPhoneStore"

@implementation HYPhoneChargeStore

+ (instancetype)sharedStore
{
    static HYPhoneChargeStore *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[HYPhoneChargeStore alloc] init];
    });
    
    return _sharedInstance;
}

- (NSArray *)addRecord:(NSDictionary *)record
{
    NSString *key = [NSString stringWithFormat:@"%@%@", kSearchHistoryKey, [HYUserInfo getUserInfo].userId];
    NSArray *records = [[NSUserDefaults standardUserDefaults] arrayForKey:key];
    if (!records)
    {
        records = [NSMutableArray array];
    }
    if (records && [records isKindOfClass:[NSArray class]])
    {
        NSMutableArray *recordsarr = [NSMutableArray arrayWithArray:records];
        for (NSDictionary *exist in records)
        {
            if ([exist[@"phone"] isEqualToString:record[@"phone"]])
            {
                [recordsarr removeObject:record];
            }
        }
        if (record) {
            [recordsarr insertObject:record atIndex:0];
        }
        if (recordsarr.count > 5) {
            [recordsarr removeLastObject];
        }
        [[NSUserDefaults standardUserDefaults] setObject:recordsarr forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return recordsarr;
    }
    return nil;
}

- (void)clearRecords
{
    NSString *key = [NSString stringWithFormat:@"%@%@", kSearchHistoryKey, [HYUserInfo getUserInfo].userId];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:key];
}

- (NSArray *)getRecords
{
    return [self addRecord:nil];
}

@end
