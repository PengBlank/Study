//
//  O2OShareInfoRequest.h
//  Teshehui
//
//  Created by apple_administrator on 15/12/1.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "CQBaseRequest.h"

@interface O2OShareInfoRequest : CQBaseRequest

@property (nonatomic, strong) NSString  *type  ;
@property (nonatomic, strong) NSString  *price;
@property (nonatomic, strong) NSString  *uId  ;
@property (nonatomic, strong) NSString  *merchantId;

@end
