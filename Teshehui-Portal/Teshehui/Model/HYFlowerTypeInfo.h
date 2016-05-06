//
//  HYFlowerTypeInfo.h
//  Teshehui
//
//  Created by 回亿资本 on 14-2-7.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CQResponseResolve.h"
#import "JSONModel.h"

@protocol  HYFlowerTypeInfo <NSObject> @end

@interface HYFlowerTypeInfo : JSONModel

@property (nonatomic, copy) NSString *categoryId;
@property (nonatomic, copy) NSString *categoryName;
@property (nonatomic, copy) NSString *categoryPicUrl;

@property (nonatomic, strong) NSArray<HYFlowerTypeInfo> *children;

@end
