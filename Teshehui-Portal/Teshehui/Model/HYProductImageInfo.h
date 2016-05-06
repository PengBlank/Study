//
//  HYProductImageInfo.h
//  Teshehui
//
//  Created by 回亿资本 on 14-3-26.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CQResponseResolve.h"

@interface HYProductImageInfo : NSObject<CQResponseResolve>

@property (nonatomic, copy) NSString *image_id;
@property (nonatomic, copy) NSString *goods_id;
@property (nonatomic, copy) NSString *image_url;
@property (nonatomic, copy) NSString *thumbnail;
@property (nonatomic, copy) NSString *thumbnail_middle;
@property (nonatomic, copy) NSString *thumbnail_small;
@property (nonatomic, copy) NSString *file_id;
@property (nonatomic, copy) NSString *sort_order;

@end
