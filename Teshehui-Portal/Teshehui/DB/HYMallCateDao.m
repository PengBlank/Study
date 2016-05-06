//
//  HYMallCateDao.m
//  Teshehui
//
//  Created by 成才 向 on 16/3/22.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYMallCateDao.h"

@implementation HYMallCateDao

- (instancetype)init
{
    self.tableName = @"t_HYMallCategory";
    self.tableVersion = 3;
    self = [super initWithEntityClass:[HYMallCategoryInfo class]];
    
    return self;
}

- (void)createTable
{
    [self.sharedQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        [db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_HYMallCategory(cate_id TEXT, cate_name TEXT, parent_id TEXT, thumbnail_tetragonal TEXT)"];
    }];
}

- (void)insertCate:(HYMallCategoryInfo *)cate
{
    [self.sharedQueue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"INSERT INTO t_HYMallCategory(cate_id, cate_name, parent_id, thumbnail_tetragonal) VALUES(?, ?, ?, ?)", cate.cate_id, cate.cate_name, cate.parent_id, cate.thumbnail_tetragonal];
    }];
    if (cate.subcategories)
    {
        for (HYMallCategoryInfo *subcate in cate.subcategories) {
            [self insertCate:subcate];
        }
    }
}

- (void)saveEntity:(HYMallCategoryInfo *)cate
{
    [self.sharedQueue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"DELETE FROM t_HYMallCategory WHERE 1 = 1"];
    }];
    [self insertCate:cate];
}

- (HYMallCategoryInfo *)queryEntity
{
    HYMallCategoryInfo *root = [[HYMallCategoryInfo alloc] init];
    NSMutableArray *children = [NSMutableArray array];
    [self.sharedQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:@"SELECT * FROM t_HYMallCategory WHERE parent_id IS NULL and cate_id is not NULL"];
        while ([rs next]) {
            [children addObject:[self cateWithResultSet:rs]];
        }
    }];
    for (HYMallCategoryInfo *subcate in children) {
        subcate.subcategories = (id)[self getChildrenWithCate:subcate];
    }
    root.subcategories = (id)children;
    return root;
}

- (HYMallCategoryInfo *)cateWithResultSet:(FMResultSet *)rs
{
    HYMallCategoryInfo *child = [[HYMallCategoryInfo alloc] init];
    child.cate_id = [rs stringForColumn:@"cate_id"];
    child.cate_name = [rs stringForColumn:@"cate_name"];
    child.thumbnail_tetragonal = [rs stringForColumn:@"thumbnail_tetragonal"];
    return child;
}

- (NSArray *)getChildrenWithCate:(HYMallCategoryInfo *)cate
{
    NSMutableArray *sub = [NSMutableArray array];
    [self.sharedQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:@"SELECT * FROM t_HYMallCategory WHERE parent_id = ?", cate.parent_id];
        while ([rs next]) {
            [sub addObject:[self cateWithResultSet:rs]];
        }
    }];
    for (HYMallCategoryInfo *child in sub) {
        child.subcategories = (id)[self getChildrenWithCate:child];
    }
    return sub;
}

@end
