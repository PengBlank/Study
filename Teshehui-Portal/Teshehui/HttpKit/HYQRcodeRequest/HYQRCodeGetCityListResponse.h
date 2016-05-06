//
//  HYQRCodeGetCityListResponse.h
//  Teshehui
//
//  Created by HYZB on 14-7-4.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "CQBaseResponse.h"

@interface HYCityForQRCode : NSObject

@property (nonatomic, assign) NSInteger region_id;
@property (nonatomic, copy) NSString *region_name;

@property (nonatomic, readonly) NSString *region_use;

@end

@interface HYQRCodeGetCityListResponse : CQBaseResponse

@property (nonatomic, strong, readonly) NSArray *cityList;

@end
