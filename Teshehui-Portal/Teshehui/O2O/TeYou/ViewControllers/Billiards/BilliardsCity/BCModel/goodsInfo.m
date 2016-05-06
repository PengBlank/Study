//
//  goodsInfo.m
//  zuoqiu
//
//  Created by apple_administrator on 15/11/6.
//  Copyright © 2015年 teshehui. All rights reserved.
//

#import "goodsInfo.h"

@implementation goodsInfo

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.productName forKey:@"productName"];
    [aCoder encodeInteger:self.buyAmount forKey:@"buyAmount"];
    [aCoder encodeObject:self.productCash forKey:@"productCash"];
    [aCoder encodeObject:self.productCoupon forKey:@"productCoupon"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self == [super init]) {
        self.productName = [aDecoder decodeObjectForKey:@"productName"];
        self.buyAmount = [aDecoder decodeIntegerForKey:@"buyAmount"];
        self.productCash = [aDecoder decodeObjectForKey:@"productCash"];
        self.productCoupon = [aDecoder decodeObjectForKey:@"productCoupon"];
    }
    
    return self;
}

@end
