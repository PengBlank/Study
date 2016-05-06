//
//  HYMallGetGoodsCommentResponse.h
//  Teshehui
//
//  Created by HYZB on 14-9-16.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "CQBaseResponse.h"

@interface HYMallGetGoodsCommentResponse : CQBaseResponse

@property (nonatomic, strong) NSMutableArray *commentArray;
@property (nonatomic, assign) NSInteger commentTotal;

@end
