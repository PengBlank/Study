//
//  HYMslselectionInfo.m
//  Teshehui
//
//  Created by ichina on 14-3-8.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYMslselectionInfo.h"

@implementation HYMslselectionInfo

//- (id)initWithDataInfo:(NSDictionary *)data
//{
//    self = [super init];
//    
//    if (self)
//    {
//        self.region_id = GETOBJECTFORKEY(data, @"region_id", [NSString class]);
//        self.parent_id = GETOBJECTFORKEY(data, @"parent_id", [NSString class]);
//        self.region_name = GETOBJECTFORKEY(data, @"region_name", [NSString class]);
//    }
//    
//    return self;
//}

+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"regionId":@"region_id",
                                                      @"regionName": @"region_name",
                                                      @"parentId": @"parent_id",
                                                      @"id": @"area_id"}];
}

@end
