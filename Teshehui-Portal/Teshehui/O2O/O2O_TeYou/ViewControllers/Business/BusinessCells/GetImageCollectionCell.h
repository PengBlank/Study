//
//  GetImageCollectionCell.h
//  Teshehui
//
//  Created by macmini5 on 15/11/20.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

/**
 查看评论页面－图片cell内嵌的CollectionViewCell
 **/

#import <UIKit/UIKit.h>
#import "CommentInfo.h"

@interface GetImageCollectionCell : UICollectionViewCell

@property (strong, nonatomic) UIImageView *imgView;

- (void) loadImage:(TweetImage *)curTweetImg;

+ (CGSize)ccellSize;

// 测试
- (void) loadImage2:(NSString *)imageName;

@end
