//
//  CheckUserCommentRequest.h
//  Teshehui
//
//  Created by apple_administrator on 15/9/14.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "CQBaseRequest.h"

@interface CheckUserCommentRequest : CQBaseRequest

@property (nonatomic,strong) NSString   *MerId;
@property (nonatomic,strong) NSString   *UserId;

@end
