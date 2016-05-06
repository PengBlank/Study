//
//  TravelQRView.m
//  Teshehui
//
//  Created by apple_administrator on 15/10/17.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "TravelQRView.h"
#import "UIColor+expanded.h"
#import "UIImage+Common.h"
#import "DefineConfig.h"
#import "Masonry.h"
#import "NSString+Addition.h"
#import "ZXingObjC.h"
@interface TravelQRView ()

@property (nonatomic ,strong) UIImageView   *imageView;

@property (nonatomic ,strong) UIView    *bgView;
@property (nonatomic ,strong) UILabel   *titleLabel;
@property (nonatomic ,strong) UILabel   *subTitleLabel;
@property (nonatomic ,strong) UILabel   *tiketNameLabel;
@property (nonatomic ,strong) UILabel   *priceLabel;
@property (nonatomic ,strong) UILabel   *desLabel;


@end

@implementation TravelQRView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0f];
        
        self.bgView = [[UIView alloc] init];
        [ self.bgView setBackgroundColor:[UIColor colorWithHexString:@"ffffff" andAlpha:1]];
        [self addSubview: self.bgView];
        
        self.titleLabel = [[UILabel alloc] init];
        [self.titleLabel setFont:[UIFont systemFontOfSize:17]];
        [self.titleLabel setTextColor:[UIColor colorWithHexString:@"0xb80000"]];
        [self.bgView addSubview:self.titleLabel];
        
        self.subTitleLabel = [[UILabel alloc] init];
        [self.subTitleLabel setFont:[UIFont systemFontOfSize:14]];
        [self.subTitleLabel setTextColor:[UIColor colorWithHexString:@"0x343434"]];
        [self.bgView addSubview:self.subTitleLabel];
        
        self.imageView = [[UIImageView alloc] init];
        self.imageView.backgroundColor = [UIColor redColor];
        [self.bgView addSubview:self.imageView];
        
        
        self.tiketNameLabel = [[UILabel alloc] init];
        [self.tiketNameLabel setFont:[UIFont systemFontOfSize:15]];
        [self.tiketNameLabel setTextColor:[UIColor colorWithHexString:@"0x343434"]];
        self.tiketNameLabel.numberOfLines = 2;
        [self.bgView addSubview:self.tiketNameLabel];
        
        self.priceLabel = [[UILabel alloc] init];
        [self.priceLabel setFont:[UIFont systemFontOfSize:17]];
        [self.priceLabel setTextColor:[UIColor colorWithHexString:@"0xb80000"]];
        [self.bgView addSubview:self.priceLabel];
        
        self.desLabel = [[UILabel alloc] init];
        [self.desLabel setFont:[UIFont systemFontOfSize:14]];
        [self.desLabel setTextColor:[UIColor colorWithHexString:@"0x343434"]];
        [self.bgView addSubview:self.desLabel];
        
        UIButton *downloadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [downloadBtn setTitle:@"下载订单二维码" forState:UIControlStateNormal];
        [[downloadBtn titleLabel] setTextColor:[UIColor whiteColor]];
        [[downloadBtn titleLabel] setFont:[UIFont systemFontOfSize:15]];
        [downloadBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"0xb80000"]] forState:UIControlStateNormal];
        [downloadBtn addTarget:self action:@selector(downloadBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.bgView addSubview:downloadBtn];
        
    
        NSLog(@"%@",NSStringFromCGSize(CGSizeMake(ScaleWIDTH(300), ScaleHEIGHT(450))));
        
        WS(weakSelf);
        [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(weakSelf.mas_centerX);
            make.centerY.mas_equalTo(weakSelf.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(ScaleWIDTH(300), ScaleHEIGHT(450)));
        }];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakSelf.bgView.mas_top).offset(ScaleHEIGHT(28));
            make.centerX.mas_equalTo(weakSelf.bgView.mas_centerX);
        }];
        
        [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakSelf.titleLabel.mas_bottom).offset(ScaleHEIGHT(10));
            make.centerX.mas_equalTo(weakSelf.bgView.mas_centerX);
        }];
        
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakSelf.subTitleLabel.mas_bottom).offset(ScaleHEIGHT(7));
            make.centerX.mas_equalTo(weakSelf.bgView.mas_centerX);
            make.size.mas_equalTo(CGSizeMake(ScaleWIDTH(215), ScaleWIDTH(215)));
        }];
        
        [self.tiketNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakSelf.imageView.mas_bottom).offset(0);
            make.centerX.mas_equalTo(weakSelf.bgView.mas_centerX);
        }];
        
        [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakSelf.tiketNameLabel.mas_bottom).offset(ScaleHEIGHT(20));
            make.centerX.mas_equalTo(weakSelf.bgView.mas_centerX);
        }];
        
        [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakSelf.priceLabel.mas_bottom).offset(ScaleHEIGHT(10));
            make.centerX.mas_equalTo(weakSelf.bgView.mas_centerX);
        }];
        
        [downloadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(weakSelf.bgView.mas_bottom);
            make.left.mas_equalTo(weakSelf.bgView.mas_left);
            make.width.mas_equalTo(weakSelf.bgView.mas_width);
            make.height.mas_equalTo(ScaleHEIGHT(44));
        }];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [self addGestureRecognizer:tap];


    }
    return self;
}

- (void)tapAction:(UITapGestureRecognizer *)tap
{
    [self dismiss];
}

- (void)setText{
    
    self.titleLabel.text = @"订单二维码";
    self.subTitleLabel.text = @"（请出示该二维码以供验票）";
    self.tiketNameLabel.text = [NSString stringWithFormat:@"%@%@",_travelOrderInfo.touristName,_travelOrderInfo.ticketName];//@"深圳欢乐谷万圣节夜场票";
    
    CGFloat price = _travelOrderInfo.price.floatValue;
    CGFloat coupon = _travelOrderInfo.coupon.floatValue;
    
    if(price == 0 && coupon != 0){
        
        self.priceLabel.text  = [NSString stringWithFormat:@"%@现金券",_travelOrderInfo.price];
        
    }else if(price == 0 && coupon == 0){
        
    }else if (price != 0 && coupon == 0){
        
        self.priceLabel.text  = [NSString stringWithFormat:@"￥%@",_travelOrderInfo.price];
        
    }else{
        self.priceLabel.text  = [NSString stringWithFormat:@"￥%@ + %@现金券",_travelOrderInfo.price,_travelOrderInfo.coupon];
    }
    
    
//    CGFloat audit = _travelOrderInfo.auditTickets.floatValue;
//    CGFloat child = _travelOrderInfo.childTickets.floatValue;
//    
//    if(audit == 0 && child != 0){
//        
//        self.desLabel.text  = [NSString stringWithFormat:@"（%@张儿童票）",_travelOrderInfo.childTickets];
//        
//    }else if(audit == 0 && child == 0){
//        
//    }else if (audit != 0 && child == 0){
//        
//        self.desLabel.text  = [NSString stringWithFormat:@"（%@张成人票）",_travelOrderInfo.auditTickets];
//        
//    }else{
//        self.desLabel.text  = [NSString stringWithFormat:@"（%@成人票 + %@儿童票）",_travelOrderInfo.auditTickets,_travelOrderInfo.childTickets];
//    }
}

#pragma mark - 创建二维码图片
- (void)creatQRCodeImage{
    
    NSString *dataStr = [NSString stringWithFormat:@"travel&tid=%@&sid=%@",self.travelOrderInfo.tId ,self.travelOrderInfo.merId];
    
    //base64
    dataStr = [dataStr base64EncodedString];
    
    if (dataStr)
    {
        ZXMultiFormatWriter *writer = [[ZXMultiFormatWriter alloc] init];
        ZXBitMatrix *result = [writer encode:dataStr
                                      format:kBarcodeFormatQRCode
                                       width:215
                                      height:215
                                       error:nil];
        
        if (result)
        {
            ZXImage *image = [ZXImage imageWithMatrix:result];
            
            self.imageView.image = [UIImage imageWithCGImage:image.cgimage];
        } else {
            self.imageView.image = nil;
        }
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒"
                                                        message:@"用户登录信息不完整，请重新登录"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"重新登录", nil];
        [alert show];
    }
}


- (void)show{
    
    if (!self.superview)
    {
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        self.frame = [UIScreen mainScreen].bounds;
        [window addSubview:self];
    }
    
    __weak typeof(self) b_self = self;
    [UIView animateWithDuration:.3 animations:^{
        b_self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7f];
        b_self.bgView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:1.0f];
    }];
    
    [self creatQRCodeImage];
    
}

- (void)dismiss{
    
    __weak typeof(self) b_self = self;
    [UIView animateWithDuration:.3 animations:^
     {
        b_self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0f];
        b_self.bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0f];
        [b_self removeFromSuperview];
     } completion:^(BOOL finished)
     {

     }];
}

- (void)downloadBtnAction:(UIButton *)btn{
    
   UIImage *newImage = [self reSizeImage:self.imageView.image toSize:CGSizeMake(600, 600)];
    [self saveImageToPhotos:newImage];
}

- (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize

{
    UIGraphicsBeginImageContext(CGSizeMake(reSize.width, reSize.height));
    [image drawInRect:CGRectMake(0, 0, reSize.width, reSize.height)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return reSizeImage;
    
}

#pragma mark -----保存图片
- (void)saveImageToPhotos:(UIImage*)savedImage
{
//    UIImage *image = [self addText:savedImage text:[NSString stringWithFormat:@"%@%@%@",_travelOrderInfo.touristName,_travelOrderInfo.ticketName,_travelOrderInfo.orderDate]];
//    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}


- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSString *msg = nil ;
    if(error != NULL){
        msg = @"保存二维码失败" ;
    }else{
        msg = @"保存二维码成功" ;
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                    message:msg
                                                   delegate:self
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
}

- (UIImage *)addText:(UIImage *)img text:(NSString *)mark {
    
    int w = img.size.width;
    int h = img.size.height;
    UIGraphicsBeginImageContext(img.size);
    [[UIColor grayColor] set];
    [img drawInRect:CGRectMake(0, 0, w, h)];
    [mark drawInRect:CGRectMake(0 , h - 45, w, 80) withFont:[UIFont systemFontOfSize:18]
       lineBreakMode:NSLineBreakByWordWrapping
           alignment:NSTextAlignmentCenter];
    UIImage *aimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return aimg;
}

@end
