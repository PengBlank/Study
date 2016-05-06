//
//  CommentListRequest.h
//  Teshehui
//
//  Created by apple_administrator on 15/9/12.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "CQBaseRequest.h"

@interface CommentListRequest : CQBaseRequest
@property (nonatomic, strong) NSString       *MerId;
@property (nonatomic, assign) NSInteger      PageIndex;
@property (nonatomic, assign) NSInteger      PageSize;
@property (nonatomic, assign) NSInteger      Type;
@property (nonatomic, strong) NSString       *UserId;
@end
