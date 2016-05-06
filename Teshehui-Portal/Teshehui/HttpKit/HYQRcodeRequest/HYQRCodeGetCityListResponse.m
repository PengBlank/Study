//
//  HYQRCodeGetCityListResponse.m
//  Teshehui
//
//  Created by HYZB on 14-7-4.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYQRCodeGetCityListResponse.h"


@implementation HYCityForQRCode

@synthesize region_use = _region_use;

- (id)initWithData:(NSDictionary *)data
{
    self = [super init];
    if (self)
    {
        self.region_id = [GETOBJECTFORKEY(data, @"region_id", [NSString class]) integerValue];
        self.region_name = GETOBJECTFORKEY(data, @"region_name", [NSString class]);
    }
    
    return self;
}

- (NSString *)region_use
{
    if (!_region_use)
    {
        if (_region_name.length > 0)
        {
            if ([_region_name hasSuffix:@"市"])
            {
                NSMutableString *ret = [NSMutableString stringWithString:_region_name];
                [ret deleteCharactersInRange:NSMakeRange(ret.length-1, 1)];
                _region_use = [NSString stringWithString:ret];
            }
            else {
                _region_use = _region_name;
            }
        } else {
            _region_use = @"";
        }
    }
    
    return _region_use;
}

@end


@interface HYQRCodeGetCityListResponse ()

@property (nonatomic, strong) NSArray *cityList;

@end


@implementation HYQRCodeGetCityListResponse

- (id)initWithJsonDictionary:(NSDictionary *)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    
    if (self)
    {
        NSDictionary *dict = GETOBJECTFORKEY(dictionary, @"data", [NSDictionary class]);
        if ([dict.allKeys containsObject:@"items"])
        {
            NSArray *array = [dict objectForKey:@"items"];
            NSMutableArray *muArray = [[NSMutableArray alloc] init];
            for (NSDictionary *d in array)
            {
                HYCityForQRCode *city = [[HYCityForQRCode alloc] initWithData:d];
                [muArray addObject:city];
            }
            
            self.cityList = [muArray copy];
        }
    }
    
    return self;
}

@end
