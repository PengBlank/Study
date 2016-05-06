//
//  HYGetOrderInfoRequest.h
//  Teshehui
//
//  Created by ichina on 14-2-19.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "CQBaseRequest.h"
#import "HYFlowerGetOrderInfoResponse.h"

@interface HYFlowerGetOrderInfoRequest : CQBaseRequest

@property(nonatomic,copy)NSString* OrderNo;
@property(nonatomic, assign) NSInteger IsEnterprise;  //企业账号查看企业员工因公消费.is_enterprise=1

@end
