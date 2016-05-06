//
//  HYTabbarItem.h
//  Teshehui
//
//  Created by 回亿资本 on 14-3-31.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HYTabbarItem : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) UIImage *normalImage;
@property (nonatomic, strong) UIImage *selectImage;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) BOOL hasNew;

@end
