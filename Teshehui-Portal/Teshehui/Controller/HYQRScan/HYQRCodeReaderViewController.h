//
//  HYQRCodeReaderViewController.h
//  Teshehui
//
//  Created by HYZB on 15/5/12.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

/*
 *扫描二维码界面
 */
#import "HYMallViewBaseController.h"

typedef enum _HYQRCodeType
{
    QR_ProductInfo = 1,
    QR_Payment,
}HYQRCodeType;

@interface HYQRCodeReaderViewController : HYMallViewBaseController

@end
