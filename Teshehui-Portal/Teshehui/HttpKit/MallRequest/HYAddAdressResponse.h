//
//  HYAddAdressResponse.h
//  Teshehui
//
//  Created by ichina on 14-3-10.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "CQBaseResponse.h"
#import "HYAddressInfo.h"

@interface HYAddAdressResponse : CQBaseResponse

@property (nonatomic, strong) HYAddressInfo *adressInfo;
@property (nonatomic, copy) NSString *message;

@end
