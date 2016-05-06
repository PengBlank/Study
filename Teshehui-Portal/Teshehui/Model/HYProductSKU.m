//
//  HYMallGoodsSKU.m
//  Teshehui
//
//  Created by HYZB on 15/5/9.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYProductSKU.h"
#import "NSString+Addition.h"

@implementation HYProductSKU

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

- (id)initWithDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)err
{
    self = [super initWithDictionary:dict error:err];
    if (self)
    {
        [self sortSKUImagArray];
    }
    
    return self;
}

- (NSUInteger)quantity
{
    if (!_quantity)
    {
        _quantity = 1;
    }
    
    return _quantity;
}

- (NSString *)totalPoint
{
    if (!_totalPoint)
    {
        NSNumber *pNumber = [NSNumber numberWithDouble:self.points.doubleValue*self.quantity];
        _totalPoint = pNumber.stringValue;
    }
    
    return _totalPoint;
}

- (NSString *)totalPrice
{
    if (!_totalPrice)
    {
        NSString *quantityStr = [NSString stringWithFormat:@"%d",(int)self.quantity];
        _totalPrice = [self.price stringDecimalByMultiplyingBy:quantityStr];
    }
    
    return _totalPrice;
}

- (NSString *)totalMarketPrice
{
    NSString *quantityStr = [NSString stringWithFormat:@"%d",(int)self.quantity];
    return [self.marketPrice stringDecimalByMultiplyingBy:quantityStr];
}

- (NSString *)discountRate
{
    if (!_discountRate)
    {
        _discountRate = [NSString stringWithFormat:@"%0.1f", (self.price.floatValue/self.marketPrice.floatValue)*10];
    }
    
    return _discountRate;
}

- (void)sortSKUImagArray
{
    if (self.productSKUImagArray)
    {
        self.productSKUImagArray = [self.productSKUImagArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            HYImageInfo *img1 = (HYImageInfo *)obj1;
            HYImageInfo *img2 = (HYImageInfo *)obj2;
            return img1.index > img2.index;
        }];
    }
}
@end