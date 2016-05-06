//
//  CQHotelCity.h
//  Teshehui
//
//  Created by ChengQian on 13-11-5.
//  Copyright (c) 2013年 Charse. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HYCountryInfo : NSObject

@property (nonatomic, copy) NSString *countryId;
@property (nonatomic, copy) NSString *countryName;
@property (nonatomic, assign) NSInteger hot;

@property (nonatomic, copy) NSString *pinyin;  //拼音
@property (nonatomic, copy) NSString *pinyinIndex;  //拼音首字母


+ (NSArray *)getAllCountries;
+ (HYCountryInfo *)countryWithId:(NSString *)contryId;

@end
