//
//  HYMallCateDao.h
//  Teshehui
//
//  Created by 成才 向 on 16/3/22.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYBaseDao.h"
#import "HYMallCategoryInfo.h"

@interface HYMallCateDao : HYBaseDao

//- (void)saveEntities:(NSArray *)entities;
- (void)saveEntity:(HYMallCategoryInfo *)cate;
//- (NSArray<HYMallCategoryInfo*> *)queryEntities;
- (HYMallCategoryInfo *)queryEntity;

@end
