//
//  CQflightCity.m
//  Teshehui
//
//  Created by ChengQian on 13-11-23.
//  Copyright (c) 2013年 Charse. All rights reserved.
//

#import "HYFlightCity.h"
#import "JSONKit_HY.h"
#import "PTChineseNameInfo.h"
#import "PinYin.h"

@implementation HYFlightCity
+ (NSArray *)getAllCityflight
{
    NSString* string = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString* fileName = [string  stringByAppendingPathComponent:@"flight_city.plist"];
    NSArray *citylist = [NSArray arrayWithContentsOfFile:fileName];
    if (citylist)
    {
        NSInteger index = 100;
        NSMutableArray *muArray = [[NSMutableArray alloc] init];
        for (NSDictionary *d in citylist)
        {
            HYFlightCity *c = [[HYFlightCity alloc] initWithJSON:d];
            c.cityId = [NSString stringWithFormat:@"%ld", index];
            c.countryId = c.cityId;
            c.countryName = c.cityName;
            [muArray addObject:c];
            index++;
        }
        
        return muArray;
    }
    
    return nil;
}

- (id)initWithJSON:(NSDictionary *)dic
{
    self = [super init];
    
    if (self)
    {
        self.code = GETOBJECTFORKEY(dic, @"code", [NSString class]);
        self.cityName = GETOBJECTFORKEY(dic, @"name", [NSString class]);
        self.pinyin = GETOBJECTFORKEY(dic, @"pinyin", [NSString class]);
        self.shortName = GETOBJECTFORKEY(dic, @"short_code", [NSString class]);
        NSString *h = GETOBJECTFORKEY(dic, @"hit", [NSString class]);
        self.hot = [h integerValue];

        NSString *f = @"#";
        if ([self.pinyin length] > 0)
        {
            f = [self.pinyin substringToIndex:1];
            f = [f uppercaseString];
        }
        else
        {
            PTChineseNameInfo *cni = [PinYin quickConvert:self.cityName];
            self.pinyin = cni.pinyinLong;
            f = cni.pinyinIndex;
        }
        
        self.pinyinIndex = f;
    }
    
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
	// Don't forget - this will return a retained copy!
	HYFlightCity *f = [[HYFlightCity alloc] init];
    
    f.code = [self.code copyWithZone:zone];
    f.pinyin = [self.pinyin copyWithZone:zone];
    f.cityName = [self.cityName copyWithZone:zone];
    f.hot = self.hot;
    f.pinyinIndex = [self.pinyinIndex copyWithZone:zone];
	return f;
}

+ (id)getWithCityName:(NSString *)cityName; //在本地数据中查
{
    NSArray *all = [HYFlightCity getAllCityflight];
    
    for (HYFlightCity *city in all)
    {
        if ([city.cityName hasPrefix:cityName])
        {
            return city;
        }
    }
    
    return nil;
}

+ (void)storyFlightCities:(NSArray *)cityList
{
    NSString* string = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString* fileName = [string stringByAppendingPathComponent:@"flight_city.plist"];
    [cityList writeToFile:fileName atomically:YES];
}

+ (id)getWithCityCode:(NSString *)CityCode
{
    NSArray *all = [HYFlightCity getAllCityflight];
    
    for (HYFlightCity *city in all)
    {
        if ([city.code isEqualToString:CityCode])
        {
            return city;
        }
    }
    
    return nil;
}
@end
