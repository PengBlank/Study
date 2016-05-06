//
//  HYSearchHistoryStore.h
//  Teshehui
//
//  Created by apple on 15/1/26.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HYSearchHistoryStore : NSObject

+ (instancetype)sharedStore;

- (NSArray *)addSearchRecord:(NSString *)record;
- (void)clearSearchRecords;
- (NSArray *)getHistoryRecords;

@end
