//
//  HYUserQrcodeView.m
//  Teshehui
//
//  Created by Kris on 15/7/15.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYUserQrcodeView.h"
#import "ZXingObjC.h"
#import "NSString+Addition.h"

@implementation HYUserQrcodeView

+ (instancetype)instanceView
{
    UINib *nib = [UINib nibWithNibName:@"HYProductQrcodeView" bundle:nil];
    NSArray *views = [nib instantiateWithOwner:nil options:nil];
    if (views.count > 0)
    {
        return [views objectAtIndex:0];
    }
    return nil;
}

- (void)awakeFromNib
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self addGestureRecognizer:tap];
}

- (void)tapAction:(UITapGestureRecognizer *)tap
{
    [self dismiss];
}

//- (void)show
//{
//    if (!self.superview)
//    {
//        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
//        self.frame = [UIScreen mainScreen].bounds;
//        [window addSubview:self];
//    }
//    
//    __weak typeof(self) b_self = self;
//    b_self.alpha = 0;
//    [UIView animateWithDuration:.3 animations:^{
//        b_self.alpha = 1;
//    }];
//    
//    NSString *dataStr = [NSString stringWithFormat:@"teshehui&type=1&product_id=%@", self.productId];
//    
//    //base64
//    dataStr = [dataStr base64EncodedString];
//    
//    if (dataStr)
//    {
//        ZXMultiFormatWriter *writer = [[ZXMultiFormatWriter alloc] init];
//        ZXBitMatrix *result = [writer encode:dataStr
//                                      format:kBarcodeFormatQRCode
//                                       width:_qrcodeImageV.frame.size.width
//                                      height:_qrcodeImageV.frame.size.width
//                                       error:nil];
//        
//        if (result)
//        {
//            ZXImage *image = [ZXImage imageWithMatrix:result];
//            
//            _qrcodeImageV.image = [UIImage imageWithCGImage:image.cgimage];
//        } else {
//            _qrcodeImageV.image = nil;
//        }
//    }
//    else
//    {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒"
//                                                        message:@"用户登录信息不完整，请重新登录"
//                                                       delegate:self
//                                              cancelButtonTitle:@"取消"
//                                              otherButtonTitles:@"重新登录", nil];
//        [alert show];
//    }
//}

- (void)dismiss
{
    __weak typeof(self) b_self = self;
    [UIView animateWithDuration:.3 animations:^
     {
         b_self.alpha = 0;
     } completion:^(BOOL finished)
     {
         [b_self removeFromSuperview];
     }];
}

@end
