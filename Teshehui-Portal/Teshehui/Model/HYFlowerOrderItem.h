//
//  HYFlowerOrderItem.h
//  Teshehui
//
//  Created by HYZB on 15/5/23.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HYFlowerOrderItem : NSObject

@property (nonatomic, strong) NSString *productId;
@property (nonatomic, strong) NSString *quantity;
@property (nonatomic, strong) NSString *pictureSmallUrl;
@property (nonatomic, strong) NSString *orderItemId;
@property (nonatomic, strong) NSString *productDesc;
@property (nonatomic, strong) NSString *packingDesc;
@property (nonatomic, strong) NSString *pictureMiddleUrl;
@property (nonatomic, strong) NSString *productName;
@property (nonatomic, strong) NSString *bless;
@property (nonatomic, strong) NSString *productCode;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *points;
@property (nonatomic,strong) NSString *pictureBigUrl;

-(id)initWithJson:(NSDictionary *)json;

@end
