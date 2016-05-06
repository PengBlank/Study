//
//  HYMallReturnsProgress.h
//  Teshehui
//
//  Created by HYZB on 14-9-19.
//  Copyright (c) 2014年 Shady Elyaski. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HYMallReturnsProgress : UIView

-(id) initWithFrame:(CGRect) frame stepTitles:(NSArray *) stepTitles;

@property (nonatomic, strong) UIColor *titleNormalColor;
@property (nonatomic, strong) UIColor *titleSelectColor;
@property (nonatomic, strong) UIColor *progressBgColor;
@property (nonatomic, strong) UIColor *progressColor;
@property (nonatomic, assign) NSInteger currStep;  //当前步骤

@end
