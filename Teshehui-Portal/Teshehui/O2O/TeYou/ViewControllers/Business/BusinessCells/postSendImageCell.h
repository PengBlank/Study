//
//  postSendImageCell.h
//  TTClub
//
//  Created by xkun on 15/4/28.
//  Copyright (c) 2015年 熙文 张. All rights reserved.
//

#define kCCellIdentifier_TweetSendImage @"TweetSendImageCCell"

#import <UIKit/UIKit.h>
#import "CommentInfo.h"
@interface postSendImageCell : UICollectionViewCell

@property (strong, nonatomic) UILabel       *addLabel;
@property (strong, nonatomic) UIImageView *imgView;
@property (strong, nonatomic) UIButton *deleteBtn;
@property (strong, nonatomic) TweetImage *curTweetImg;
@property (copy, nonatomic) void (^deleteTweetImageBlock)(TweetImage *toDelete);
+(CGSize)ccellSize;

@end
