//
//  TicketScreenshot.m
//  Teshehui
//
//  Created by LiuLeiMacmini on 15/11/19.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "TicketScreenshot.h"
#import "DHSmartScreenshot.h"
#import "ALAssetsLibrary+CustomPhotoAlbum.h"
#import "ZXingObjC.h"
#import "NSString+Addition.h"

@implementation TicketScreenshot

+ (TicketScreenshot *)sharedConstant {
    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"TicketScreenshot" owner:self options:nil];
    return [nib objectAtIndex:0];
}
- (void)  setDataSource:(id<UITableViewDataSource>)dataSource
               Delegate:(id<UITableViewDelegate>)delegate
            TicketTitle:(NSString *)title
                Payment:(NSString *)price
                PayDate:(NSString *)date
                 qrCode:(NSString *)qr callback:(TicketScreenshotCallback)screenshotResult{
    
//    self.frame            = [[UIScreen mainScreen] bounds];
    self.screenshotResult = screenshotResult;
    self.dataSource       = dataSource;
    self.delegate         = delegate;
    self.contentMode      = UIViewContentModeScaleAspectFit;
    //base64
    NSString *dataStr           = [qr base64EncodedString];
    ZXEncodeHints *hints = [ZXEncodeHints hints];
    hints.margin         = @1;

    ZXMultiFormatWriter *writer = [[ZXMultiFormatWriter alloc] init];
    ZXBitMatrix *result         = [writer encode:dataStr
                                          format:kBarcodeFormatQRCode
                                           width:_imgQR.frame.size.width
                                          height:_imgQR.frame.size.height
                                           hints:hints
                                           error:nil];
    
    ZXImage *image            = [ZXImage imageWithMatrix:result];
    self.imgQR.image          = [UIImage imageWithCGImage:image.cgimage];
    self.lblTitle.text        = title;
    self.lblPaymentPrice.text = price;
    self.lblPayDate.text      = date;
    [self getScreenshotAndSaveAssets];
}

- (void) getScreenshotAndSaveAssets {

    // 整个tableview所有cell的截图
    UIImage * tableViewScreenshot = [self screenshot];
    
    // 再将这个截图重新装到imageview中，设置模式为等比例填充，不然保存到相册后，会自动放大，不能显示完全
    UIImageView *imgv    = [[UIImageView alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    imgv.contentMode     = UIViewContentModeScaleAspectFit;
    imgv.backgroundColor = [UIColor whiteColor];
    imgv.image           = tableViewScreenshot;
    UIImage *newImage    = [self snapshot:imgv];
    
    // 记得导入Photos.framework，不然删除文件夹后无法保存
    ALAssetsLibrary *library      = [[ALAssetsLibrary alloc] init];
    [library saveImage:newImage toAlbum:@"特奢汇" completion:^(NSURL *assetURL, NSError *error) {
        if (_screenshotResult) {
            self.screenshotResult( error ? NO : YES , error);
        }
    } failure:^(NSError *error) {
        if (_screenshotResult) {
            self.screenshotResult( NO , error);
        }
    }];
}

- (UIImage *)snapshot:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, YES, 0);
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
