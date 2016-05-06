//
//  HYPhoneChargeModel.h
//  Teshehui
//
//  Created by Kris on 16/3/1.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "JSONModel.h"

@interface HYPhoneChargeModel : JSONModel

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *area;
@property (nonatomic, copy) NSString *parvalue;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *productCode;

@end
