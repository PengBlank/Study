//
//  HYMallExpressItem.m
//  Teshehui
//
//  Created by Kris on 15/10/17.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYMallExpressItem.h"

@implementation HYMallExpressItem

+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

- (CGFloat)contentHeight
{
    if (_contentHeight <= 0)
    {
        CGSize size = [self.context sizeWithFont:[UIFont systemFontOfSize:14]
                           constrainedToSize:CGSizeMake(280, 100)
                               lineBreakMode:NSLineBreakByCharWrapping];
        _contentHeight = size.height;
    }
    
    return _contentHeight;
}

@end
