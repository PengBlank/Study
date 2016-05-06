//
//  HYMallCategorySummary.h
//  Teshehui
//
//  Created by HYZB on 15/1/21.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "CQResponseResolve.h"

@interface HYMallCategorySummary : NSObject<CQResponseResolve>

@property (nonatomic, copy) NSString* cate_id;
@property (nonatomic, copy) NSString* cate_name;
@property (nonatomic, copy) NSString* img;

@end
