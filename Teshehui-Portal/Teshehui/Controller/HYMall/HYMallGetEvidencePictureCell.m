//
//  HYMallGetEvidencePictureCell.m
//  Teshehui
//
//  Created by Kris on 15/10/9.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYMallGetEvidencePictureCell.h"
#import "UIImageView+WebCache.h"

#import "HYZoomImage.h"

#import "HYMallAfterSaleInfo.h"


@interface HYMallGetEvidencePictureCell ()

@end

@implementation HYMallGetEvidencePictureCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
//        UIButton *camera = [UIButton buttonWithType:UIButtonTypeCustom];
//        camera.backgroundColor = [UIColor redColor];
//        camera.frame = CGRectMake(10, 10, 40, 40);
//        [camera addTarget:self action:@selector(openCamera) forControlEvents:UIControlEventTouchDown];
//        [self.contentView addSubview:camera];
//        
//        UIButton *photoAlbum = [UIButton buttonWithType:UIButtonTypeCustom];
//        photoAlbum.backgroundColor = [UIColor yellowColor];
//        photoAlbum.frame = CGRectMake(60, 10, 40, 40);
//        [photoAlbum addTarget:self action:@selector(openPhotoAlbum) forControlEvents:UIControlEventTouchDown];
//        [self.contentView addSubview:photoAlbum];
        
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
}


#pragma mark private methods
- (void)openCamera
{
    if ([self.delegate respondsToSelector:@selector(getPicFromCamera)])
    {
        [self.delegate getPicFromCamera];
    }
}

- (void)openPhotoAlbum
{
    if ([self.delegate respondsToSelector:@selector(getPicFromPhotoAlbum)])
    {
        [self.delegate getPicFromPhotoAlbum];
    }
}

- (void)browseImage:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(jumpToBrowserFromIndex:)])
    {
        [self.delegate jumpToBrowserFromIndex:sender.tag];
    }
}

- (void)updateContentView
{
    if (self.picData)
    {
        [self.contentView.subviews
         makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        //最多显示五张图片
        UIButton *btn = self.picData[0];
        btn.hidden = self.picData.count == 6;

        __block NSInteger row = 0;
        __block NSInteger column = 0;
        __block CGFloat margin = 0;
        NSInteger count = _picData.count;
        
        //选了图片之后重新布局
        __weak typeof(self) weakSelf = self;
        [_picData enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^
         (UIButton *obj, NSUInteger idx, BOOL * _Nonnull stop) {
             if (0 == idx)
             {
                 [obj addTarget:weakSelf action:@selector(openCamera) forControlEvents:UIControlEventTouchDown];
             }
//             if (1 == idx)
//             {
//                 [obj addTarget:weakSelf action:@selector(openCamera) forControlEvents:UIControlEventTouchDown];
//             }
             if (idx > 0)
             {
                 [obj addTarget:weakSelf action:@selector(browseImage:) forControlEvents:UIControlEventTouchDown];
             }
             //反向遍历顺序显示图片
             idx = count - idx - 1;
             if (idx < count-1)
             {
                 obj.tag = idx;
             }
             row = idx / 4;
             column = idx % 4;
             
             margin = (ScreenRect.size.width - (4 * TFScalePoint(64)))/5;
             obj.frame = CGRectMake(margin + column * (TFScalePoint(64) + margin),
                                    margin + row* ((TFScalePoint(64))+margin),
                                    TFScalePoint(64),
                                    TFScalePoint(64));
             
                 [weakSelf.contentView addSubview:obj];
             
             
         }];

        
    }
    else if (self.imgsUrlList)
    {
        [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

        
        if (self.imgsUrlList.count > 0)
        {
            [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            
            __block NSInteger row = 0;
            __block NSInteger column = 0;
            __block CGFloat margin = 0;
            NSInteger count = _imgsUrlList.count;
            //选了图片之后重新布局
            __weak typeof(self) weakSelf = self;
            NSUInteger index = 0;
            
            for (NSString *url in _imgsUrlList)
            {
                //反向遍历顺序显示图片
                row = index / 4;
                column = index % 4;
                margin = (ScreenRect.size.width - (4 * TFScalePoint(64)))/5;
                CGRect frame = CGRectMake(margin + column * (TFScalePoint(64) + margin),
                                          margin + row* ((TFScalePoint(64))+margin),
                                          TFScalePoint(64),
                                          TFScalePoint(64));
                
                UIImageView *showImageView = [[UIImageView alloc] initWithFrame:frame];
                [showImageView sd_setImageWithURL:[NSURL URLWithString:url]
                                 placeholderImage:[UIImage imageNamed:@"logo_loading"]];
                showImageView.userInteractionEnabled = YES;
                
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ZoomPicture:)];
                [showImageView addGestureRecognizer:tap];
                
                [weakSelf.contentView addSubview:showImageView];
                
                if (index < count-2)
                {
                    showImageView.tag = index;
                }
                
                index++;
            }
        }
    }
    else
    {
        [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
}

#pragma mark - UITapGestureRecognizer
- (void)ZoomPicture:(UITapGestureRecognizer *)tap
{
    
    UIImageView *zoomImage = (UIImageView *)tap.view;
    // HYZoomImage用来放大缩小图片的类
    [HYZoomImage showImage:zoomImage];
    
}

#pragma mark getter and setter
- (void)setPicData:(NSArray *)picData
{
    if (![picData isEqualToArray:_picData])
    {
        _picData = picData;
        
        [self updateContentView];
    }
}

- (void)setImgsUrlList:(NSArray *)imgsUrlList
{
    if (imgsUrlList != _imgsUrlList)
    {
        _imgsUrlList = imgsUrlList;
        
        [self updateContentView];
    }
}

//- (void)setSaleInfo:(HYMallAfterSaleInfo *)saleInfo
//{
//    _saleInfo = saleInfo;
//    NSMutableArray *urls = [NSMutableArray array];
//    for (HYMallAfterSaleProof *proof in saleInfo.useDetail.proof) {
//        [urls addObject:proof.imageUrl];
//    }
//    [self setImgsUrlList:urls];
//}

@end
