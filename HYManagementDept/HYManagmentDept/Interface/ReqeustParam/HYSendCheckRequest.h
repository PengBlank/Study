//
//  HYSendCheckRequest.h
//  Teshehui
//
//  Created by ichina on 14-3-1.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYBaseRequestParam.h"
#import "HYSendCheckResponse.h"
@interface HYSendCheckRequest : HYBaseRequestParam

@property (nonatomic, copy) NSString *code;

@property (nonatomic, copy) NSString *phone_mob;

@end
