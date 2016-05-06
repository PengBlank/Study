//
//  HYUserVirtualAccountResponse.h
//  Teshehui
//
//  Created by 成才 向 on 15/8/24.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "CQBaseResponse.h"
#import "HYUserVirutalAccountInfo.h"

@interface HYUserVirtualAccountResponse : CQBaseResponse

@property (nonatomic, strong) HYUserVirutalAccountInfo *accountInfo;

@end
