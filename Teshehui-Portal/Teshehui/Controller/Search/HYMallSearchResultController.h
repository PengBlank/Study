//
//  HYMallSearchResultController.h
//  Teshehui
//
//  Created by apple on 15/1/26.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYMallViewBaseController.h"

/**
 *  搜索结果列表页
 *  有筛选功能,新增排序功能界面
 *  
 */
@interface HYMallSearchResultController : HYMallViewBaseController
/** 用户输入搜索词 */
@property (nonatomic, strong) NSString *searchKey;
/** 默认搜索词 */
@property (nonatomic, copy) NSString *searchKeyWord;

@end
 