//
//  HYHYMallCartProduct.m
//  Teshehui
//
//  Created by HYZB on 15/5/11.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYMallCartProduct.h"

@implementation HYMallCartProduct

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

- (id)initWithDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)err
{
    self = [super initWithDictionary:dict error:err];
    if (self)
    {
        self.isSelect = YES;
    }
    
    return self;
}

@end
