//
//  CreatOrderRequest.h
//  Teshehui
//
//  Created by apple_administrator on 15/9/25.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "CQBaseRequest.h"

@interface CreatOrderRequest : CQBaseRequest

@property (nonatomic,assign) NSInteger      Coupon;
@property (nonatomic,assign) double         Amount;
@property (nonatomic,strong) NSString       *UserName;
@property (nonatomic,strong) NSString       *CardNo;
@property (nonatomic,strong) NSString       *Mobile;
@property (nonatomic,strong) NSString       *MerId;
@property (nonatomic,strong) NSString       *MerchantName;
@property (nonatomic,strong) NSString       *MerchantLogo;
@property (nonatomic,strong) NSString       *productName;

@property (nonatomic, assign) NSInteger     first_area_id;
@property (nonatomic, assign) NSInteger     second_area_id;
@property (nonatomic, assign) NSInteger     third_area_id;
@property (nonatomic, assign) NSInteger     fourth_area_id;


@end
