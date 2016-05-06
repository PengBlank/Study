//
//  HYUserVirtualAccountInfoRequest.h
//  Teshehui
//
//  Created by 成才 向 on 15/8/24.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "CQBaseRequest.h"
#import "HYUserVirutalAccountInfo.h"
#import "HYUserVirtualAccountResponse.h"

@interface HYUserVirtualAccountInfoRequest : CQBaseRequest

@property (nonatomic, assign) NSInteger accountType;    //0现金券 ，1特火币

@end
