//
//  CallServiceRequest.h
//  Teshehui
//
//  Created by apple_administrator on 15/12/22.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "CQBaseRequest.h"

@interface CallServiceRequest : CQBaseRequest
@property (nonatomic,strong) NSString *merId; //商家ID
@property (nonatomic,strong) NSString *btId; //球台ID
@property (nonatomic,strong) NSString *mobile; //会员手机号
@property (nonatomic,strong) NSString *uName; //用户名
@end
