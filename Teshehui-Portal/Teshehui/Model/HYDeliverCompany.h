//
//  HYDeliverCompany.h
//  Teshehui
//
//  Created by 成才 向 on 15/10/21.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "JSONModel.h"

@interface HYDeliverCompany : JSONModel

@property (nonatomic, copy) NSString *deliveryName;
@property (nonatomic, copy) NSString *deliveryCode;
@property (nonatomic, copy) NSString *url;

@end
