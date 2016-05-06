//
//  CommentCell.h
//  Teshehui
//
//  Created by apple_administrator on 15/9/8.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "BaseCell.h"
#import "DLStarRatingControl.h"
#import "CommentInfo.h"
#import "BusinessdetailInfo.h"


@protocol CommentCellDeleagate <NSObject>

- (void)commentImageClick:(CommentInfo *)commentInfo index:(NSInteger)index;

@end

@interface CommentCell : BaseCell
{
    NSString    *_contentString;
    NSArray     *_tmpPhotoArray;
    UIView      *_imageBgView;
    CommentInfo *_tmpCommentInfo;
}
@property (nonatomic,strong) UIImageView                *headImage;
@property (nonatomic,strong) UILabel                    *nameLabel;
@property (nonatomic,strong) DLStarRatingControl        *starView;
//@property (nonatomic,strong) UIView                     *lineView;
@property (nonatomic,strong) UILabel                    *timeLabel;
@property (nonatomic,strong) UILabel                    *contentLabel;
@property (nonatomic,strong) UIButton                   *praiseBtn;
@property (nonatomic,strong) UIButton                   *checkBtn;
@property (nonatomic,assign) id <CommentCellDeleagate> delegate;

@property (nonatomic,copy)   void (^praisedBlock)(CommentInfo *cInfo,UIButton *btn);

- (void)bindDataWithNoCommnet;
- (void)bindData:(BusinessdetailInfo *)detailInfo;
- (void)bindDataWithCommentView:(CommentInfo *)comentInfo;
- (CGFloat)cellHeight;

@end
