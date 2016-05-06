//
//  HYSearchKeywordReq.h
//  Teshehui
//
//  Created by HYZB on 15/11/25.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYAnalyticsBaseReq.h"

@interface HYSearchKeywordReq : HYAnalyticsBaseReq

@property (nonatomic, copy) NSString *key_words;   //搜索关键词
@property (nonatomic, copy) NSString *result_ind;  //搜索结果标识

@end
