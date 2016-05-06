//
//  HYPolicyType.h
//  Teshehui
//
//  Created by Kris on 15/11/11.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "JSONModel.h"

@protocol  HYPolicyType<NSObject>
@end

@interface HYPolicyType : JSONModel

@property (nonatomic, copy) NSString *insuranceTypeCode;
@property (nonatomic, copy) NSString *insuranceTypeName;
@property (nonatomic, copy) NSString *insuranceTypeDescription;
@property (nonatomic, copy) NSString *insuranceProvision;
@property (nonatomic, copy) NSString *status;

@end
