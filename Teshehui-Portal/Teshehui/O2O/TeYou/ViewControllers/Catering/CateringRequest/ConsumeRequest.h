//
//  ConsumeRequest.h
//  Teshehui
//
//  Created by macmini5 on 16/3/2.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//
//  账单页面 网络请求

#import "CQBaseRequest.h"

@interface ConsumeRequest : CQBaseRequest

@property (nonatomic, strong) NSString *UId;    // 用户id
@property (nonatomic, strong) NSString *merId;  // 商家id

@end
