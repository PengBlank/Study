//
//  UIView+ScreenTransform.m
//  Teshehui
//
//  Created by apple on 15/3/10.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "UIView+ScreenTransform.h"

@implementation UIView (ScreenTransform)

- (void)transformSubviewFrame:(BOOL)includeself
{
    if (includeself) {
        self.frame = TFREctMakeWithRect(self.frame);
    }
    for (UIView *view in self.subviews)
    {
        [view transformSubviewFrame:YES];
    }
}

@end
