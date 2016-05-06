//
//  HYCardActiveTwoRequest.h
//  Teshehui
//
//  Created by apple on 15/4/8.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "CQBaseRequest.h"
#import "HYCardActiveTwoResponse.h"

@interface HYCardActiveTwoRequest : CQBaseRequest

@property (nonatomic, strong) NSString *memberCardNumber;
@property (nonatomic, strong) NSString *mobilePhone;

@end
