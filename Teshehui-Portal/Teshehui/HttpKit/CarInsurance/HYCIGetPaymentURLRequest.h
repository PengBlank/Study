//
//  HYCIGetPaymentURLRequest.h
//  Teshehui
//
//  Created by 成才 向 on 15/7/15.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYCIBaseReq.h"

@interface HYCIGetPaymentURLRequest : HYCIBaseReq

@property (nonatomic, strong) NSString *insuredName;
@property (nonatomic, strong) NSString *policyNo;
@property (nonatomic, strong) NSString *sessionid;

@end
