//
//  HYActivityCategoryResponse.h
//  Teshehui
//
//  Created by RayXiang on 14-8-4.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "CQBaseResponse.h"
#import "HYActivityCategory.h"

@interface HYGetActivityListResponse : CQBaseResponse

@property (nonatomic, strong, readonly) NSArray *categoryArray;
@property (nonatomic, strong, readonly) NSString *title;

@end
