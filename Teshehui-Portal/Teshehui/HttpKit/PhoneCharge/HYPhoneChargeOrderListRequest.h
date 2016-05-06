//
//  HYPhoneChargeOrderListRequest.h
//  Teshehui
//
//  Created by HYZB on 16/3/1.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "CQBaseRequest.h"

@interface HYPhoneChargeOrderListRequest : CQBaseRequest

@property (nonatomic, assign) NSInteger pageNo;
@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, copy) NSString *type;

/*
Integer   pageNo;  //页码数
Integer pageSize; //每页条数
Long    userId;//登录用户的ID
String type;// 2 话费  5 流量
 */

@end
