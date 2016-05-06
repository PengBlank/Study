//
//  HYMallHomeService.h
//  Teshehui
//
//  Created by 成才 向 on 16/3/23.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "HYMallHomeSections.h"

@interface HYMallHomeService : NSObject

///// 获取首页版块
//- (void)loadHomeBoardWithTypes:(NSArray *)requestTypes
//                     isChanged:(BOOL)changed
//                  interestTags:(NSIndexSet *)tags
//                      callback:(void (^)(NSArray *boards, NSError *err))callback;
- (void)loadAllInterestTags:(void (^)(NSArray *items))callback;

/// 获取更多商品（为您推荐）数据
- (void)loadRecmGoodsWithPage:(NSInteger)page callback:(void (^)(NSArray *goods))callback;

- (void)fetchTransactionTypes:(void (^)(NSArray *types))callback;

/// 获取首页数据
- (void)loadHomeBoardsWithInterestTags:(NSArray *)tags
                             isChanged:(BOOL)changed
                              callback:(void (^)(NSArray *boards, NSError *err))callback;


@end
