//
//  GetImageCollectionCell.m
//  Teshehui
//
//  Created by macmini5 on 15/11/20.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#define getImageCCell_Width floorf((kScreen_Width -15*2 - 10*3)/4)

#import "GetImageCollectionCell.h"
#import "DefineConfig.h"
#import "UIImageView+WebCache.h"
#import "UIImage+Common.h"

@implementation GetImageCollectionCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        if (!_imgView) {
            _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, getImageCCell_Width , getImageCCell_Width )];
            _imgView.contentMode = UIViewContentModeScaleAspectFill;
            _imgView.clipsToBounds = YES;
            _imgView.layer.masksToBounds = YES;
            _imgView.layer.cornerRadius = 2.0;
            [self.contentView addSubview:_imgView];
        }
    }
    return self;
}

//  创建图片
- (void) loadImage:(TweetImage *)curTweetImg
{
    _imgView.image = [curTweetImg.image scaledToSize:_imgView.bounds.size highQuality:YES];
//    NSString *urlStirng = [NSString stringWithFormat:@"%@?imageView2/1/w/%@/h/%@",imageName,@"180",@"180"];
//    [self.imgView sd_setImageWithURL:[NSURL URLWithString:imageName]];
}

- (void) loadImage2:(NSString *)imageName
{// 图片测试用
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:imageName]];
}

+(CGSize)ccellSize
{
    return CGSizeMake(getImageCCell_Width, getImageCCell_Width);
}

@end
