//
//  HYHotelRoom.h
//  Teshehui
//
//  Created by 回亿资本 on 14-2-7.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CQResponseResolve.h"
#import "HYHotelRatePlan.h"
#import "HYHotelPictureInfo.h"
#import "JSONModel.h"

@interface HYHotelRoom : JSONModel

@property (nonatomic, copy) NSString *commonRoomTypeId;   //房型唯一标识
@property (nonatomic, copy) NSString *commonRoomTypeCode;
@property (nonatomic, copy) NSString *roomTypeName;  //房型名称
@property (nonatomic, copy) NSString *bigLogoUrl;   //酒店的图
@property (nonatomic, copy) NSString *midLogoUrl;   //酒店的图
@property (nonatomic, copy) NSString *smallLogoUrl;   //酒店的图
//@property (nonatomic, copy) NSString *code;  //房型源数据编码
@property (nonatomic, copy) NSString *areaSize;   //房间尺寸
@property (nonatomic, copy) NSString *floor;  //楼层
@property (nonatomic, copy) NSString *bedType;  //床大小尺寸
@property (nonatomic, assign) BOOL bedAdd;  //是否可加床
@property (nonatomic, assign) CGFloat bedAddFee;  //加床费

@property (nonatomic, assign) int standardOccupancy;  //(房间容纳的人数，未知0，其他，表示房间可入住的人数)
@property (nonatomic, copy) NSString *noSmoking;  //是否无烟处理
@property (nonatomic, copy) NSString *wifi;  //无线网络（0 表示未知 1免费 2 收费）
@property (nonatomic, copy) NSString *broadBand;  //有线网络（0 表示未知 1免费 2 收费）
@property (nonatomic, assign) BOOL window;  //是否有窗
@property (nonatomic, assign) int windowNumber;  //窗户数量
@property (nonatomic, copy) NSString *desc;  //描述
@property (nonatomic, copy) NSString *createdTime;  //信息创建时间
@property (nonatomic, copy) NSString *updatedTime;  //信息最近更新时间
@property (nonatomic, copy) NSString *occupancy;  //返现金额

@property (nonatomic, strong) NSArray *rateList;  //房间价格计划列表（对应的是多个数据源的房间）

@property (nonatomic, assign) NSInteger selectIndex;
@property (nonatomic, strong, readonly) HYHotelRatePlan *selectRate;
//选中的房间
@property (nonatomic, strong) NSString *infoSource; //00001:crip, 00002:elong
@property (nonatomic, copy) NSString *code;  //酒店房型产品编码
//@property (nonatomic, copy) NSString *roomTypeId;  //酒店房型唯一标识ID
@property (nonatomic, copy) NSString *roomRatePlanName;	//房型产品名
@property (nonatomic, assign) BOOL status;  //产品是否可售
@property (nonatomic, assign) CGFloat totalFee;  //double	总价
@property (nonatomic, assign) CGFloat point;  //double	总价
@property (nonatomic, assign) CGFloat averageFee;  //String	日均价
@property (nonatomic, assign) CGFloat averageOldFee;  //String	促销前日均价
@property (nonatomic, assign) int stock;  //剩余房量
@property (nonatomic, assign) NSInteger isInstantConfirmation;  //是否支持及时确认，未知0，是1，否2
@property (nonatomic, copy) NSString *paymentTypeCode;  //String	现付前台付
@property (nonatomic, assign) NSInteger productTypeCode;    //未知0, 现付1, 担保2, 预付3
@property (nonatomic, assign) int minAmount;  //Integer	最少预定数
@property (nonatomic, assign) int minDays;  //Integer	最少入住天数
@property (nonatomic, assign) int maxDays;  //Integer	最大入住天数
@property (nonatomic, assign) double guaranteeFee;  //担保金额
@property (nonatomic, assign) NSInteger isGuaranteeFeeCancel;  //担保金订单是否可取消，0：未知，1是，2否
@property (nonatomic, copy) NSString *guaranteeFeeCancelTime;  //String	担保金订单取消最迟时间
//@property (nonatomic, copy) NSString *createdTime;  //String	信息创建时间

- (BOOL)isPrePay;
@end
