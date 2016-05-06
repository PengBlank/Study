//
//  HYMallAdressListResponse.h
//  Teshehui
//
//  Created by ichina on 14-2-26.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "CQBaseResponse.h"
#import "HYAddressInfo.h"

@interface HYGetAdressListResponse : CQBaseResponse

@property (nonatomic, strong) NSArray *addressList;

@end
