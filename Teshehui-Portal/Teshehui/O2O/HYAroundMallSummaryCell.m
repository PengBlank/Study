//
//  HYAroundMallSummaryCell.m
//  Teshehui
//
//  Created by RayXiang on 14-7-7.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYAroundMallSummaryCell.h"
#import "HYQRCodeGetShopDetailResponse.h"
#import "UIView+Style.h"
#import "UIView+GetImage.h"
#import "UIImageView+WebCache.h"

@implementation HYAroundMallSummaryCell

//- (id)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        
//    }
//    return self;
//}
//
//- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
//{
//    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
//    {
//        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 8, 262, 20)];
//        _nameLabel.textColor = [UIColor blackColor];
//        _nameLabel.backgroundColor = [UIColor clearColor];
//        [_nameLabel setFont:[UIFont boldSystemFontOfSize:18]];
//        [self.contentView addSubview:_nameLabel];
//        
//        _briefInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 34, 250, 32)];
//        _briefInfoLabel.textColor = [UIColor grayColor];
//        _briefInfoLabel.backgroundColor = [UIColor clearColor];
//        [_briefInfoLabel setFont:[UIFont systemFontOfSize:13]];
//        _briefInfoLabel.numberOfLines = 0;
//        [self.contentView addSubview:_briefInfoLabel];
//        
//        [self telBtn];
//    }
//    return self;
//}

- (void)awakeFromNib
{
    CGRect bounds = [UIScreen mainScreen].bounds;
    
    self.photoView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoTapAction:)];
    [self.photoView addGestureRecognizer:tap];
    self.photoView.layer.borderColor = [UIColor colorWithWhite:.73 alpha:1].CGColor;
    self.photoView.layer.borderWidth = 1;
    self.photoView.clipsToBounds = YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.bigPhotoView.userInteractionEnabled = YES;
    UITapGestureRecognizer *bigTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bigPhotoTapAction:)];
    [self.bigPhotoView addGestureRecognizer:bigTap];
    self.bigPhotoView.layer.borderColor = [UIColor colorWithWhite:.73 alpha:1].CGColor;
    self.bigPhotoView.layer.borderWidth = 1;
    self.bigPhotoView.frame = CGRectMake(0 , 2.5, bounds.size.width, 130);
    self.bigPhotoView.clipsToBounds = YES;
    
    self.blackView1.frame = CGRectMake(0, 100, bounds.size.width, 30);
    
    self.smallImgSuperView.frame = CGRectMake(bounds.size.width - 70, 80, 60, 60);
}

- (void)photoTapAction:(UITapGestureRecognizer *)tap
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(summaryCellDidClickPhoto)])
    {
        [self.delegate summaryCellDidClickPhoto];
    }
}

- (void)bigPhotoTapAction:(UITapGestureRecognizer *)tap
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(summaryCellDidClickBigPhoto)])
    {
        [self.delegate summaryCellDidClickBigPhoto];
    }
}


- (void)setWithShopDetail:(HYQRCodeShopDetail *)shop
{
    self.nameLabel.text = shop.store_name;
    CGFloat width = CGRectGetWidth(ScreenRect)-CGRectGetMinX(_nameLabel.frame)-70;
    CGSize size = [self.nameLabel.text sizeWithFont:_nameLabel.font
                                  constrainedToSize:CGSizeMake(width, _nameLabel.font.lineHeight*2)];
    _nameLabel.frame = CGRectMake(CGRectGetMinX(_nameLabel.frame), (36-size.height)/2, size.width, size.height);
    
    //self.briefInfoLabel.text = @"是是是是是是是是是是是是是是是是是是是是是是是是是是是是是是是是是是是是是是是是是是是是是是是是是是是是是是是是是是是是是是是是";
    if (shop.img_url.count > 0)
    {
        NSString *url = [shop.img_url objectAtIndex:0];
        [self.photoView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"loading"]];
        self.photoCountLab.text = [NSString stringWithFormat:@"%ld张图片", shop.img_url.count];
        
        //大图
        [self.bigPhotoView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"loading"]];
    }
    else
    {
        self.photoView.image = [UIImage imageNamed:@"loading"];
        self.photoCountLab.text = [NSString stringWithFormat:@"0张图片"];
    }
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
