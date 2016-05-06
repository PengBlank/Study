//
//  HYUserVirutalAccountInfo.h
//  Teshehui
//
//  Created by 成才 向 on 15/8/24.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "JSONModel.h"

@interface HYUserVirutalAccountInfo : JSONModel

@property (nonatomic, strong) NSString *balanceId;
@property (nonatomic, strong) NSString *accountType;
@property (nonatomic, strong) NSString *accountTypeName;
@property (nonatomic, strong) NSString *balance;
@property (nonatomic, strong) NSString *accountId;
//@property (nonatomic, strong) NSString *userId;

@end
