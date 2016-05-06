//
//  HYMallSearchGoodInfo.m
//  Teshehui
//
//  Created by ichina on 14-2-24.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYMallSearchGoodInfo.h"
#import "HYFlowerSummaryInfo.h"

@implementation HYMallSearchGoodInfo

+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

- (id)initWithDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)err
{
    NSMutableDictionary *tempdec = [[NSMutableDictionary alloc]initWithDictionary:dict];
    NSDictionary *expand = [dict objectForKey:@"expandedResponse"];
    if (expand && ![expand isEqual:[NSNull null]])
    {
        [tempdec addEntriesFromDictionary:expand];
        [tempdec removeObjectForKey:@"expandedResponse"];
    }
    
    if ([tempdec objectForKey:@"flowerLanguage"])
    {
        self = (HYMallSearchGoodInfo *)[[HYFlowerSummaryInfo alloc] initWithDictionary:tempdec
                                                                                 error:err];
    }
    else
    {
        self = [super initWithDictionary:dict
                                   error:err];
    }
    return self;
}

@end
