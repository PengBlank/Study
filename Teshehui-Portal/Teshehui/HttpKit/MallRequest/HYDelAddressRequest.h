//
//  HYDelAdressRequest.h
//  Teshehui
//
//  Created by ichina on 14-3-3.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "CQBaseRequest.h"

@interface HYDelAddressRequest : CQBaseRequest

@property (nonatomic, copy) NSString *addr_id;
@property (nonatomic, copy) NSString *user_id;

@end
