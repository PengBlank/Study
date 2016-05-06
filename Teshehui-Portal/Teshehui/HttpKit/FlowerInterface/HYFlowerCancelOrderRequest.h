//
//  HYFlowerCancelOrderRequest.h
//  Teshehui
//
//  Created by ichina on 14-2-19.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "CQBaseRequest.h"

@interface HYFlowerCancelOrderRequest : CQBaseRequest

@property(nonatomic,retain)NSString* orderNo;

@property(nonatomic,retain)NSString* userID;
@end
