//
//  HYAddCommentsPhotoCell.m
//  Teshehui
//
//  Created by RayXiang on 14-9-22.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYAddCommentsPhotoCell.h"
#import "HYPhotoControl.h"
#import "UIImage+WebP.h"
#import "SDWebImageDownloader.h"

@interface HYAddCommentsPhotoCell ()
@property (nonatomic, strong) NSArray *imgBtns;
@end

@implementation HYAddCommentsPhotoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        CGFloat x = 20;
        CGFloat size = 80;
        CGFloat y = 20;
        CGFloat space = (CGRectGetWidth(self.frame) - 2*x - 3*size) / 2;
        //拍照按钮
        //实际view的大小还要包括右上角的删除按钮，大小30x30
        NSMutableArray *btns = [NSMutableArray array];
        size += 15;
        y -= 15;
        for (int i = 0; i < 3; i++)
        {
            HYPhotoControl *btn = [[HYPhotoControl alloc] initWithFrame:CGRectMake(x, y, size, size)];
            btn.normalImage = [UIImage imageNamed:@"comment_img"];
            [btn addTargetForTouchAction:self action:@selector(imgBtnAction:)];
            [btn addTargetForDeleteAction:self action:@selector(delBtnAction:)];
            btn.idx = i;
            [btns addObject:btn];
            [self addSubview:btn];
            
            x += space + size - 15; //右移一个按钮的距离，加15空白再减去右上角空白
        }
        self.imgBtns = btns;
        
        //图片按钮下面的横线
    }
    return self;
}

- (void)imgBtnAction:(UIButton *)btn
{
    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(photoCellDidClickAddPhoto:)])
    {
        [self.delegate photoCellDidClickAddPhoto:self];
    }
}

- (void)delBtnAction:(HYPhotoControl *)control
{
    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(photoCell:didClickDeletePhotoWithIndex:)])
    {
        [self.delegate photoCell:self didClickDeletePhotoWithIndex:control.idx];
    }
}

- (void)setEnable:(BOOL)enable
{
    _enable = enable;
    for (HYPhotoControl *btn in self.imgBtns)
    {
        btn.enable = enable;
    }
}

#pragma mark - public
- (void)setPhotos:(NSArray *)photos
{
    for (NSInteger i = 0; i < self.imgBtns.count; i++)
    {
        HYPhotoControl *btn = [self.imgBtns objectAtIndex:i];
        if (photos.count > i)
        {
            id photo = [photos objectAtIndex:i];
            if ([photo isKindOfClass:[UIImage class]]) {
                btn.photo = photo;
            }
            else if ([photo isKindOfClass:[NSString class]])
            {
                [[SDWebImageDownloader sharedDownloader]
                 downloadImageWithURL:[NSURL URLWithString:photo] options:SDWebImageDownloaderContinueInBackground progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished)
                {
                    btn.photo = image;
                }];
            }
        }
        else
        {
            btn.photo = nil;
        }
    }
    
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
