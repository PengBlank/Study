//
//  HYCIQueryCarTypeListReq.h
//  Teshehui
//
//  Created by HYZB on 15/7/10.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYCIBaseReq.h"
#import "HYCIQueryCarTypeListResp.h"

@interface HYCIQueryCarTypeListParam : JSONModel

@property (nonatomic, copy) NSString *keyword;
@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, assign) NSInteger pageNo;

@end

@interface HYCIQueryCarTypeListReq : HYCIBaseReq


@end
