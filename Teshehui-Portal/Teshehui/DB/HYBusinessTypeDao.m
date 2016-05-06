//
//  HYBusinessTypeDao.m
//  Teshehui
//
//  Created by 成才 向 on 16/2/24.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYBusinessTypeDao.h"

@implementation HYBusinessTypeDao


- (instancetype)init
{
    self.tableName = @"t_HYBusinessType";
    self.tableVersion = 3;
    self = [super initWithEntityClass:[HYBusinessType class]];
    
    return self;
}

- (void)createTable
{
    [self.sharedQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        [db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_HYBusinessType (businessTypeCode TEXT, businessTypeName TEXT, isBusinessTypeOpen TEXT, businessTypeStatusMsg TEXT)"];
    }];
}

- (void)saveEntities:(NSArray *)entities
{
    [self.sharedQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        [db executeUpdate:@"DELETE FROM t_HYBusinessType WHERE 1 = 1"];
        for (HYBusinessType *type in entities)
        {
            [db executeUpdate:@"INSERT INTO t_HYBusinessType(businessTypeCode, businessTypeName, isBusinessTypeOpen, businessTypeStatusMsg) VALUES(?, ?, ?, ?)",
             type.businessTypeCode,
             type.businessTypeName,
             type.isBusinessTypeOpen,
             type.businessTypeStatusMsg];
        }
    }];
}

- (NSArray<HYBusinessType *> *)queryEntities
{
    NSMutableArray *types = [[NSMutableArray alloc] init];
    [self.sharedQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        FMResultSet *rs = [db executeQuery:@"SELECT * FROM t_HYBusinessType"];
        while ([rs next]) {
            HYBusinessType *type = [[HYBusinessType alloc] init];
            type.businessTypeCode = [rs stringForColumn:@"businessTypeCode"];
            type.businessTypeName = [rs stringForColumn:@"businessTypeName"];
            type.businessTypeStatusMsg = [rs stringForColumn:@"businessTypeStatusMsg"];
            type.isBusinessTypeOpen = [rs stringForColumn:@"isBusinessTypeOpen"];
            [types addObject:type];
        }
    }];
    return types;
}

- (NSArray<HYBusinessType *> *)queryEntitiesWhere:(NSString *)condition
{
    NSMutableArray *types = [[NSMutableArray alloc] init];
    [self.sharedQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM t_HYBusinessType WHERE %@", condition];
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            HYBusinessType *type = [[HYBusinessType alloc] init];
            type.businessTypeCode = [rs stringForColumn:@"businessTypeCode"];
            type.businessTypeName = [rs stringForColumn:@"businessTypeName"];
            type.businessTypeStatusMsg = [rs stringForColumn:@"businessTypeStatusMsg"];
            type.isBusinessTypeOpen = [rs stringForColumn:@"isBusinessTypeOpen"];
            [types addObject:type];
        }
    }];
    return types;
}

@end
