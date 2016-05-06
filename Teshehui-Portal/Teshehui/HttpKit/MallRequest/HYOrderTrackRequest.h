//
//  HYOrderTrackRequest.h
//  Teshehui
//
//  Created by ichina on 14-3-11.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//


#import "CQBaseRequest.h"
#import "HYOrderTrackResponse.h"

/**
 *  物流查询
 */
@interface HYOrderTrackRequest : CQBaseRequest

@property (nonatomic, copy) NSString *order_id;
@property (nonatomic, copy) NSString *order_code;

@end
