//
//  HYHotelLocalDistrict.h
//  Teshehui
//
//  Created by 回亿资本 on 14-2-12.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

/**
 * 酒店行政区对象
 */

#import <Foundation/Foundation.h>
#import "CQResponseResolve.h"

@interface HYHotelDistrictInfo : NSObject<CQResponseResolve>

@property (nonatomic, copy) NSString *fName;  //拼音首字母
@property (nonatomic, copy) NSString *pinyin;  //拼音首字母
@property (nonatomic, copy) NSString *enName;  //英文名称
@property (nonatomic, copy) NSString *cityId;  //城市ID
@property (nonatomic, copy) NSString *name;  //英文名称
@property (nonatomic, copy) NSString *districtId;  //行政区ID

+ (NSArray *)getAllCityDistrictInfo;
+ (NSArray *)getCityDistrictListWithCityId:(NSString *)cityId;
@end
