//
//  HYQueryMemberInsuranceResponse.h
//  Teshehui
//
//  Created by Kris on 15/6/4.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "CQBaseResponse.h"
#import "HYPolicy.h"

@interface HYQueryMemberInsuranceResponse : CQBaseResponse

@property (nonatomic, strong) HYPolicy *insuranceResualt;

@end



/*
"data":{
    "renewal":1,
    "expiredDay":322,
    "renewalFee":"0.01",
    "points":"5",
    "policyType":"会员续费"
},
*/