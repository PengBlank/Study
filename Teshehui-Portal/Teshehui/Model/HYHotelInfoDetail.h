//
//  HYHotelInfoBase.h
//  Teshehui
//
//  Created by 回亿资本 on 14-2-7.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYHotelListSummary.h"
#import "HYHotelSKU.h"
#import "HYProductDetailSummary.h"

@interface HYHotelInfoDetail : HYProductDetailSummary


@property (nonatomic, copy) NSString *generalAmenities; //基础服务设施
@property (nonatomic, copy) NSString *roomAmenities;    //房间设施
@property (nonatomic, copy) NSString *recreationAmenities;  //娱乐设施
@property (nonatomic, copy) NSString *otherAmenities;   //其他设施
@property (nonatomic, copy) NSString *traffic;  //交通
@property (nonatomic, strong) NSString *trafficEscaped;
@property (nonatomic, copy) NSString *surroundings; //周边
@property (nonatomic, copy) NSString *hotelDescription; //描述
@property (nonatomic, strong) NSString *hotelDescriptionEscaped;

@property (nonatomic, copy) NSString *establishmentTime; //开业时间;
@property (nonatomic, copy) NSString *renovationTime; //最近装修时间;

@property (nonatomic, strong) NSArray *pictureList;
@property (nonatomic, strong) NSArray *roomTypeList;  //酒店的房型列表

@property (nonatomic, strong) HYHotelSKU *currentsSUK;

@property (nonatomic, strong, readonly) NSArray *bigImgList;
@property (nonatomic, strong, readonly) NSArray *midImgList;
@property (nonatomic, strong, readonly) NSArray *smallImgList;

@property (nonatomic, copy) NSString *productPicUrl;
@property (nonatomic, copy) NSString *currencyCode;
@property (nonatomic, copy) NSString *cityId;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *hotelStar;
@property (nonatomic, strong) NSString *hotelType;
@property (nonatomic, copy) NSString *districtName;   //商业区ID
@property (nonatomic, copy) NSString *commercialName;   //商业区名称
@property (nonatomic, assign) NSInteger wifi;   //有值表示存在(>-1),false免费(0), true收费(1)
@property (nonatomic, assign) NSInteger park;    //有值表示存在(>-1),false免费(0), true收费(1)
@property (nonatomic, copy) NSString *score;   //酒店评分
@property (nonatomic, copy) NSString *bigLogoUrl;   //酒店的图
@property (nonatomic, copy) NSString *midLogoUrl;   //酒店的图
@property (nonatomic, copy) NSString *smallLogoUrl;   //酒店的图
@property (nonatomic, assign) float latitude;
@property (nonatomic, assign) float longitude;
@property (nonatomic, copy) NSString *positionTypeCode;

@property (nonatomic, strong) NSArray *roomItems;


- (void)setWithSummaryInfo:(HYHotelListSummary *)summary;

- (id)initWithDataInfo:(NSDictionary *)data;

@end
