//
//  HYHotelLocalDistrict.m
//  Teshehui
//
//  Created by 回亿资本 on 14-2-12.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYHotelDistrictInfo.h"
#import "HYHotelCityDistrictRequest.h"

@implementation HYHotelDistrictInfo

- (id)initWithDataInfo:(NSDictionary *)data
{
    self = [super init];
    
    if (self)
    {
        self.cityId = GETOBJECTFORKEY(data, @"city_id", [NSString class]);
        self.name = GETOBJECTFORKEY(data, @"name", [NSString class]);
        self.enName = GETOBJECTFORKEY(data, @"english_name", [NSString class]);
        self.districtId = GETOBJECTFORKEY(data, @"id", [NSString class]);
    }
    
    return self;
}

+ (NSArray *)getAllCityDistrictInfo
{
    NSFileManager* manager = [NSFileManager defaultManager];  //设置文件管理器
    NSString* string = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString* fileName = [string  stringByAppendingPathComponent:@"hotelCDistrictList.plist"];
    
    if ([manager fileExistsAtPath:fileName])
    {
        NSDictionary* dic = [[NSDictionary alloc] initWithContentsOfFile:fileName];
        
        NSMutableArray *muArray = [[NSMutableArray alloc] init];
        NSDictionary *cityInfo = [dic objectForKey:@"result"];
        
        for (NSDictionary *d in cityInfo)
        {
            HYHotelDistrictInfo *c = [[HYHotelDistrictInfo alloc] initWithDataInfo:d];
            [muArray addObject:c];
        }
        
        return muArray;
    }
    
    return nil;
}

+ (NSArray *)getCityDistrictListWithCityId:(NSString *)cityId;
{
    NSFileManager* manager = [NSFileManager defaultManager];  //设置文件管理器
    NSString* fileName = [[NSBundle mainBundle] pathForResource:@"hotelCDistrictList" ofType:@"plist"];
    if ([manager fileExistsAtPath:fileName])
    {
        NSDictionary* dic = [[NSDictionary alloc] initWithContentsOfFile:fileName];
        
        NSMutableArray *muArray = [[NSMutableArray alloc] init];
        NSDictionary *cityInfo = [dic objectForKey:@"result"];
        
        HYHotelDistrictInfo *unkown = [[HYHotelDistrictInfo alloc] init];
        unkown.name = @"不限";
        [muArray addObject:unkown];
        
        for (NSDictionary *d in cityInfo)
        {
            HYHotelDistrictInfo *c = [[HYHotelDistrictInfo alloc] initWithDataInfo:d];
            
            if ([c.cityId isEqualToString:cityId])
            {
               [muArray addObject:c];
            }
        }
        
        return muArray;
    }
    
    return nil;
}

@end
