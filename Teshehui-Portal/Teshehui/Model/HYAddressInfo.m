//
//  HYMallAdressListInfo.m
//  Teshehui
//
//  Created by ichina on 14-2-26.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYAddressInfo.h"

@implementation HYAddressInfo

- (id)initWithDataInfo:(NSDictionary *)data
{
    self = [super init];
    
    if (self)
    {
        self.addr_id = GETOBJECTFORKEY(data, @"addr_id", [NSString class]);
        self.consignee = GETOBJECTFORKEY(data, @"consignee", [NSString class]);
        self.regionId = GETOBJECTFORKEY(data, @"region_id", [NSString class]);
        self.regionName = GETOBJECTFORKEY(data, @"region_name", [NSString class]);
        self.address = GETOBJECTFORKEY(data, @"address", [NSString class]);
//        self.zipcode = GETOBJECTFORKEY(data, @"zipcode", [NSString class]);

        self.phoneMobile = GETOBJECTFORKEY(data, @"phone_mob", [NSString class]);
 
        if (!self.phoneMobile)
        {
            self.phoneMobile = GETOBJECTFORKEY(data, @"telephone", [NSString class]);
        }
        
        NSArray *array = [self.regionName componentsSeparatedByString:@"\t"];
        
        if ([array count] == 2)
        {
            self.provinceName = [array objectAtIndex:0];
            self.cityName = [array objectAtIndex:1];
        }
        else if ([array count] == 3)
        {
            self.provinceName = [array objectAtIndex:0];
            self.cityName = [array objectAtIndex:1];
            self.areaName = [array objectAtIndex:2];
        }
    }
    
    return self;
}

- (id)initWithOrderAddrInfo:(NSDictionary *)data
{
    self = [super init];
    
    if (self)
    {
        self.addr_id = GETOBJECTFORKEY(data, @"addr_id", [NSString class]);
        self.consignee = GETOBJECTFORKEY(data, @"realName", [NSString class]);
        self.regionId = GETOBJECTFORKEY(data, @"region", [NSString class]);
        self.regionName = GETOBJECTFORKEY(data, @"regionName", [NSString class]);
        self.address = GETOBJECTFORKEY(data, @"address", [NSString class]);
        self.phoneMobile = GETOBJECTFORKEY(data, @"mobile", [NSString class]);
        
        self.consignee = GETOBJECTFORKEY(data, @"realName", [NSString class]);
        
        NSArray *array = [self.regionName componentsSeparatedByString:@"\t"];
        
        if ([array count] == 2)
        {
            self.provinceName = [array objectAtIndex:0];
            self.cityName = [array lastObject];
        }
        else if ([array count] == 3)
        {
            self.provinceName = [array objectAtIndex:0];
            self.cityName = [array objectAtIndex:1];
            self.areaName = [array objectAtIndex:2];
        }
    }
    
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)err
{
    if (self = [super initWithDictionary:dict error:err])
    {
        if (self.areaName.length > 0)
        {
            self.regionId = self.areaId;
            self.regionName = self.areaName;
        }
    }
    return self;
}

//java 解析
+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc]
            initWithDictionary:@{@"addressId": @"addr_id"}];
}



+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

- (NSString *)fullRegion
{
    NSString *full = @"";
    if (self.provinceName.length > 0) {
        full = [full stringByAppendingString:self.provinceName];
    }
    if (self.cityName.length > 0) {
        full = [full stringByAppendingString:self.cityName];
    }
    if (self.areaName.length > 0)
    {
        full = [full stringByAppendingString:self.areaName];
    }else if (self.regionName.length > 0)
    {
        full = [full stringByAppendingString:self.regionName];
    }
    return full;
}

- (NSString *)fullAddress
{
    return [[self fullRegion] stringByAppendingString:self.address];
}

- (NSString *)addressDetail
{
    return [self fullRegion];
}

- (NSString *)displayForInvoice
{
    NSString *str = nil;
    if ([self.consignee length] > 0)
    {
        NSMutableString *mustr = [NSMutableString stringWithString:self.regionName];
        [mustr appendFormat:@" %@", self.address];
        [mustr appendFormat:@" %@", self.consignee];
        str = [NSString stringWithString:mustr];
    }
    return str;
}

- (NSString *)checkValid
{
    NSString *ret = nil;
    if (!self.consignee || self.consignee.length == 0)
    {
        ret = @"请完善收货人";
    }
    else if (!self.phoneMobile || self.phoneMobile.length == 0)
    {
        ret = @"请完善手机号码";
    }
    else if ((!self.provinceName || self.provinceName.length == 0)&&
             (!self.cityName || self.cityName.length == 0)&&
             (!self.regionName || self.regionName.length == 0))
    {
        ret = @"请完善配送区域";
    }
    else if (!self.address || self.address.length == 0)
    {
        ret = @"请完善详细地址";
    }
    
//    if ((!self.provinceName || self.provinceName.length == 0)&&
//        (!self.cityName || self.cityName.length == 0)&&
//        (!self.regionName || self.regionName.length == 0))
//    {
//        ret = @"请设置配送区域";
//    }
//    else if (!self.consignee || self.consignee.length == 0)
//    {
//        ret = @"请完善收货人";
//    }
//    else if (!self.address || self.address.length == 0)
//    {
//        ret = @"请完善收货地址";
//    }
//    else if (!self.phoneMobile || self.phoneMobile.length == 0)
//    {
//        ret = @"请输入正确的电话号码";
//    }
    return ret;
}

@end

