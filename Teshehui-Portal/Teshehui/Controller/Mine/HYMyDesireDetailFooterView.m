//
//  HYMyDesireDetailFooterView.m
//  Teshehui
//
//  Created by HYZB on 15/11/24.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYMyDesireDetailFooterView.h"
#import "HYMyDesireDetailModel.h"
#import "HYZoomImage.h"

@interface HYMyDesireDetailFooterView ()<UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *replyTimeLab;

@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (nonatomic, strong) HYMyDesireDetailModel *model;

@end

@implementation HYMyDesireDetailFooterView

- (void)awakeFromNib
{
    self.lineView.frame = CGRectMake(10, 75, [UIScreen mainScreen].bounds.size.width - 20, 1);
    self.topView.frame = CGRectMake(0, 0, TFScalePoint(320), 10);
}

- (void)setFooterViewWithModel:(HYMyDesireDetailModel *)model
{
    self.model = model;
    // 客服回复时间
    self.replyTimeLab.text = model.replyTime;
    
    // 客服回复内容
    if (model.wishDetailPOList.count) {
        
        self.replyContentLab.text = [NSString stringWithFormat:@"%@ (PS:长按二维码就可以直接找到商品哦)",
                                     model.replyContent];
        CGFloat replyContentWidth = [UIScreen mainScreen].bounds.size.width - 20;
        CGFloat replyContentSizeHeight = [self.replyContentLab.text
                                          sizeWithFont:[UIFont systemFontOfSize:14]
                                          constrainedToSize:CGSizeMake(replyContentWidth, MAXFLOAT)
                                          lineBreakMode:NSLineBreakByCharWrapping].height + 20;
        self.replyContentLab.frame = CGRectMake(10, 85, replyContentWidth, replyContentSizeHeight);
    } else {
        
        self.replyContentLab.text = model.replyContent;
    }
    
    // 愿望实现商品ID
    if (model.wishDetailPOList.count) {
        
        NSInteger colNumber = model.wishDetailPOList.count > 3 ? 3 : model.wishDetailPOList.count;
        // 行数
        NSUInteger rows = (model.wishDetailPOList.count + colNumber - 1) / colNumber;
        int number = 0;
        // 创建二维码图片
        for (NSInteger row = 0; row < rows; row++) {
            
            for (NSInteger col = 0; col < colNumber; col++) {
                
              //  NSString *productCode = model.wishDetailPOList[number][@"productCode"];
                NSString *productCode = [NSString stringWithFormat:@"teshehui&type=1&product_id=%@",
                                         model.wishDetailPOList[number][@"productCode"]];
                UIImage *scanImage = [self createNonInterpolatedUIImageFormCIImage:[self createQRForString:productCode] withSize:80];
                
                CGFloat width = scanImage.size.width;
                CGFloat margin = ([UIScreen mainScreen].bounds.size.width - 3 * width) / 4;
                
                CGFloat originX = (col+1)*margin + col * width;
                CGFloat originY = (CGRectGetMaxY(self.replyContentLab.frame) + 10) + row*10 + row*width;
                UIImageView *scanImageView = [[UIImageView alloc]
                                              initWithFrame:CGRectMake(originX, originY, width, width)];
                scanImageView.userInteractionEnabled = YES;
                scanImageView.image = scanImage;
                scanImageView.tag = number;
                [self addSubview:scanImageView];
                
                UILongPressGestureRecognizer *longPressGes = [[UILongPressGestureRecognizer alloc]
                                                              initWithTarget:self
                                                              action:@selector(goToGoodsView:)];
                [scanImageView addGestureRecognizer:longPressGes];
                longPressGes.delegate = self;
                
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                               initWithTarget:self action:@selector(tapDidClicked:)];
                [scanImageView addGestureRecognizer:tap];
                
                number++;
            }
        }
    }
    
}

- (void)goToGoodsView:(UILongPressGestureRecognizer *)ges
{
    if (ges.state == UIGestureRecognizerStateEnded) {
        
        if ([self.delegate respondsToSelector:@selector(goToGoodsDetailView:)]) {
            
            NSInteger n = ges.view.tag;
            NSString *productCode = self.model.wishDetailPOList[n][@"productCode"];
            [self.delegate goToGoodsDetailView:productCode];
        }
    }
}

- (void)tapDidClicked:(UITapGestureRecognizer *)tap
{
    [HYZoomImage showImage:(UIImageView *)tap.view];
}

- (CIImage *)createQRForString:(NSString *)qrString {
    NSData *stringData = [qrString dataUsingEncoding:NSUTF8StringEncoding];
    // 创建filter
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 设置内容和纠错级别
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"H" forKey:@"inputCorrectionLevel"];
    // 返回CIImage
    return qrFilter.outputImage;
}

- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat)size {
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    // 创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs,
                                                   (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // 保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

@end
