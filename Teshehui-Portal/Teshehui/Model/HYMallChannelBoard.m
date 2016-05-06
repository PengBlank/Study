//
//  HYMallChannelBoard.m
//  Teshehui
//
//  Created by 成才 向 on 15/10/12.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYMallChannelBoard.h"

@implementation HYMallChannelBoard

- (HYMallChannelBoardType)boardType
{
//    if ([self.channelBoardCode isEqualToString:@"01"])
//    {
//        
//    }
    return (HYMallChannelBoardType)self.channelBoardCode.integerValue;
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end
