//
//  HYMallChannelItem.m
//  Teshehui
//
//  Created by 成才 向 on 15/10/12.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYMallChannelItem.h"
#import "NSString+Addition.h"

@implementation HYMallChannelItem

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

- (id)initWithDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)err
{
    self = [super initWithDictionary:dict error:err];
    if (self)
    {
        if ([self.bannerType isEqualToString:@"01"])
        {
            self.itemType = MallHomeItemGoods;
        }
        else if ([self.bannerType isEqualToString:@"02"])
        {
            self.itemType = MallHomeItemActive;
        }
        else if ([self.bannerType isEqualToString:@"03"])
        {
            self.itemType = MallHomeItemStore;
        }
        else if ([self.bannerType isEqualToString:@"04"])
        {
            self.itemType = MallHomeItemCategory;
        }
        else if ([self.bannerType isEqualToString:@"05"])
        {
            self.itemType = MallHomeItemBrand;
        }
        else if ([self.bannerType isEqualToString:@"06"])
        {
            self.itemType = MallHomeItemSearch;
        }
        else if ([self.bannerType isEqualToString:@"07"])
        {
            self.itemType = MallHomeItemWeb;
        }
        else if ([self.bannerType isEqualToString:@"08"])
        {
            self.itemType = MallHomeItemNew;
        }
        else if ([self.bannerType isEqualToString:@"09"])
        {
            self.itemType = MallHomeItemHot;
        }
        else if ([self.bannerType isEqualToString:@"10"])
        {
            self.itemType = MallHomeItemShowHands;
        }
        else if ([self.bannerType isEqualToString:@"11"])
        {
            self.itemType = MallHomeItemChannel;
        }
        else
        {
            self.itemType = MallHomeItemUnknown;
        }
        
        NSDictionary *dic = [self.url urlParamToDic];
        self.productId = [dic objectForKey:@"productId"];
    }
    
    return self;
}

- (HYMallChannelBoardType)boardType
{
    //    if ([self.channelBoardCode isEqualToString:@"01"])
    //    {
    //
    //    }
    return (HYMallChannelBoardType)self.boardCode.integerValue;
}


@end
