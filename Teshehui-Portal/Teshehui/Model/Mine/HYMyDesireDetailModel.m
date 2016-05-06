//
//  HYMyDesireDetailModel.m
//  Teshehui
//
//  Created by HYZB on 15/11/23.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYMyDesireDetailModel.h"

@implementation HYMyDesireDetailModel

+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc]
            initWithDictionary:@{@"id": @"desire_id"}];
}

- (NSMutableArray *)wishPicList
{
    if (!_wishPicList) {
        _wishPicList = [NSMutableArray array];
    }
    return _wishPicList;
}

- (NSMutableArray *)wishDetailPOList
{
    if (!_wishDetailPOList) {
        _wishDetailPOList = [NSMutableArray array];
    }
    return _wishDetailPOList;
}

@end
