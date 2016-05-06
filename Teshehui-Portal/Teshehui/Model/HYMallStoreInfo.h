//
//  HYMallStoreInfo.h
//  Teshehui
//
//  Created by 回亿资本 on 14-3-25.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CQResponseResolve.h"

@interface HYMallStoreInfo : NSObject<CQResponseResolve>

@property (nonatomic, copy) NSString *store_id;
@property (nonatomic, copy) NSString *store_name;
@property (nonatomic, copy) NSString *owner_name;
@property (nonatomic, copy) NSString *keyword;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *img;
@property (nonatomic, copy) NSString *thumb;

@end
