//
//  HYCarOwnerInfo.h
//  Teshehui
//
//  Created by 成才 向 on 15/7/13.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "JSONModel.h"
#import "HYCIOwnerInfo.h"

@interface HYCIPersonInfo : JSONModel

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *idCardNo;
@property (nonatomic, strong) NSString * mobilephone;
@property (nonatomic, strong) NSString *email;

- (void)setWithOwnerInfo:(HYCIOwnerInfo *)ownerInfo;
- (void)clearInfo;
- (NSString *)checkErrorDomain;

@end
