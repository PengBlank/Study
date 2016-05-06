//
//  HYCommentAddOneStepResponse.h
//  Teshehui
//
//  Created by HYZB on 15/10/17.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "CQBaseResponse.h"
#import "HYCommentAddOneStepModel.h"

@interface HYCommentAddOneStepResponse : CQBaseResponse

@property (nonatomic, copy) NSArray *dataList;
@property (nonatomic, assign) NSInteger totalCount;

@end
