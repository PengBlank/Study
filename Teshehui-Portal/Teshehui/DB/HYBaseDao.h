//
//  HYBaseDao.h
//  Teshehui
//
//  Created by 成才 向 on 16/2/24.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"

/**
 *  @brief 数据层简单版实现，所有sql均需自己手写
 *  支持自动表结构升级, 数据迁移
 */

@interface HYBaseDao : NSObject

@property (nonatomic, strong, readonly) FMDatabaseQueue *sharedQueue;

@property (nonatomic, weak, readonly) Class entityClass;
@property (nonatomic, assign) NSInteger tableVersion;
@property (nonatomic, strong) NSString *tableName;

- (instancetype)initWithEntityClass:(Class)aClass;

- (void)createTable;
- (void)updateTable;


@end
