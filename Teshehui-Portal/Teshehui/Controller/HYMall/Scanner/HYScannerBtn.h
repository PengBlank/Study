//
//  HYScannerBtn.h
//  Teshehui
//
//  Created by HYZB on 16/4/7.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HYScannerBtn : UIButton

/** 图标 */
@property (nonatomic, strong) UIImageView *iconImgV;
/** 标题 */
@property (nonatomic, strong) UILabel *titleLab;


+ (instancetype)buttonWithImage:(NSString *)image title:(NSString *)title;

@end
