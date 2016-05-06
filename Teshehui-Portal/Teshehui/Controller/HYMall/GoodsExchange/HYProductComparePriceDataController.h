//
//  HYProductComparePriceDataController.h
//  Teshehui
//
//  Created by Kris on 16/2/25.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ComparePriceData)(id data);

@interface HYProductComparePriceDataController : NSObject

//for the time being,the param is setted for this bad design of last detail controller
@property (nonatomic, copy) NSString *productId;

- (void)fetchComparePriceDataWithBlock:(ComparePriceData)block;

@end
