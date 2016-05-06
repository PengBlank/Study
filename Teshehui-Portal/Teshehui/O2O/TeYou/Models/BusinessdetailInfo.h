//
//  BusinessdetailInfo.h
//  Teshehui
//
//  Created by apple_administrator on 15/9/4.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommentInfo.h"
@interface BusinessdetailInfo : NSObject

@property (nonatomic, assign) NSInteger             Distance;
@property (nonatomic, assign) NSInteger             IsAllDay;
@property (nonatomic, assign) NSInteger             CommentCount;
@property (nonatomic, assign) NSInteger             IsBankEnable;
@property (nonatomic, assign) NSInteger             enableCharge; // 是否开通充值
@property (nonatomic, assign) NSInteger             isDiscount; //是否有折扣
@property (nonatomic, assign) NSInteger             isBilliards; //是否是桌球商家
@property (nonatomic, assign) BOOL                  Refresh;

@property (nonatomic, assign) NSInteger             first_area_id;
@property (nonatomic, assign) NSInteger             second_area_id;
@property (nonatomic, assign) NSInteger             third_area_id;
@property (nonatomic, assign) NSInteger             fourth_area_id;

@property (nonatomic, assign) CGFloat             AverageStars; //商家总评分
@property (nonatomic, assign) CGFloat             Latitude;
@property (nonatomic, assign) CGFloat             Longitude;

@property (nonatomic, strong) NSString              *OpeningHours;
@property (nonatomic, strong) NSMutableArray        *Photos;
@property (nonatomic, strong) NSMutableArray        *Aptitudes;
@property (nonatomic, strong) NSMutableArray        *discounts; //折扣列表

@property (nonatomic, strong) NSString              *Address;
@property (nonatomic, strong) NSString              *Logo;
@property (nonatomic, strong) NSString              *MDescription;
@property (nonatomic, strong) NSString              *MerchantsName;
@property (nonatomic, strong) NSString              *MerId;
@property (nonatomic, strong) NSString              *Mobile;
@property (nonatomic, strong) NSString              *Phone;
@property (nonatomic, strong) NSString              *Strategy;

@property (nonatomic, strong) NSString              *Common_Strategy;

@property (nonatomic, strong) CommentInfo           *Comment;

@end

@interface photoInfo : NSObject
@property (nonatomic, strong) NSString              *PhId;
@property (nonatomic, strong) NSString              *Url;
@property (nonatomic, strong) NSString              *Action;
@end
