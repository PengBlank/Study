//
//  HYProductDetailGuessYouLikeResponse.h
//  Teshehui
//
//  Created by Kris on 16/4/11.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "CQBaseResponse.h"
#import "HYMallGuessYouLikeModel.h"

@interface HYProductDetailGuessYouLikeResponse : CQBaseResponse

@property (nonatomic, copy) NSArray <HYMallGuessYouLikeModel *> *dataList;

@end
