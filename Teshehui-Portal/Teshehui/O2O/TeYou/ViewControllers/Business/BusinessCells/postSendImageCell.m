//
//  postSendImageCell.m
//  TTClub
//
//  Created by xkun on 15/4/28.
//  Copyright (c) 2015年 熙文 张. All rights reserved.
//

#define kTweetSendImageCCell_Width floorf((kScreen_Width -15*2 - 10*3)/4)

#import "postSendImageCell.h"
#import "DefineConfig.h"
#import "UIImage+Common.h"
@implementation postSendImageCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    
        if (!_imgView) {
            _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 15, kTweetSendImageCCell_Width - 10, kTweetSendImageCCell_Width - 10)];
            _imgView.contentMode = UIViewContentModeScaleAspectFill;
            _imgView.clipsToBounds = YES;
            _imgView.layer.masksToBounds = YES;
            _imgView.layer.cornerRadius = 2.0;
            [self.contentView addSubview:_imgView];
        }
    }
    return self;
}

- (void)setCurTweetImg:(TweetImage *)curTweetImg{
  
    
    _curTweetImg = curTweetImg;
    if (_curTweetImg) {
        
        
        _imgView.image = [_curTweetImg.image scaledToSize:_imgView.bounds.size highQuality:YES];
        if (!_deleteBtn) {
            _deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(kTweetSendImageCCell_Width-22, 5, 20, 20)];
            [_deleteBtn setImage:[UIImage imageNamed:@"btn_delete_tweetimage"] forState:UIControlStateNormal];
            _deleteBtn.backgroundColor = [UIColor blackColor];
            _deleteBtn.layer.cornerRadius = CGRectGetWidth(_deleteBtn.bounds)/2;
            _deleteBtn.layer.masksToBounds = YES;
            
            [_deleteBtn addTarget:self action:@selector(deleteBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:_deleteBtn];
        }
        _deleteBtn.hidden = NO;

    }else{
        
        
        _imgView.image = [UIImage imageNamed:@"add-ph"];
        if (_deleteBtn) {
            _deleteBtn.hidden = YES;
        }

    }
}
- (void)deleteBtnClicked:(id)sender{
    if (_deleteTweetImageBlock) {
        _deleteTweetImageBlock(_curTweetImg);
    }
}
+(CGSize)ccellSize{
    return CGSizeMake(kTweetSendImageCCell_Width, kTweetSendImageCCell_Width);
}


@end
