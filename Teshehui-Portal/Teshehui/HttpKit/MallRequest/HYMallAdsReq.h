//
//  HYMallAdsReq.h
//  Teshehui
//
//  Created by Kris on 16/1/6.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYMallAdsResponse.h"
#import "CQBaseRequest.h"

@interface HYMallAdsReq : CQBaseRequest

@property (nonatomic, copy) NSString *boardCodes;  //模块的代码

@end
