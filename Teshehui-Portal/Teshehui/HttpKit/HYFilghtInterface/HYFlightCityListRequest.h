//
//  HYFlightCityListRequest.h
//  Teshehui
//
//  Created by apple on 15/3/27.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "CQBaseRequest.h"
#import "HYFlightCityListResponse.h"

@interface HYFlightCityListRequest : CQBaseRequest

@property (nonatomic, strong) NSString *keyword;

@end
