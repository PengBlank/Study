//
//  HYSearchSuggestRequest.h
//  Teshehui
//
//  Created by apple on 15/1/26.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "CQBaseRequest.h"
#import "HYSearchSuggestResponse.h"

@interface HYSearchSuggestRequest : CQBaseRequest

@property (nonatomic, strong) NSString *key;
@property (nonatomic, assign) NSInteger size;

@end
