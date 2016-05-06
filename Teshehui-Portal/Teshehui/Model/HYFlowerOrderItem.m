//
//  HYFlowerOrderItem.m
//  Teshehui
//
//  Created by HYZB on 15/5/23.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYFlowerOrderItem.h"

@implementation HYFlowerOrderItem

-(id)initWithJson:(NSDictionary *)json;
{
    self = [super init];
    if(self)
    {
        if(json != nil)
        {
            self.productId  = [json objectForKey:@"productId"];
            self.quantity  = [json objectForKey:@"quantity"];
            self.pictureSmallUrl  = [json objectForKey:@"pictureSmallUrl"];
            self.orderItemId  = [json objectForKey:@"orderItemId"];
            self.productDesc  = [json objectForKey:@"productDesc"];
            self.packingDesc  = [json objectForKey:@"packingDesc"];
            self.pictureMiddleUrl  = [json objectForKey:@"pictureMiddleUrl"];
            self.productName  = [json objectForKey:@"productName"];
            self.bless  = [json objectForKey:@"bless"];
            self.productCode  = [json objectForKey:@"productCode"];
            self.price  = [json objectForKey:@"price"];
            self.points  = [json objectForKey:@"points"];
            self.pictureBigUrl  = [json objectForKey:@"pictureBigUrl"];
            
        }
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.productId forKey:@"zx_productId"];
    [aCoder encodeObject:self.quantity forKey:@"zx_quantity"];
    [aCoder encodeObject:self.pictureSmallUrl forKey:@"zx_pictureSmallUrl"];
    [aCoder encodeObject:self.orderItemId forKey:@"zx_orderItemId"];
    [aCoder encodeObject:self.productDesc forKey:@"zx_productDesc"];
    [aCoder encodeObject:self.packingDesc forKey:@"zx_packingDesc"];
    [aCoder encodeObject:self.pictureMiddleUrl forKey:@"zx_pictureMiddleUrl"];
    [aCoder encodeObject:self.productName forKey:@"zx_productName"];
    [aCoder encodeObject:self.bless forKey:@"zx_bless"];
    [aCoder encodeObject:self.productCode forKey:@"zx_productCode"];
    [aCoder encodeObject:self.price forKey:@"zx_price"];
    [aCoder encodeObject:self.pictureBigUrl forKey:@"zx_pictureBigUrl"];
    
}


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if(self)
    {
        self.productId = [aDecoder decodeObjectForKey:@"zx_productId"];
        self.quantity = [aDecoder decodeObjectForKey:@"zx_quantity"];
        self.pictureSmallUrl = [aDecoder decodeObjectForKey:@"zx_pictureSmallUrl"];
        self.orderItemId = [aDecoder decodeObjectForKey:@"zx_orderItemId"];
        self.productDesc = [aDecoder decodeObjectForKey:@"zx_productDesc"];
        self.packingDesc = [aDecoder decodeObjectForKey:@"zx_packingDesc"];
        self.pictureMiddleUrl = [aDecoder decodeObjectForKey:@"zx_pictureMiddleUrl"];
        self.productName = [aDecoder decodeObjectForKey:@"zx_productName"];
        self.bless = [aDecoder decodeObjectForKey:@"zx_bless"];
        self.productCode = [aDecoder decodeObjectForKey:@"zx_productCode"];
        self.price = [aDecoder decodeObjectForKey:@"zx_price"];
        self.pictureBigUrl = [aDecoder decodeObjectForKey:@"zx_pictureBigUrl"];
        
    }
    return self;
}

- (NSString *) description
{
    NSString *result = @"";
    result = [result stringByAppendingFormat:@"productId : %@\n",self.productId];
    result = [result stringByAppendingFormat:@"quantity : %@\n",self.quantity];
    result = [result stringByAppendingFormat:@"pictureSmallUrl : %@\n",self.pictureSmallUrl];
    result = [result stringByAppendingFormat:@"orderItemId : %@\n",self.orderItemId];
    result = [result stringByAppendingFormat:@"productDesc : %@\n",self.productDesc];
    result = [result stringByAppendingFormat:@"packingDesc : %@\n",self.packingDesc];
    result = [result stringByAppendingFormat:@"pictureMiddleUrl : %@\n",self.pictureMiddleUrl];
    result = [result stringByAppendingFormat:@"productName : %@\n",self.productName];
    result = [result stringByAppendingFormat:@"bless : %@\n",self.bless];
    result = [result stringByAppendingFormat:@"productCode : %@\n",self.productCode];
    result = [result stringByAppendingFormat:@"price : %@\n",self.price];
    result = [result stringByAppendingFormat:@"pictureBigUrl : %@\n",self.pictureBigUrl];
    
    return result;
}


@end
