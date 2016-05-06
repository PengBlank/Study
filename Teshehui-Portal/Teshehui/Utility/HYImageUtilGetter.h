//
//  HYImageUtilGetter.h
//  Teshehui
//
//  Created by 成才 向 on 15/5/7.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HYImageUtilGetter : NSObject

+ (instancetype)sharedImageGetter;

@property (nonatomic, copy) void (^callback)(UIImage *img);

- (void)getImageInView:(UIView *)view callback:(void (^)(UIImage *img)) callback;

@end
