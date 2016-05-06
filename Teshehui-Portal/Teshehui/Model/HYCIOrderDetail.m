//
//  HYCIOrderDetail.m
//  Teshehui
//
//  Created by HYZB on 15/7/11.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYCIOrderDetail.h"

//@implementation HYCICarInfo
//
//+ (BOOL)propertyIsOptional:(NSString *)propertyName {
//    return YES;
//}
//
//@end

@implementation HYCIInsuranceOrderInfo

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

@end

@implementation HYCIOrderDetail

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)err
{
    NSDictionary *expand = [dict objectForKey:@"expandedResponse"];
    NSMutableDictionary *expanddict = [NSMutableDictionary dictionaryWithDictionary:dict];
    [expanddict addEntriesFromDictionary:expand];
    
    return [super initWithDictionary:expanddict error:err];
}

@end
