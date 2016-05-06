//
//  HYExpensiveExplainResponse.m
//  Teshehui
//
//  Created by apple on 15/4/7.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYExpensiveExplainResponse.h"

@implementation HYExpensiveExplainResponse

- (id)initWithJsonDictionary:(NSDictionary *)dictionary
{
    if (self = [super initWithJsonDictionary:dictionary])
    {
        NSDictionary *info = GETOBJECTFORKEY(dictionary, @"data", NSDictionary);
        self.expensiveInfo = [[HYExpensiveInfo alloc] initWithDictionary:info error:nil];
        [self.expensiveInfo setShared];
    }
    return self;
}




@end

static HYExpensiveInfo *__sharedInfo;

@implementation HYExpensiveInfo

+ (instancetype)sharedInfo
{
    return __sharedInfo;
}

- (void)setShared
{
    __sharedInfo = self;
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}         

#pragma mark getter and setter
- (NSString *)img_key1
{
    if (self.guijiupei)
    {
        return _guijiupei;
    }else if (self.fake)
    {
        return _fake;
    }else if (self.lightning)
    {
        return _lightning;
    }else
    {
        return _guarantee;
    }
}

@end
