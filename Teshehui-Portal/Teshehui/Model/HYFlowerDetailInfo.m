//
//  HYFlowerDetailInfo.m
//  Teshehui
//
//  Created by ichina on 14-2-15.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYFlowerDetailInfo.h"

@interface HYFlowerDetailInfo ()

@property (nonatomic, strong) NSArray *bigImgList;
@property (nonatomic, strong) NSArray *midImgList;
@property (nonatomic, strong) NSArray *smallImgList;
@property (nonatomic, assign) CGFloat attributeHeigth;

@end

@implementation HYFlowerDetailInfo

- (id)initWithDictionary:(NSDictionary *)dict
{
    NSMutableDictionary *tempdec = [[NSMutableDictionary alloc]initWithDictionary:dict];
    NSDictionary *expand = [dict objectForKey:@"expandedResponse"];
    [tempdec addEntriesFromDictionary:expand];
    [tempdec removeObjectForKey:@"expandedResponse"];
    
    NSError *error = nil;
    self = [super initWithDictionary:tempdec error:&error];
    
    if (self)
    {
        NSMutableArray *bigList = [[NSMutableArray alloc] init];
        NSMutableArray *midList = [[NSMutableArray alloc] init];
        NSMutableArray *smallList = [[NSMutableArray alloc] init];
        
        for (HYProductSKU *sku in self.productSKUArray)
        {
            for (HYImageInfo *image in sku.productSKUImagArray)
            {
                if (image.imageUrl)
                {
                    [bigList addObject:image.imageUrl];
                    [midList addObject:image.imageUrl];
                    [smallList addObject:image.imageUrl];
                }
            }
            
            if ([sku.marketPrice length] > 0)
            {
                self.marketPrice = sku.marketPrice;
            }
            if ([sku.price length] > 0)
            {
                self.price = sku.price;
            }
            if ([sku.points length] > 0)
            {
                self.points = sku.points;
            }
        }
        self.flowerDescription = GETOBJECTFORKEY(expand, @"flowerDescription", [NSString class]);
        self.flowerLanguage = GETOBJECTFORKEY(expand, @"flowerLanguage", [NSString class]);
        self.flowerPicUrl = GETOBJECTFORKEY(expand, @"flowerPicUrl", [NSString class]);
        
        self.bigImgList = [bigList copy];
        self.midImgList = [midList copy];
        self.smallImgList = [smallList copy];
        
        self.currentsSUK = [self.productSKUArray lastObject];
    }
    
    return self;
}


@end
