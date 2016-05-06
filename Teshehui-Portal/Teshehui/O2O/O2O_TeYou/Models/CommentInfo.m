//
//  CommentInfo.m
//  Teshehui
//
//  Created by apple_administrator on 15/9/10.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "CommentInfo.h"

@implementation CommentInfo
- (instancetype)init
{
    self = [super init];
    if (self) {
        _tweetImages = [NSMutableArray array];
    }
    return self;
}
@end

@implementation TweetImage
+ (instancetype)tweetImageWithImage:(UIImage *)image{
    TweetImage *tweetImg = [[TweetImage alloc] init];
    tweetImg.image = image;
    tweetImg.uploadState = TweetImageUploadStateInit;
    return tweetImg;
}

@end

@implementation CommentPhotoInfo



@end