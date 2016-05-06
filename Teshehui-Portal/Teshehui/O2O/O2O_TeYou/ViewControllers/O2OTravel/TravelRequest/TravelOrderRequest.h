//
//  TravelOrderRequest.h
//  Teshehui
//
//  Created by apple_administrator on 15/10/19.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "CQBaseRequest.h"

@interface TravelOrderRequest : CQBaseRequest

//参数列表
@property (nonatomic, strong) NSString      *UserId;
@property (nonatomic, assign) NSInteger     orderType;


@end
