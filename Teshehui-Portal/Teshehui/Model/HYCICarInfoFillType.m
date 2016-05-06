//
//  HYCICarInfoFillType.m
//  Teshehui
//
//  Created by HYZB on 15/7/3.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYCICarInfoFillType.h"
#import "JSONKit_HY.h"

@implementation HYCICarInfoValue

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

@end

@implementation HYCICarInfoRangeValue

+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end

@implementation HYCICarInfoFillType

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}


- (NSArray *)inputValueList
{
    NSArray *valueList = nil;
    if ([self.selectValueList count] > 0)
    {
        NSMutableArray *tempArr = [[NSMutableArray alloc] init];
        for (HYCICarInfoValue *value in self.selectValueList)
        {
            [tempArr addObject:value.value];
        }
        
        valueList = [tempArr copy];
    }
    
    return valueList;
}
- (NSArray *)inputKeyList
{
    NSArray *keyList = nil;
    if ([self.selectValueList count] > 0)
    {
        NSMutableArray *tempArr = [[NSMutableArray alloc] init];
        for (HYCICarInfoValue *value in self.selectValueList)
        {
            [tempArr addObject:value.key];
        }
        
        keyList = [tempArr copy];
    }
    
    return keyList;
}

@end
