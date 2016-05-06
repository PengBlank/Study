//
//  HYTextField.h
//  Teshehui
//
//  Created by 回亿资本 on 14-3-20.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYStrokeField.h"

@interface HYSpaceTextField : HYStrokeField

@property(nonatomic, assign) BOOL autoSpace;

@property (nonatomic, readonly) NSString *noSpaceText;

@end
