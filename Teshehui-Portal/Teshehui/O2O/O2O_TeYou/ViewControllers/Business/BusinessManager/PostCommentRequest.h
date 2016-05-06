//
//  PostCommentRequest.h
//  Teshehui
//
//  Created by apple_administrator on 15/9/12.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "CQBaseRequest.h"

@interface PostCommentRequest : CQBaseRequest

//@property (nonatomic, strong) NSString       *UserName;
//@property (nonatomic, strong) NSString       *UserId;
//
//@property (nonatomic, strong) NSString       *Stars;    //评论多少颗星
//@property (nonatomic, strong) NSString       *Content;
//@property (nonatomic, strong) NSString       *Photos;  //图片json字符串
//
//@property (nonatomic, strong) NSString       *MerId;
//@property (nonatomic, strong) NSString       *HeadPic;


@property (nonatomic, strong) NSString       *orderId;
@property (nonatomic, strong) NSString       *merId;
@property (nonatomic, assign) NSInteger      orderType;

@property (nonatomic, strong) NSString       *uId;    //评论多少颗星
@property (nonatomic, strong) NSString       *stars;
@property (nonatomic, strong) NSString       *content;  //图片json字符串

@property (nonatomic, strong) NSString       *userName;
@property (nonatomic, strong) NSString       *headPic;

@property (nonatomic, strong) NSArray       *photos;

@end
