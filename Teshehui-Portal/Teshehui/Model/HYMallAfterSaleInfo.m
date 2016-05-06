//
//  HYMallAfterSaleInfo.m
//  Teshehui
//
//  Created by 成才 向 on 15/10/12.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYMallAfterSaleInfo.h"

@implementation HYMallAfterSaleInfo

+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

+ (JSONKeyMapper *)keyMapper
{
    
    return [[JSONKeyMapper alloc] initWithJSONToModelBlock:^NSString *(NSString *keyName)
    {
                return keyName;
    } modelToJSONBlock:^NSString *(NSString *keyName) {
        if ([keyName isEqualToString:@"detailInfo"])
        {
            return @"mallReturnFlowDetailDTOList";
        }
        return keyName;
    }];
}

- (HYMallAfterSaleDetailInfo<Ignore> *)useDetail
{
    HYMallAfterSaleDetailInfo *detail = nil;
    if (self.detailInfo.count > 0)
    {
        detail = [self.detailInfo objectAtIndex:0];
    }
    return detail;
}

@end
