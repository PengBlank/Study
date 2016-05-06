//
//  CQflightCity.h
//  Teshehui
//
//  Created by ChengQian on 13-11-23.
//  Copyright (c) 2013年 Charse. All rights reserved.
//

#import "HYCountryInfo.h"

@interface HYFlightCity : HYCountryInfo

@property (nonatomic, copy) NSString *cityId;
@property (nonatomic, copy) NSString *cityName;

@property (nonatomic, copy) NSString *code;  //机场三字码
@property (nonatomic, copy) NSString *shortName;

@property (nonatomic, assign) NSInteger cityIndex;  //自建的索引

- (id)initWithJSON:(NSDictionary *)dic;
+ (id)getWithCityName:(NSString *)cityName; //在本地数据中查找
+ (id)getWithCityCode:(NSString *)CityCode; //在本地数据中查找
+ (NSArray *)getAllCityflight;
+ (void)storyFlightCities:(NSArray *)cityList;

@end
