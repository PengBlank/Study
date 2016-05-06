//
//  HYLocalDowntown.h
//  Teshehui
//
//  Created by 回亿资本 on 14-2-12.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

/**
 * 酒店行商圈对象
 */

#import <Foundation/Foundation.h>
#import "CQResponseResolve.h"

@interface HYHotelCommercialInfo : NSObject<CQResponseResolve>

@property (nonatomic, copy) NSString *fName;  //拼音首字母
@property (nonatomic, copy) NSString *pinyin;  //拼音首字母
@property (nonatomic, copy) NSString *enName;  //英文名称
@property (nonatomic, copy) NSString *cityId;  //城市ID
@property (nonatomic, copy) NSString *downtownId;  //商业区ID
@property (nonatomic, copy) NSString *desc;  //描述
@property (nonatomic, copy) NSString *name;  //名称

+ (NSArray *)getAllCityDowntownInfo;
+ (NSArray *)getCityDowntownListWithCityId:(NSString *)cityId;
//+ (void)updateHotelCityDowntown;   //更新酒店的城市商业中心列表

@end
