//
//  HYCIGetCityListParam.h
//  Teshehui
//
//  Created by HYZB on 15/7/2.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYCIBaseReq.h"

@interface HYCIGetCityListReq : HYCIBaseReq

@end

@interface HYCIGetCityListParam : JSONModel

@property (nonatomic, copy) NSString *parentId;

@end