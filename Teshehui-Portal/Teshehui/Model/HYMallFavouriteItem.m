//
//  HYMallFavouriteItem.m
//  Teshehui
//
//  Created by 成才 向 on 15/5/11.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYMallFavouriteItem.h"

@implementation HYMallFavouriteItem

+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"expandedResponse.storeId": @"storeId",
                                                       @"expandedResponse.storeName": @"storeName"}];
}

@end
