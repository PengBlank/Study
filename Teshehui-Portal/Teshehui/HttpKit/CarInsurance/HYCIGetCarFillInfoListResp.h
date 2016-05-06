//
//  HYCIGetCarFillInfoListResp.h
//  Teshehui
//
//  Created by HYZB on 15/7/3.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "CQBaseResponse.h"
#import "HYCICarInfoFillType.h"

@interface HYCIGetCarFillInfoListResp : CQBaseResponse

@property (nonatomic, copy) NSString *infoKey;
@property (nonatomic, copy) NSString *sessionId;
@property (nonatomic, strong) NSDictionary *packageTypeMap;
@property (nonatomic, strong) NSArray *carInfoShowList;
@property (nonatomic, strong) NSArray *carInfoAllList;

@property (nonatomic, strong) NSString *vichelSearchKey;

@end
