//
//  UIAlertView+HYShowMessage.m
//  Teshehui
//
//  Created by 成才 向 on 16/1/5.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "UIAlertView+HYShowMessage.h"

@implementation UIAlertView (HYShowMessage)

+ (void)showMessage:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}

@end
