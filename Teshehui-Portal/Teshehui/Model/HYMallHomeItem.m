//
//  HYMallHomeItem.m
//  Teshehui
//
//  Created by HYZB on 15/5/7.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYMallHomeItem.h"
#import "NSString+Addition.h"

@interface HYMallHomeItem ()

@end

@implementation HYMallHomeItem

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

- (id)initWithDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)err
{
    self = [super initWithDictionary:dict error:err];
    if (self)
    {
        if ([self.type isEqualToString:@"01"])
        {
            self.itemType = MallHomeItemGoods;
        }
        else if ([self.type isEqualToString:@"02"])
        {
            self.itemType = MallHomeItemActive;
        }
        else if ([self.type isEqualToString:@"03"])
        {
            self.itemType = MallHomeItemStore;
        }
        else if ([self.type isEqualToString:@"04"])
        {
            self.itemType = MallHomeItemCategory;
        }
        else if ([self.type isEqualToString:@"05"])
        {
            self.itemType = MallHomeItemBrand;
        }
        else if ([self.type isEqualToString:@"06"])
        {
            self.itemType = MallHomeItemSearch;
        }
        else if ([self.type isEqualToString:@"07"])
        {
            self.itemType = MallHomeItemWeb;
        }
        else if ([self.type isEqualToString:@"08"])
        {
            self.itemType = MallHomeItemNew;
        }
        else if ([self.type isEqualToString:@"09"])
        {
            self.itemType = MallHomeItemHot;
        }
        else if ([self.type isEqualToString:@"10"])
        {
            self.itemType = MallHomeItemShowHands;
        }
        else if ([self.type isEqualToString:@"11"])
        {
            self.itemType = MallHomeItemChannel;
        }
        else if ([self.type isEqualToString:@"12"])
        {
            self.itemType = MallHomeItemSeckill;
        }
        else if ([self.type isEqualToString:@"13"])
        {
            self.itemType = MallHomeItemEarnTicket;
        }
        
        NSDictionary *dic = [self.url urlParamToDic];
        self.productId = [dic objectForKey:@"productId"];
        self.channelCode = [dic objectForKey:@"channelCode"];
    }
    
    return self;
}

@end
