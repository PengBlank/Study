//
//  goodsInfo.h
//  zuoqiu
//
//  Created by apple_administrator on 15/11/6.
//  Copyright © 2015年 teshehui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface goodsInfo : NSObject<NSCoding>

@property (nonatomic,assign) NSInteger buyAmount;
@property (nonatomic,strong) NSString *productName;
@property (nonatomic,strong) NSString *productCash;
@property (nonatomic,strong) NSString *productCoupon;
@property (nonatomic,strong) NSString *salePrice;
@property (nonatomic,strong) NSString *gid;

@end
