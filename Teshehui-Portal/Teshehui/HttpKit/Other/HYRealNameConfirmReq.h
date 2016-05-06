//
//  HYRealNameConfirmReq.h
//  Teshehui
//
//  Created by Kris on 15/9/12.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "CQBaseRequest.h"

@interface HYRealNameConfirmReq : CQBaseRequest

@property (nonatomic, copy) NSString *certificateCode;
@property (nonatomic, copy) NSString *certificateNumber;
@property (nonatomic, copy) NSString *realName;

@end
