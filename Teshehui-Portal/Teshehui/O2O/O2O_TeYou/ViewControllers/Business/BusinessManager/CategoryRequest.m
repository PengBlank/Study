//
//  CategoryRequest.m
//  Teshehui
//
//  Created by apple_administrator on 15/8/26.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "CategoryRequest.h"
#import "categoryInfo.h"
@implementation CategoryRequest

- (id)init
{
    self = [super init];
    
    if (self)
    {

    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    [newDic removeAllObjects];

    return newDic;
}


//- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
//{
//    CategoryResponce *respose = [[CategoryResponce alloc]initWithJsonDictionary:info];
//    return respose;
//}

@end
