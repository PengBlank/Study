//
//  HYAfterSaleDetailPhotoCell.m
//  Teshehui
//
//  Created by 成才 向 on 15/10/9.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYAfterSaleDetailPhotoCell.h"
#import "MWPhotoBrowser.h"
#import "UIButton+WebCache.h"

@implementation HYAfterSaleDetailPhotoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.separatorLeftInset = 0;
    }
    return self;
}

//- (void)setPhotos:(NSArray *)photos
//{
//    if (_photos != photos)
//    {
//        _photos = photos;
//        
//        
//    }
//}

- (void)loadPhotos
{
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    NSInteger numOfRow = 4;
    CGFloat space = 10;
    CGFloat width = (self.frame.size.width - 5*space) / 4;
    CGFloat x = space;
    CGFloat y = 15;
    for (int i = 0; i < _saleInfo.useDetail.proof.count; i++)
    {
        HYMallAfterSaleProof *proof = [_saleInfo.useDetail.proof objectAtIndex:i];
        UIButton *iv = [[UIButton alloc] initWithFrame:CGRectMake(x, y, width, width)];
        [iv sd_setBackgroundImageWithURL:[NSURL URLWithString:proof.imageUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"loading"]];
        iv.tag = 10 + i;
        [iv addTarget:self action:@selector(imgAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:iv];
        
        if (i % numOfRow == (numOfRow-1) || i == _saleInfo.useDetail.proof.count-1)
        {
            x = space;
            y += 15 + width;
        }
        else
        {
            x += space + width;
        }
    }
    CGRect frame = self.frame;
    frame.size.height = y + 15;
    self.frame = frame;
    [self setNeedsLayout];
}

- (void)imgAction:(UIButton *)btn
{
    if (self.photoClick) {
        self.photoClick(btn.tag - 10);
    }
}

- (void)setSaleInfo:(HYMallAfterSaleInfo *)saleInfo
{
    if (_saleInfo != saleInfo)
    {
        _saleInfo = saleInfo;
        [self loadPhotos];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
