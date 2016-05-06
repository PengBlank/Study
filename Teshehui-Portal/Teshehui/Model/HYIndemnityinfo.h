//
//  HYIndemntifyinfo.h
//  Teshehui
//
//  Created by HYZB on 15/4/2.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//


/*
 * 赔付的信息
 */

#import "CQResponseResolve.h"
#import "JSONModel.h"
#import "HYMallGuijiupeiOrderLogItem.h"

@interface HYIndemnityinfo : JSONModel

@property (nonatomic, copy) NSString *indId;
@property (nonatomic, copy) NSString *compareURL;
@property (nonatomic, copy) NSString *desc;

@property (nonatomic, copy) NSArray *imgs;
@property (nonatomic, copy) NSArray <HYMallGuijiupeiOrderLogItem>*progressList;  // 进度说明

@end
