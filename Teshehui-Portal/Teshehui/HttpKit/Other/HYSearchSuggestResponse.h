//
//  HYSearchSuggestResponse.h
//  Teshehui
//
//  Created by apple on 15/1/26.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "CQBaseResponse.h"
#import "HYSearchSuggestItem.h"

@interface HYSearchSuggestResponse : CQBaseResponse

@property (nonatomic, strong) NSArray *result;

@end

