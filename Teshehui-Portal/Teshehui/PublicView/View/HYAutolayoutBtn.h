//
//  HYAutolayoutBtn.h
//  Teshehui
//
//  Created by HYZB on 15/6/9.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HYAutolayoutBtn : UIControl

@property (nonatomic, strong, readonly) UILabel *titleLabel;
@property (nonatomic, strong, readonly) UIImageView *imageView;

- (id)initWithTitle:(NSString *)title image:(UIImage *)image;
- (id)initWithTitle:(NSString *)title image:(UIImage *)image selectedImage:(UIImage *)selectedImage;

@end
