//
//  PostSendImageTableCell.h
//  TTClub
//
//  Created by xkun on 15/4/28.
//  Copyright (c) 2015年 熙文 张. All rights reserved.
//

#define kCellIdentifier_TweetSendImages @"PostSendImageTableCell"

#import "BaseCell.h"
#import "CommentInfo.h"
#import "postSendImageCell.h"

typedef void(^addPicturesBlock)();

@interface PostSendImageTableCell : BaseCell<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic,strong) UICollectionView       *mediaView;
@property (nonatomic,strong) NSMutableDictionary    *imageDict;
@property (nonatomic,strong) NSMutableArray         *imageArray;
@property (strong, nonatomic) CommentInfo *curPost;
//@property (copy, nonatomic) void(^addPicturesBlock)();
@property (nonatomic,copy) addPicturesBlock callBack;
+ (CGFloat)cellHeightWithObj:(id)obj;

- (void)loadMediaView:(CommentInfo *)info;

@end
