//
//  HYPhoneChargeStore.h
//  Teshehui
//
//  Created by 成才 向 on 16/2/29.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HYPhoneChargeStore : NSObject

+ (instancetype)sharedStore;

- (NSArray *)addRecord:(NSDictionary *)record;
- (void)clearRecords;
- (NSArray *)getRecords;

@end
