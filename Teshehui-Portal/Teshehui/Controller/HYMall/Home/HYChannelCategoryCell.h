//
//  HYChannelCategoryCell.h
//  Teshehui
//
//  Created by 成才 向 on 15/10/8.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYBaseLineCell.h"
#import "HYChannelPageRequest.h"

/**
 *  二级频道界面更多商品分类选项
 */
@interface HYChannelCategoryCell : HYBaseLineCell

@property (nonatomic, strong) NSArray<HYChannelCategory*> *items;
@property (nonatomic, assign) NSInteger selectedIdx;

@property (nonatomic, copy) void (^cateCallback)(NSInteger idx);

@end
