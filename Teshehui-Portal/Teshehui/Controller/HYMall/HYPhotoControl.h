//
//  HYPhotoControl.h
//  Teshehui
//
//  Created by RayXiang on 14-9-17.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HYPhotoControl : UIView

@property (nonatomic, strong) UIImage *normalImage;
@property (nonatomic, strong) UIImage *photo;

- (void)addTargetForTouchAction:(id)target action:(SEL)action;
- (void)addTargetForDeleteAction:(id)target action:(SEL)action;

@property (nonatomic, assign) NSInteger idx;

@property (nonatomic, assign) BOOL enable;

@end
