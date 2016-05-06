//
//  HYCIBaseReq.h
//  Teshehui
//
//  Created by HYZB on 15/7/2.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "CQBaseRequest.h"
#import "JSONModel.h"

@interface HYCIBaseReq : CQBaseRequest

@property(nonatomic, strong) JSONModel *reqParam;

@end
