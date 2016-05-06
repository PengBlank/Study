//
//  HYCardActiveFourFiveRequest.h
//  Teshehui
//
//  Created by 成才 向 on 15/8/26.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "CQBaseRequest.h"
#import "HYCardActiveFourFiveResponse.h"

@interface HYCardActiveFourFiveRequest : CQBaseRequest

@property (nonatomic, strong) NSString *memberCardNumber;
@property (nonatomic, strong) NSString *realName;
@property (nonatomic, strong) NSString *gender; //1男 0女
@property (nonatomic, copy) NSString *certificateCode;  //证件类型，01：身份证 02：护照 03：军人证 05：驾驶证 06：港澳回乡证或台胞证 99：其他。-->
@property (nonatomic, assign) NSInteger activeType;  //0默认
@property (nonatomic, strong) NSString *certificateNumber;
@property (nonatomic, strong) NSString *birthday;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *isBuyPolicy;
@property (nonatomic, strong) NSString *policyType;

@end
