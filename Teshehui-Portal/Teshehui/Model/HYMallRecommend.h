//
//  HYMallRecommend.h
//  Teshehui
//
//  Created by HYZB on 14-9-11.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "CQResponseResolve.h"

/**
 *  商城推荐
 */
@interface HYMallRecommend : NSObject<CQResponseResolve>

@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSArray *products;

@end
