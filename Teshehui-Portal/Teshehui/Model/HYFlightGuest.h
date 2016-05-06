//
//  HYFlightGuest.h
//  Teshehui
//
//  Created by 成才 向 on 15/5/30.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "JSONModel.h"

@protocol HYFlightGuest <NSObject>

@end

/**
 *  机票订单乘客对象
 */
@interface HYFlightGuest : JSONModel

@property (nonatomic,strong) NSNumber *gender;
@property (nonatomic,strong) NSNumber *guestId;
@property (nonatomic,strong) NSNumber *certificateCode;
@property (nonatomic,strong) NSString *certificateName;
@property (nonatomic,strong) NSNumber *countryId;
@property (nonatomic,strong) NSString *certificateNumber;
@property (nonatomic,strong) NSString *birthday;
@property (nonatomic,strong) NSString *tel;
@property (nonatomic,strong) NSString *name;

@end
