//
//  StoreBalanceRequest.h
//  Teshehui
//
//  Created by macmini5 on 16/3/2.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//
//  实体店余额页面 网络请求

#import "CQBaseRequest.h"

@interface StoreBalanceRequest : CQBaseRequest

/**StoreBalanceRequest 用户id*/
@property (nonatomic, strong) NSString *UId;

@end
