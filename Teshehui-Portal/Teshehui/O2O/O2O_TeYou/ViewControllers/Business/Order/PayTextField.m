//
//  PayTextField.m
//  Teshehui
//
//  Created by apple_administrator on 16/1/15.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "PayTextField.h"

@implementation PayTextField

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender  // 禁止粘贴、全选功能
{
    if (action == @selector(cut:))
        return NO;
    if (action == @selector(copy:))
        return NO;
    if (action == @selector(paste:))
        return NO;
    if (action == @selector(select:))
        return NO;
    if (action == @selector(selectAll:))
        return NO;
    return [super canPerformAction:action withSender:sender];
}

@end
