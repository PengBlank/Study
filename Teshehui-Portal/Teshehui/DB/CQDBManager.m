//
//  CQDBManager.m
//  Teshehui
//
//  Created by ChengQian on 13-11-21.
//  Copyright (c) 2013年 Charse. All rights reserved.
//

#import "CQDBManager.h"

static CQDBManager *shared = nil;

@implementation CQDBManager

+(CQDBManager *)sharedInstance {
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        shared = [[CQDBManager alloc] init];
    });
    return shared;
}

- (id)init
{
    if (shared) {
        // Return the old one
        return shared;
    }
    
    if (self = [super init])
	{
        [self createTables];
    }
    
    return self;
}

- (FMDatabaseQueue *)queue
{
    if (!_queue)
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
        NSString *path = [basePath stringByAppendingPathComponent:@"comeToMe.sqlite"];
        
        _queue = [FMDatabaseQueue databaseQueueWithPath:path];
    }
    
    return _queue;
}

/*
 @ 描述 :创建数据库表，
 */
- (void)createTables
{
    [self.queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        //create tbl_mobile  号码表
        /*
        if (![db executeUpdate:@"create table but_car_table (row_id integer primary key autoincrement, product_id text not null, product_name text, product_icon text, product_price text, product_vip_price text, product_score text, user_code text, total integer default 0);"])
        {
            DebugNSLog(@"faild to create table but_car_table");
        };
        
        if (![db executeUpdate:@"create table contacts_table (row_id integer primary key autoincrement, user_name text, user_number text);"])
        {
            DebugNSLog(@"faild to create table contacts_table");
        };
        
        if (![db executeUpdate:@"create table passenger_table (row_id integer primary key autoincrement, user_name text, id_type integer default 0, id_number text, mobile text, insurance text, sex integer, Birthday text);"])
        {
            DebugNSLog(@"faild to create table passenger_table");
        }*/
        
        //酒店城市表
        if (![db executeUpdate:@"create table city_hotel (row_id integer primary key autoincrement, city_id text, city_name text, city_e_name text, firstletter text, country_id text, province_id text);"])
        {
            DebugNSLog(@"faild to create table city_hotel");
        };
        //酒店城市商圈表
        if (![db executeUpdate:@"create table city_hotel_district (row_id integer primary key autoincrement, city_id text, city_name text, district_id text, district_name text, hot_level text);"])
        {
            DebugNSLog(@"faild to create table city_hotel_district");
        };
        
        //酒店城市行政区表
        if (![db executeUpdate:@"create table city_hotel_downtown (row_id integer primary key autoincrement, city_id text, city_name text, downtown_id text, downtown_name text, hot_level text);"])
        {
            DebugNSLog(@"faild to create table city_hotel_district");
        };
    }];
}

//清理数据
- (BOOL)cleanData
{
    //清除相关表
    [self.queue inTransaction:^(FMDatabase *db, BOOL *rollback)
     {
         //create tbl_snsinfo  社交账号信息表
         [db executeUpdate:@"delete from but_car_table"];
         [db executeQuery:@"select * from sqlite_sequence"];
         [db executeUpdate:@"update sqlite_sequence set seq=0 where name = but_car_table"];
     }];
    
    return YES;
}

@end
