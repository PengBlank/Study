//
//  HYMallAfterSaleDetailInfo.m
//  Teshehui
//
//  Created by 成才 向 on 15/10/12.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYMallAfterSaleDetailInfo.h"

@implementation HYMallAfterSaleDetailInfo

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithJSONToModelBlock:^NSString *(NSString *keyName) {
        return keyName;
    } modelToJSONBlock:^NSString *(NSString *keyName){
        if ([keyName isEqualToString:@"proof"]) {
            return @"mallReturnProofPOList";
        }
        if ([keyName isEqualToString:@"deliverItems"]) {
            return @"mallReturnDeliveryPOList";
        }
        return keyName;
    }];
}

- (HYMallAfterSaleProof<Ignore> *)useProof
{
    if (self.proof.count > 0)
    {
        return [self.proof objectAtIndex:0];
    }
    return nil;
}

- (HYMallAfterSaleDeliver<Ignore> *)userDeliver
{
    if (self.deliverItems.count > 0)
    {
        return [self.deliverItems objectAtIndex:0];
    }
    return nil;
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end
