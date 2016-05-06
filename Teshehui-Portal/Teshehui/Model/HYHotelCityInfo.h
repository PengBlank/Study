//
//  CQAttCity.h
//  Teshehui
//
//  Created by ChengQian on 13-11-13.
//  Copyright (c) 2013年 Charse. All rights reserved.
//

#import "HYCountryInfo.h"
#import "CQResponseResolve.h"

@interface HYHotelCityInfo : HYCountryInfo<CQResponseResolve>

@property (nonatomic, copy) NSString *provinceId;
@property (nonatomic, copy) NSString *provinceName;

@property (nonatomic, copy) NSString *cityId;
@property (nonatomic, copy) NSString *cityName;

@property (nonatomic, readonly, strong) NSArray *districtList;
@property (nonatomic, readonly, strong) NSArray *commercialList;

- (void)updateInfo;

+ (HYHotelCityInfo *)getWithCityName:(NSString *)cityName;

//获取所有城市
+ (NSArray *)getAllAttCityInfo;

//更新城市列表版本号
+ (void)updateHotelCityWithCallback:(void(^)(BOOL succ, BOOL hasChange)) callback;  //更新酒店的城市列表

//将包中的城市列表写入documents文件夹中
+ (void)registerDefaultCitys;

@end
