//
//  PrepayRequest.h
//  Teshehui
//
//  Created by macmini5 on 16/3/1.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//
//  实体店余额充值 网络请求

#import "CQBaseRequest.h"

@interface PrepayRequest : CQBaseRequest

/**PrepayRequest 商家id*/
@property (nonatomic, strong) NSString *merId;
/**PrepayRequest 用户id*/
@property (nonatomic, strong) NSString *UId;
/**PrepayRequest 商家类型 桌球类型：Billiard，默认""*/
@property (nonatomic, strong) NSString *merchantType;
/**PrepayRequest 手机号*/
@property (nonatomic, strong) NSString *mobile;


@end
