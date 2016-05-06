//
//  PraiseRequest.h
//  Teshehui
//
//  Created by apple_administrator on 15/9/12.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "CQBaseRequest.h"

@interface PraiseRequest : CQBaseRequest

@property (nonatomic,assign) NSInteger      CommentId;
@property (nonatomic,strong) NSString       *UserId;

@end
