//
//  HYExpensivePhotoCell.m
//  Teshehui
//
//  Created by apple on 15/4/1.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYExpensivePhotoCell.h"
#import "HYPhotoControl.h"

@interface HYExpensivePhotoCell ()

@property (nonatomic, strong) IBOutletCollection(HYPhotoControl) NSArray *photoControls;

@end

@implementation HYExpensivePhotoCell

- (void)awakeFromNib
{
    CGRect frame = [UIScreen mainScreen].bounds;
    CGFloat space = (frame.size.width - 2*20 - 3*80) / 2 - 15;
    CGFloat x = 20;
    NSInteger i = 0;
    for (HYPhotoControl *control in _photoControls)
    {
        [control layoutSubviews];
        
        CGRect controlframe = control.frame;
        controlframe.origin.x = x;
        control.frame = controlframe;
//        control.backgroundColor = [UIColor redColor];
        
        control.normalImage = [UIImage imageNamed:@"mall_afterSaleCamera"];
        [control addTargetForTouchAction:self action:@selector(imgBtnAction:)];
        [control addTargetForDeleteAction:self action:@selector(delBtnAction:)];
        control.idx = i;
        
        i++;
        x+= controlframe.size.width + space;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
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
    for (HYPhotoControl *btn in self.photoControls)
    {
        btn.enable = enable;
    }
}

#pragma mark - public
- (void)setPhotos:(NSArray *)photos
{
    for (NSInteger i = 0; i < self.photoControls.count; i++)
    {
        HYPhotoControl *btn = [self.photoControls objectAtIndex:i];
        if (photos.count > i)
        {
            btn.hidden = NO;
            id photo = [photos objectAtIndex:i];
            if ([photo isKindOfClass:[UIImage class]]) {
                btn.photo = photo;
            }
            else if ([photo isKindOfClass:[NSString class]])
            {
                
            }
        }
        else if (i == photos.count)
        {
            btn.photo = nil;
            btn.hidden = NO;
        }
        else
        {
            btn.hidden = YES;
        }
    }
    
}

@end
