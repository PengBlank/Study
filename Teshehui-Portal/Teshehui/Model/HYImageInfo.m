//
//  HYImageInfo.m
//  Teshehui
//
//  Created by HYZB on 15/5/27.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYImageInfo.h"

@implementation HYImageInfo

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

- (NSString *)defaultURL
{
    return [NSString stringWithFormat:@"%@%@", self.imageUrl, self.imageFileType];
}

@end
