//
//  HYMakeWishPoolThumbPhotosCell.m
//  Teshehui
//
//  Created by HYZB on 15/11/10.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYMakeWishPoolThumbPhotosCell.h"

#define kMargin 10
#define kWidthAndHeight TFScalePoint(60)

@interface HYMakeWishPoolThumbPhotosCell ()

@property (nonatomic, strong) UIButton *imageBtn;
@property (nonatomic, strong) NSMutableArray *reversePhotos;
@property (nonatomic, assign) NSInteger lastIndex;

@property (nonatomic, strong) UILabel *photosTitleLab;
@property (nonatomic, strong) UIView *bottomView;

@end

@implementation HYMakeWishPoolThumbPhotosCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _photosTitleLab = [[UILabel alloc] init];
        _photosTitleLab.font = [UIFont systemFontOfSize:14];
        _photosTitleLab.text = @"照片";
        [self addSubview:_photosTitleLab];
        
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = [UIColor colorWithRed:233/250.0f green:233/250.0f blue:233/250.0f alpha:1.0];
        [self addSubview:_bottomView];
        
        for (int i = 0; i < 4; i++) {
            
            UIButton *showImageBtn = [UIButton buttonWithType:UIButtonTypeSystem];
            showImageBtn.tag = 100 + i;
            [showImageBtn addTarget:self action:@selector(imageBtnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:showImageBtn];
        }
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)layoutSubviews
{
    _photosTitleLab.frame = CGRectMake(kMargin, kMargin, 200, 20);
    // _bottomView.frame = CGRectMake(0, CGRectGetMaxY(self.contentView.frame)-15, TFScalePoint(320), 15);
    _bottomView.frame = CGRectMake(0, 125, TFScalePoint(320), 15);
}

- (void)setImageToImageBtnWithImage:(NSMutableArray *)photos
{
    // 清除上次的按钮位置设置
    for (NSInteger i = 0; i< _reversePhotos.count; i++) {
        UIButton *btn = (UIButton *)[self viewWithTag:100+i];
        btn.frame = CGRectZero;
    }
    
    // 清除上次图片数据
    [self.reversePhotos removeAllObjects];
    
    for (NSInteger i = photos.count - 1; i >= 0; i--) {
        
        [self.reversePhotos addObject:photos[i]];
    }
    
    _lastIndex = self.reversePhotos.count - 1;
    
    for (NSInteger j = 0; j < self.reversePhotos.count; j++) {
        UIButton *showImageBtn = (UIButton *)[self viewWithTag:100+j];
        
        if (j >= 3) {
            showImageBtn.hidden = YES;
        } else {
            
            [showImageBtn setBackgroundImage:self.reversePhotos[j] forState:UIControlStateNormal];
            showImageBtn.frame = CGRectMake((j + 1) * kMargin + j * kWidthAndHeight, kMargin + 30, kWidthAndHeight, kWidthAndHeight);
        }
        
    }
}

- (void)imageBtnDidClicked:(UIButton *)btn
{
    
    if (btn.tag-100 == _lastIndex) {
        
        if ([self.delegate respondsToSelector:@selector(imageBtnSelected)]) {
            [self.delegate imageBtnSelected];
        }
    } else {
        
        if ([self.delegate respondsToSelector:@selector(photoBrowserAndPhotoIndex:)]) {
            [self.delegate photoBrowserAndPhotoIndex:btn.tag-100];
        }
    }
    
}

#pragma mark - 懒加载
- (NSMutableArray *)reversePhotos
{
    if (!_reversePhotos) {
        _reversePhotos = [NSMutableArray array];
    }
    return _reversePhotos;
}

- (NSMutableArray *)upPicture
{
    if (!_upPicture) {
        _upPicture = [NSMutableArray array];
    }
    return _upPicture;
}


@end
