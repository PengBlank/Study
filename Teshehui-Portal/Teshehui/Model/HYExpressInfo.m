//
//  HYExpressInfo.m
//  Teshehui
//
//  Created by HYZB on 14-9-22.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYExpressInfo.h"

@implementation HYExpressInfo

//- (id)initWithDataInfo:(NSDictionary *)data
//{
//    self = [super init];
//    
//    if (self)
//    {
//        self.expressId = GETOBJECTFORKEY(data, @"id", [NSString class]);
//        self.expressName = GETOBJECTFORKEY(data, @"template_name", [NSString class]);
//        NSString *support = GETOBJECTFORKEY(data, @"is_support", [NSString class]);
//        self.is_support = support.length > 0 ? [support boolValue] : YES;
//        NSString *isdefault = GETOBJECTFORKEY(data, @"is_default", [NSString class]);
//        self.is_default = isdefault.length > 0 ? [isdefault boolValue] : NO;
//        self.price = [GETOBJECTFORKEY(data, @"total_express_fee", [NSString class]) floatValue];
//    }
//    
//    return self;
//}

+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)err
{
    if (self = [super initWithDictionary:dict error:err])
    {
        NSString *name = [dict objectForKey:@"template_name"];
        if (name.length > 0)
        {
            self.expressName = name;
        }
        NSString *support = GETOBJECTFORKEY(dict, @"isAvailable", [NSString class]);
        self.is_support = support.length > 0 ? [support boolValue] : YES;
    }
    return self;
}

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id": @"expressId",
                                                      @"deliveryName": @"expressName",
                                                      @"isMajor": @"is_default",
                                                      @"isAvailable": @"is_support",
                                                      @"deliveryFee": @"price"}];
}

@end
