//
//  HYGetFlightDetailReq.h
//  Teshehui
//
//  Created by HYZB on 15/5/29.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYMallGoodDetailRequest.h"
#import "HYCabins.h"
#import "HYFlightDetailInfo.h"

@interface HYGetFlightDetailResp : CQBaseResponse

@property (nonatomic, strong) HYFlightDetailInfo *flightInfo;

@end

@interface HYGetFlightDetailReq : HYMallGoodDetailRequest

@property (nonatomic, copy) NSString *startCityId;  //酒店ID
@property (nonatomic, copy) NSString *endCityId;  //入住时间
@property (nonatomic, copy) NSString *flightDate;  //离店时间
@property (nonatomic, strong) NSArray *cabinType;  //舱位类型筛选 F-头等舱 C-商务舱 Y-经济舱
@property (nonatomic, copy) NSString *isSupportChild;

@end
