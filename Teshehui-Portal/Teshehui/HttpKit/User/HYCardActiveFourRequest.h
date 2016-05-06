//
//  HYCardActiveFourRequest.h
//  Teshehui
//
//  Created by apple on 15/4/8.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "CQBaseRequest.h"
#import "HYCardActiveFourResponse.h"

@interface HYCardActiveFourRequest : CQBaseRequest

@property (nonatomic, strong) NSString *memberCardNumber;
@property (nonatomic, strong) NSString *realName;
@property (nonatomic, strong) NSString *gender; //m男 f女
@end
