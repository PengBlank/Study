//
//  HYOrderAddress.m
//  Teshehui
//
//  Created by HYZB on 15/5/23.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYOrderAddress.h"

@implementation HYOrderAddress

-(id)initWithJson:(NSDictionary *)json;
{
    self = [super init];
    if(self)
    {
        if(json != nil)
        {
            self.realName  = [json objectForKey:@"realName"];
            self.mobile  = [json objectForKey:@"mobile"];
            self.cityName  = [json objectForKey:@"cityName"];
            self.province  = [json objectForKey:@"province"];
            self.type  = [json objectForKey:@"type"];
            self.address  = [json objectForKey:@"address"];
            self.city  = [json objectForKey:@"city"];
            self.provinceName  = [json objectForKey:@"provinceName"];
            self.region  = [json objectForKey:@"region"];
            self.regionName  = [json objectForKey:@"regionName"];
            
        }
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.realName forKey:@"zx_realName"];
    [aCoder encodeObject:self.mobile forKey:@"zx_mobile"];
    [aCoder encodeObject:self.cityName forKey:@"zx_cityName"];
    [aCoder encodeObject:self.province forKey:@"zx_province"];
    [aCoder encodeObject:self.type forKey:@"zx_type"];
    [aCoder encodeObject:self.address forKey:@"zx_address"];
    [aCoder encodeObject:self.city forKey:@"zx_city"];
    [aCoder encodeObject:self.provinceName forKey:@"zx_provinceName"];
    [aCoder encodeObject:self.region forKey:@"zx_region"];
    [aCoder encodeObject:self.regionName forKey:@"zx_regionName"];
    
}


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if(self)
    {
        self.realName = [aDecoder decodeObjectForKey:@"zx_realName"];
        self.mobile = [aDecoder decodeObjectForKey:@"zx_mobile"];
        self.cityName = [aDecoder decodeObjectForKey:@"zx_cityName"];
        self.province = [aDecoder decodeObjectForKey:@"zx_province"];
        self.type = [aDecoder decodeObjectForKey:@"zx_type"];
        self.address = [aDecoder decodeObjectForKey:@"zx_address"];
        self.city = [aDecoder decodeObjectForKey:@"zx_city"];
        self.provinceName = [aDecoder decodeObjectForKey:@"zx_provinceName"];
        self.region = [aDecoder decodeObjectForKey:@"zx_region"];
        self.regionName = [aDecoder decodeObjectForKey:@"zx_regionName"];
        
    }
    return self;
}

- (NSString *) description
{
    NSString *result = @"";
    result = [result stringByAppendingFormat:@"realName : %@\n",self.realName];
    result = [result stringByAppendingFormat:@"mobile : %@\n",self.mobile];
    result = [result stringByAppendingFormat:@"cityName : %@\n",self.cityName];
    result = [result stringByAppendingFormat:@"province : %@\n",self.province];
    result = [result stringByAppendingFormat:@"type : %@\n",self.type];
    result = [result stringByAppendingFormat:@"address : %@\n",self.address];
    result = [result stringByAppendingFormat:@"city : %@\n",self.city];
    result = [result stringByAppendingFormat:@"provinceName : %@\n",self.provinceName];
    result = [result stringByAppendingFormat:@"region : %@\n",self.region];
    result = [result stringByAppendingFormat:@"regionName : %@\n",self.regionName];
    
    return result;
}

- (NSString *)addressDesc
{
    NSString *addressFull = nil;
    if (self.provinceName)
    {
        addressFull = self.provinceName;
    }
    
    if (self.cityName && ![self.provinceName isEqualToString:self.cityName])
    {
        addressFull = [NSString stringWithFormat:@"%@%@", addressFull, self.cityName];
    }
    
    if (self.regionName)
    {
        addressFull = [NSString stringWithFormat:@"%@%@", addressFull, self.regionName];
    }
    
    if (self.address)
    {
        addressFull = [NSString stringWithFormat:@"%@%@", addressFull, self.address];
    }
    
    if (self.realName)
    {
        addressFull = [NSString stringWithFormat:@"%@ %@", addressFull, self.realName];
    }
    
    if (self.mobile)
    {
        addressFull = [NSString stringWithFormat:@"%@ %@", addressFull, self.mobile];
    }
    return addressFull;
}

@end
