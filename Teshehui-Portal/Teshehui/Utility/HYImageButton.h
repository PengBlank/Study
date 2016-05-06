//
//  HYImageButton.h
//  Teshehui
//
//  Created by 成才 向 on 15/8/7.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    ImageButtonTypeVerticle = 0,
    ImageButtonTypeCustom,
    ImageButtonTypeTitleFirst
} HYImageButtonType;

@interface HYImageButton : UIButton

@property (nonatomic, assign) CGFloat spaceInTestAndImage;

@property (nonatomic, assign) CGPoint imageOrigin;
@property (nonatomic, assign) CGPoint titleOrigin;

@property (nonatomic, assign) HYImageButtonType type;

- (void)setLabelCount:(NSUInteger)count;

@end
