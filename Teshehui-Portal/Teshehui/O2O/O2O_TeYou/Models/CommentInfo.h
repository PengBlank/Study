//
//  CommentInfo.h
//  Teshehui
//
//  Created by apple_administrator on 15/9/10.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentInfo : NSObject

@property (nonatomic, assign) NSInteger                 com_id;
@property (nonatomic, assign) NSInteger                 likes;
@property (nonatomic, assign) NSInteger                 is_favorite;
@property (nonatomic, assign) CGFloat                   stars;
@property (nonatomic, strong) NSString                  *content;
@property (nonatomic, strong) NSString                  *createdon;
@property (nonatomic, strong) NSString                  *head_pic;
@property (nonatomic, strong) NSString                  *user_name;

@property (nonatomic, strong) NSMutableArray            *pics;
@property (readwrite, nonatomic, strong) NSMutableArray *tweetImages;

@end


typedef NS_ENUM(NSInteger, TweetImageUploadState)
{
    TweetImageUploadStateInit = 0,
    TweetImageUploadStateIng,
    TweetImageUploadStateSuccess,
    TweetImageUploadStateFail
};

@interface TweetImage : NSObject
@property (readwrite, nonatomic, strong) UIImage *image;
@property (assign, nonatomic) TweetImageUploadState uploadState;
@property (readwrite, nonatomic, strong) NSString *imageStr;

@property (nonatomic,assign) int    postImageID;
@property (nonatomic,assign) int    imageTag;
@property (nonatomic,assign) int    imageW;
@property (nonatomic,assign) int    imageH;

@property (nonatomic,strong) NSString *imageUrl;
@property (nonatomic,strong) NSString *imageDesc;

+ (instancetype)tweetImageWithImage:(UIImage *)image;

@end

@interface CommentPhotoInfo : NSObject
@property (nonatomic, strong) NSString              *ph_id;
@property (nonatomic, strong) NSString              *Url;
@property (nonatomic, strong) NSString              *com_id;
@end