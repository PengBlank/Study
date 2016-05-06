//
//  HYLocalDowntown.m
//  Teshehui
//
//  Created by 回亿资本 on 14-2-12.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYHotelCommercialInfo.h"
#import "HYHotelCityDowntownRequest.h"

@implementation HYHotelCommercialInfo

- (id)initWithDataInfo:(NSDictionary *)data
{
    self = [super init];
    
    if (self)
    {
        self.cityId = GETOBJECTFORKEY(data, @"city_id", [NSString class]);
        self.name = GETOBJECTFORKEY(data, @"name", [NSString class]);
        self.enName = GETOBJECTFORKEY(data, @"english_name", [NSString class]);
        self.downtownId = GETOBJECTFORKEY(data, @"id", [NSString class]);
        self.desc = GETOBJECTFORKEY(data, @"desc", [NSString class]);
    }
    
    return self;
}

+ (NSArray *)getCityDowntownListWithCityId:(NSString *)cityId;
{
    NSFileManager* manager = [NSFileManager defaultManager];  //设置文件管理器
//    NSString* string = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//    NSString* fileName = [string  stringByAppendingPathComponent:@"hotelCDownList.plist"];
    
    NSString* fileName = [[NSBundle mainBundle] pathForResource:@"hotelCDownList" ofType:@"plist"];
    if ([manager fileExistsAtPath:fileName])
    {
        NSDictionary* dic = [[NSDictionary alloc] initWithContentsOfFile:fileName];
        
        NSMutableArray *muArray = [[NSMutableArray alloc] init];
        NSDictionary *cityInfo = [dic objectForKey:@"result"];
        
        HYHotelCommercialInfo *unkown = [[HYHotelCommercialInfo alloc] init];
        unkown.name = @"不限";
        [muArray addObject:unkown];
        
        for (NSDictionary *d in cityInfo)
        {
            HYHotelCommercialInfo *c = [[HYHotelCommercialInfo alloc] initWithDataInfo:d];
            
            if ([c.cityId isEqualToString:cityId])
            {
                [muArray addObject:c];
            }
        }
        
        return muArray;
    }
    
    return nil;
}

+ (NSArray *)getAllCityDowntownInfo;
{
    NSFileManager* manager = [NSFileManager defaultManager];  //设置文件管理器
    NSString* string = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString* fileName = [string  stringByAppendingPathComponent:@"hotelCDownList.plist"];
    
    if ([manager fileExistsAtPath:fileName])
    {
        NSDictionary* dic = [[NSDictionary alloc] initWithContentsOfFile:fileName];
        
        NSMutableArray *muArray = [[NSMutableArray alloc] init];
        NSDictionary *cityInfo = [dic objectForKey:@"result"];
        
        HYHotelCommercialInfo *unkown = [[HYHotelCommercialInfo alloc] init];
        unkown.name = @"不限";
        [muArray addObject:unkown];
        
        for (NSDictionary *d in cityInfo)
        {
            HYHotelCommercialInfo *c = [[HYHotelCommercialInfo alloc] initWithDataInfo:d];
            [muArray addObject:c];
        }
        
        return muArray;
    }
    
    return nil;
}

+ (void)updateHotelCityDowntown
{
    HYHotelCityDowntownRequest *request = [[HYHotelCityDowntownRequest alloc] init];
    [request sendReuqest:^(id result, NSError *error) {
        if ([result isKindOfClass:[CQBaseResponse class]])
        {
            NSDictionary *dic = [(CQBaseResponse *)result jsonDic];
            
            NSString* string = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            NSString* fileName = [string  stringByAppendingPathComponent:@"hotelCDownList.plist"];
            [dic writeToFile:fileName atomically:NO];
        }
    }];
}

@end
