//
//  HYProductDetailGuessYouLikeReq.h
//  Teshehui
//
//  Created by Kris on 16/4/11.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "CQBaseRequest.h"

@interface HYProductDetailGuessYouLikeReq : CQBaseRequest

@property (nonatomic, copy) NSString *productCode;
@property (nonatomic, copy) NSString *categoryCode;
@property (nonatomic, copy) NSString *brandCode;
@property (nonatomic, copy) NSString *maxRows;
@property (nonatomic, copy) NSString *recType;

@end
