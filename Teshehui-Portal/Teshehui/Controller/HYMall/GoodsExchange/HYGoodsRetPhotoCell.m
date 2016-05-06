//
//  HYGoodsPhotoCell.m
//  Teshehui
//
//  Created by RayXiang on 14-9-18.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYGoodsRetPhotoCell.h"
#import "HYPhotoControl.h"

@interface HYGoodsRetPhotoCell ()

@property (nonatomic, strong) NSArray *imgBtns;

@end

@implementation HYGoodsRetPhotoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //拍照按钮
        //实际view的大小还要包括右上角的删除按钮，大小30x30
        //CGFloat total_w = 270;
        CGFloat w = 70;
        CGFloat x = 20;
        CGFloat y = 15;
        CGFloat space = (CGRectGetWidth(self.frame) - 2*x - 3*w) / 2;
        NSMutableArray *btns = [NSMutableArray array];
        w += 15;
        y -= 15;
        for (int i = 0; i < 3; i++)
        {
            HYPhotoControl *btn = [[HYPhotoControl alloc] initWithFrame:CGRectMake(x, y, w, w)];
            btn.normalImage = [UIImage imageNamed:@"comment_img"];
            [btn addTargetForTouchAction:self action:@selector(imgBtnAction:)];
            [btn addTargetForDeleteAction:self action:@selector(delBtnAction:)];
            btn.idx = i;
            [btns addObject:btn];
            [self.contentView addSubview:btn];
            
            x += space + w - 15; //右移一个按钮的距离，加15空白再减去右上角空白
        }
        self.imgBtns = btns;
    }
    return self;
}

#pragma mark - private
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

- (void)setPhotos:(NSArray *)photos
{
    for (NSInteger i = 0; i < self.imgBtns.count; i++)
    {
        HYPhotoControl *btn = [self.imgBtns objectAtIndex:i];
        if (photos.count > i)
        {
            UIImage *photo = [photos objectAtIndex:i];
            btn.photo = photo;
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
