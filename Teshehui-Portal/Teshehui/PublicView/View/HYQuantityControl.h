//
//  HYQuantityControl.h
//  Teshehui
//
//  Created by HYZB on 15/9/1.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HYQuantityControl : UIControl

@property (nonatomic, assign) NSUInteger quantity;
@property (nonatomic, assign) NSUInteger minQuantity;

- (void)setEnabledAdd:(BOOL)enabled;
- (void)setEnabledMinus:(BOOL)enabled;

@end
