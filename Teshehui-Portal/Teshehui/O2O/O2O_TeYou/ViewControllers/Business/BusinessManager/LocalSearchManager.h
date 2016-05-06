//
//  LocalSearchManager.h
//  Teshehui
//
//  Created by apple_administrator on 16/4/8.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocalSearchManager : NSObject
+ (instancetype)sharedManager;

- (NSMutableArray *)getSearchHistory;
- (void)saveSearchKey:(NSString *)key;
- (void)clearSearchOneKey:(NSString *)key;
- (void)clearSearchKey;
@end
