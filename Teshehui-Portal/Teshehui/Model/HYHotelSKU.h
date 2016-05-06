//
//  HYHotelSKU.h
//  Teshehui
//
//  Created by Kris on 15/5/23.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYProductSKU.h"
#import "HYHotelRoom.h"

@protocol HYHotelSKU<HYProductSKU> @end

@interface HYHotelSKU : HYProductSKU

//@property (nonatomic, strong) HYHotelRoom *expandedResponse;
@property (nonatomic, assign) NSInteger selectIndex;

@property (nonatomic, assign) NSInteger isSupportInvoice;   //支持行程单
@property (nonatomic, strong) NSString *commonRoomTypeId;
@property (nonatomic, strong) NSString *commonRoomTypeCode; //这两个不知道是啥
@property (nonatomic, strong) NSString *roomTypeName;   //宽大房
@property (nonatomic, strong) NSString *bigLogoUrl;
@property (nonatomic, strong) NSString *midLogoUrl;
@property (nonatomic, strong) NSString *smallLogoUrl;
@property (nonatomic, strong) NSString *areaSize;   //大小
@property (nonatomic, assign) NSInteger standardOccupancy;  //(房间容纳的人数，未知0，其他，表示房间可入住的人数)
@property (nonatomic, strong) NSString *floor;              //楼层
@property (nonatomic, strong) NSString *bedType;            //床大水目
@property (nonatomic, assign) NSInteger bedAdd; //加床
@property (nonatomic, assign) NSInteger wifi;   //wifi
@property (nonatomic, assign) NSInteger broadBand;  //有线网络（0 表示未知 1免费 2 收费）
@property (nonatomic, assign) NSInteger windowNumber;   //窗数
//@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *roomTypeCode;
@property (nonatomic, strong) NSString *roomRatePlanName;
@property (nonatomic, strong) NSString *startDate;
@property (nonatomic, strong) NSString *endDate;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, assign) CGFloat averageFee;
@property (nonatomic, assign) CGFloat averageOldFee;
@property (nonatomic, assign) NSInteger isInstantConfirmation;
@property (nonatomic, assign) NSInteger numberOfBreakfast;  //早餐
@property (nonatomic, strong) NSString *paymentTypeCode;
@property (nonatomic, strong) NSString *productTypeCode;    //未知0, 现付1, 担保2, 预付3
@property (nonatomic, assign) NSInteger minAmount;  //Integer	最少预定数
@property (nonatomic, assign) NSInteger maxDays;    //Integer	最少入住天数
@property (nonatomic, assign) NSInteger minDays;    //Integer	最大入住天数
@property (nonatomic, strong) NSString *guaranteeTypeCode;
@property (nonatomic, assign) NSInteger guaranteeFee;
@property (nonatomic, assign) NSInteger isGuaranteeFeeCancel;   //担保金订单是否可取消，0：未知，1是，2否
@property (nonatomic, strong) NSString *createdTime;
@property (nonatomic, strong) NSString *updatedTime;

- (BOOL)isPrePay;

@end
