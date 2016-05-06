//
//  HYBaseDao.m
//  Teshehui
//
//  Created by 成才 向 on 16/2/24.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYBaseDao.h"
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
#import "FMDatabaseAdditions.h"
#import <objc/runtime.h>

static FMDatabaseQueue *__sharedQueue;

@implementation HYBaseDao

- (FMDatabaseQueue *)sharedQueue
{
    if (!__sharedQueue)
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
            NSString *path = [basePath stringByAppendingPathComponent:@"data.sqlite"];
            __sharedQueue = [[FMDatabaseQueue alloc] initWithPath:path];
        });
    }
    return __sharedQueue;
}

+ (instancetype)daoWithEntityClass:(Class)aClass
{
    HYBaseDao *dao = [[[self class] alloc] initWithEntityClass:aClass];
    return dao;
}

- (instancetype)initWithEntityClass:(Class)aClass
{
    self = [super init];
    if (self)
    {
        _entityClass = aClass;
        
        /// 查看表是否存在
        __block NSInteger hasTable = 0;
        [self.sharedQueue inDatabase:^(FMDatabase *db) {
            hasTable = [db intForQuery:@"SELECT COUNT(*) FROM sqlite_master where type='table' and name=?", self.tableName];
        }];
        
        /// 如果不存在，创建表
        if (hasTable == 0)
        {
            [self createTable];
            [self.sharedQueue inDatabase:^(FMDatabase *db) {
                [db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_table_version(tableName TEXT, tableVersion INT);"];
                [db executeUpdate:@"INSERT INTO t_table_version(tableName, tableVersion) VALUES(?, ?)",self.tableName, @(self.tableVersion)];
            }];
        }
        
        /// 如果存在，检查表版本号
        else
        {
            __block NSInteger version = 0;
            [self.sharedQueue inDatabase:^(FMDatabase *db) {
                version = [db intForQuery:@"SELECT tableVersion FROM t_table_version WHERE tableName = ?", self.tableName];
            }];
            
            if (version < self.tableVersion) {
                [self updateTable];
            }
        }
    }
    return self;
}

- (void)createTable
{
    
}

- (void)updateTable
{
    NSString *tmpName = [NSString stringWithFormat:@"%@_tmp", self.tableName];
    NSString *sql = [NSString stringWithFormat:@"ALTER TABLE %@ RENAME TO %@", self.tableName, tmpName];
    
    [self.sharedQueue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:sql];
    }];
    [self createTable];
    sql = [NSString stringWithFormat:@"INSERT INTO %@ SELECT * FROM %@", self.tableName, tmpName];
    [self.sharedQueue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:sql];
    }];
    sql = [NSString stringWithFormat:@"DROP TABLE %@", tmpName];
    [self.sharedQueue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:sql];
    }];
    [self.sharedQueue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"UPDATE t_table_version SET tableVersion = ? WHERE tableName = ?", @(self.tableVersion), self.tableName];
    }];
}

@end
