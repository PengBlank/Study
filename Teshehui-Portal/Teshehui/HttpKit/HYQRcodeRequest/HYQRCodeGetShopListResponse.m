//
//  HYQRCodeGetShopListResponse.m
//  Teshehui
//
//  Created by HYZB on 14-7-4.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYQRCodeGetShopListResponse.h"

@implementation HYQRCodeShop

- (id)initWithData:(NSDictionary *)data
{
    self = [super init];
    
    if (self)
    {
        _latitude = 0;
        _lontitude = 0;
        self.user_id = [GETOBJECTFORKEY(data, @"user_id", [NSString class]) integerValue];
        self.store_id = [GETOBJECTFORKEY(data, @"store_id", [NSString class]) integerValue];
        self.store_name = GETOBJECTFORKEY(data, @"store_name", [NSString class]);
        self.region_name = GETOBJECTFORKEY(data, @"region_name", [NSString class]);
        self.tel = GETOBJECTFORKEY(data, @"tel", [NSString class]);
        self.merchant_brief = GETOBJECTFORKEY(data, @"merchant_brief", [NSString class]);
        self.merchant_description = GETOBJECTFORKEY(data, @"merchant_description", [NSString class]);
        self.region_id = [GETOBJECTFORKEY(data, @"region_id", [NSString class]) integerValue];
        self.latitude = [GETOBJECTFORKEY(data, @"latitude", [NSString class]) floatValue];
        self.lontitude = [GETOBJECTFORKEY(data, @"longitude", [NSString class]) floatValue];
        self.distance = GETOBJECTFORKEY(data, @"distance", [NSString class]);
        self.address = GETOBJECTFORKEY(data, @"address", [NSString class]);
        
        self.img_url = GETOBJECTFORKEY(data, @"img_url", NSArray);
        
        self.business_hours_start = GETOBJECTFORKEY(data, @"business_hours_start", [NSString class]);
        self.business_hours_end = GETOBJECTFORKEY(data, @"business_hours_end", [NSString class]);
        self.merchant_cate_name = GETOBJECTFORKEY(data, @"merchant_cate_name", [NSString class]);
    }
    
    return self;
}

@end


@interface HYQRCodeGetShopListResponse ()

@property (nonatomic, strong) NSArray *shopList;

@end


@implementation HYQRCodeGetShopListResponse

- (id)initWithJsonDictionary:(NSDictionary *)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    
    if (self)
    {
        NSDictionary *dict = GETOBJECTFORKEY(dictionary, @"data", [NSDictionary class]);
        NSArray *array = GETOBJECTFORKEY(dict, @"items", [NSArray class]);
        if (array)
        {
            NSMutableArray *muArray = [[NSMutableArray alloc] init];
            for (NSDictionary *d in array)
            {
                HYQRCodeShop *city = [[HYQRCodeShop alloc] initWithData:d];
                [muArray addObject:city];
            }
            
            self.shopList = [muArray copy];
        }
    }
    
    return self;
}

@end
