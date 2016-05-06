//
//  HYCIQueryCarTypeListResp.h
//  Teshehui
//
//  Created by HYZB on 15/7/10.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "CQBaseResponse.h"
#import "HYCICarBrandInfo.h"

@interface HYCIQueryCarTypeListResp : CQBaseResponse

@property (nonatomic, strong) NSArray *typeList;

@end
