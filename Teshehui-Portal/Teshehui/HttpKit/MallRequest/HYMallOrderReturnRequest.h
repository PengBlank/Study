//
//  HYMallOrderReturnRequest.h
//  Teshehui
//
//  Created by RayXiang on 14-9-22.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "CQBaseRequest.h"

@interface HYMallOrderReturnRequest : CQBaseRequest

@property (nonatomic, strong) NSString *order_id;
@property (nonatomic, assign) NSInteger refund_type;    //1退货，2换货
@property (nonatomic, strong) NSString *goods_id;
@property (nonatomic, assign) NSInteger return_number;
@property (nonatomic, strong) NSString *refund_desc;
@property (nonatomic, strong) NSArray *attachments;

@end
