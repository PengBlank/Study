//
//  HYBusinessTypeDao.h
//  Teshehui
//
//  Created by 成才 向 on 16/2/24.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYBaseDao.h"
#import "HYGetTranscationTypeResponse.h"

@interface HYBusinessTypeDao : HYBaseDao

- (void)saveEntities:(NSArray *)entities;
- (NSArray<HYBusinessType*> *)queryEntities;
- (NSArray<HYBusinessType*> *)queryEntitiesWhere:(NSString *)condition;

@end
