//
//  HYMallGoodsDetail.m
//  Teshehui
//
//  Created by HYZB on 15/5/9.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYMallGoodsDetail.h"

@interface HYMallGoodsDetail ()

@property (nonatomic, strong) NSArray *bigImgList;
@property (nonatomic, strong) NSArray *midImgList;
@property (nonatomic, strong) NSArray *smallImgList;
@property (nonatomic, assign) CGFloat attributeHeigth;
@property (nonatomic, strong) NSArray *attribute1List;

@end

@implementation HYMallGoodsDetail

- (void)setCurrentSKUWithSKUId:(NSString *)skuId
{
    if (skuId != _currentsSUK.productSKUId)
    {
        for (HYProductSKU *sku in self.productSKUArray)
        {
            if ([sku.productSKUId isEqualToString:skuId])
            {
                self.currentsSUK = sku;
                break;
            }
        }
        
        /*
         *找到界面对应的索引
         */
        NSInteger index1 = 0;
        for (HYProductSKU *sku in self.attribute1List)
        {
            if ([self.currentsSUK.attributeValue1 isEqualToString:sku.attributeValue1])
            {
                self.selectAtt1Index = index1;
                break;
            }
            
            index1++;
        }
        
        NSInteger index2 = 0;
        NSArray *att2 = [self attributeWithId:self.currentsSUK.attributeValue1];
        for (HYProductSKU *sku2 in att2)
        {
            if ([self.currentsSUK.attributeValue2 isEqualToString:sku2.attributeValue2])
            {
                self.selectAtt2Index = index2;
                break;
            }
            
            index2++;
        }
    }
}

- (id)initWithDictionary:(NSDictionary *)dict
{
    NSMutableDictionary *tempdec = [[NSMutableDictionary alloc]initWithDictionary:dict];
    NSDictionary *expand = [dict objectForKey:@"expandedResponse"];
    [tempdec addEntriesFromDictionary:expand];
    [tempdec removeObjectForKey:@"expandedResponse"];
    
    NSError *error = nil;
    self = [self initWithDictionary:tempdec error:&error];
    
    if (self)
    {
        NSMutableArray *bigList = [[NSMutableArray alloc] init];
        NSMutableArray *midList = [[NSMutableArray alloc] init];
        NSMutableArray *smallList = [[NSMutableArray alloc] init];
        
        for (HYProductSKU *sku in self.productSKUArray)
        {
            for (HYImageInfo *image in sku.productSKUImagArray)
            {
                NSString *bigUrl = [NSString stringWithFormat:@"%@_%@", image.imageUrl, ImageSizeBig];
                NSString *midUrl = [NSString stringWithFormat:@"%@_%@", image.imageUrl, ImageSizeMid];
                NSString *smallUrl = [NSString stringWithFormat:@"%@_%@", image.imageUrl, ImageSizeSmall];
                [bigList addObject:bigUrl];
                [midList addObject:midUrl];
                [smallList addObject:smallUrl];
            }
        }
        
        self.bigImgList = [bigList copy];
        self.midImgList = [midList copy];
        self.smallImgList = [smallList copy];
        
        //设置默认sku
        NSInteger index = 0;
        BOOL getMajor = NO;
        for (HYProductSKU *sku in self.attribute1List)
        {
            NSArray *attr2 = [self attributeWithId:sku.attributeValue1];
            for (int i = 0; i < attr2.count; i++)
            {
                HYProductSKU *sku2 = [attr2 objectAtIndex:i];
                if (sku2.isMajor)
                {
                    self.currentsSUK = sku2;
                    self.selectAtt1Index = index;
                    self.selectAtt2Index = i;
                    getMajor = YES;
                    break;
                }
            }
            if (getMajor) {
                break;
            }
            index++;
        }
        
        //设置选中项
        if (!self.selectAtt2Index && self.currentsSUK)
        {
            NSArray *attributeList = [self attributeWithId:self.currentsSUK.attributeValue1];
            for (int index=0; index<[attributeList count]; index++)
            {
                HYProductSKU *sku = [attributeList objectAtIndex:index];
                if ([sku.attributeValue2 isEqualToString:self.currentsSUK.attributeValue2])
                {
                    self.selectAtt2Index = index;
                    break;
                }
            }
        }
    }
    
    return self;
}

//- (void)setCurrentsSUK:(HYProductSKU *)currentsSUK
//{
//    if (currentsSUK != _currentsSUK)
//    {
//        
//    }
//}
//
- (NSArray *)attribute1List
{
    if (!_attribute1List)
    {
        NSMutableArray *tempArr = [[NSMutableArray alloc] init];
        NSMutableSet *attribute1Set = [[NSMutableSet alloc] init];
        
        for (HYProductSKU *sku in self.productSKUArray)
        {
            if (sku.attributeValue1 && ![attribute1Set containsObject:sku.attributeValue1])
            {
                [attribute1Set addObject:sku.attributeValue1];
                [tempArr addObject:sku];
            }
        }
        
        if ([tempArr count] > 0)
        {
            //如果没有主sku
            if (!self.currentsSUK)
            {
                self.currentsSUK = [tempArr objectAtIndex:0];
                self.selectAtt1Index = 0;
                self.selectAtt2Index = 0;
            }
            
            _attribute1List = [tempArr copy];
        }
    }
    
    return _attribute1List;
}

- (NSArray *)attributeWithId:(NSString *)attributeId
{
    NSMutableArray *attributeList = [[NSMutableArray alloc] init];

    for (HYProductSKU *sku in self.productSKUArray)
    {
        if ([sku.attributeValue1 isEqualToString:attributeId])
        {
            [attributeList addObject:sku];
        }
    }
    
    if ([attributeList count] > 0)
    {
        //如果没有主sku
        if (!self.currentsSUK)
        {
            self.currentsSUK = [attributeList objectAtIndex:0];
        }
        
        return [attributeList copy];
    }
    
    return nil;
}

- (CGFloat)attributeHeigth
{
    if (_attributeHeigth<=0 && [self.attribute1List count]>0)
    {
        CGFloat oirg_y = 0;
        CGFloat oirg_x = 0;
        
        CGFloat height = 36;
        _attributeHeigth = 0;
        for (HYProductSKU *item in self.attribute1List)
        {
            if ([item.attributeValue1 length] > 0)
            {
                CGSize size = [item.attributeValue1 sizeWithFont:[UIFont systemFontOfSize:14]
                                    constrainedToSize:CGSizeMake((ScreenRect.size.width-70), 20)];
                
                size.width = (size.width < 30) ? 60 : (size.width+30);
                
                if ((oirg_x+(size.width+12)) > (ScreenRect.size.width-40))
                {
                    oirg_x = 0;
                    oirg_y += 34;
                }
                
                oirg_x += (size.width+12);
            }
        }
        
        _attributeHeigth += (oirg_y+height);
        
        if (self.selectAtt1Index < [self.attribute1List count])
        {
            HYProductSKU *sku = [self.attribute1List objectAtIndex:self.selectAtt1Index];
            NSArray *array = [self attributeWithId:sku.attributeValue1];
            
            if ([array count] > 0)
            {
                oirg_x = 0;
                oirg_y = 0;
                for (HYProductSKU *item in array)
                {
                    if ([item.attributeValue2 length] > 0)
                    {
                        CGSize size = [item.attributeValue2 sizeWithFont:[UIFont systemFontOfSize:14]
                                            constrainedToSize:CGSizeMake((ScreenRect.size.width-70), 20)];
                        size.width = (size.width < 30) ? 60 : (size.width+30);
                        
                        if ((oirg_x+(size.width+12)) > (ScreenRect.size.width-40))
                        {
                            oirg_x = 0;
                            oirg_y += 34;
                        }
                        
                        oirg_x += (size.width+12);
                    }
                }
                
                _attributeHeigth += (oirg_y+height);
            }
        }
        
        _attributeHeigth += 20;
    }
    else if (_attributeHeigth <= 0)
    {
        _attributeHeigth += 20;
    }
    
    return _attributeHeigth;
}

- (NSString *)discount
{
    if (!_discount && [_discount length] <= 0)
    {
        _discount = @"0";
    }
    
    return _discount;
}

- (NSString *)favorCount
{
    if (!_favorCount && [_favorCount length] <= 0)
    {
        _favorCount = @"0";
    }
    
    return _favorCount;
}
- (NSString *)skuDesc
{
    NSString *skuDesc = nil;
    if ([self.attributeName1 length] && [self.currentsSUK.attributeValue1 length])
    {
        skuDesc = [NSString stringWithFormat:@"%@: %@", self.attributeName1, self.currentsSUK.attributeValue1];
    }
    
    if ([self.attributeName2 length] && [self.currentsSUK.attributeValue2 length])
    {
        skuDesc = [NSString stringWithFormat:@"%@ %@: %@", skuDesc, self.attributeName2, self.currentsSUK.attributeValue2];
    }
    
    return skuDesc;
}
@end
