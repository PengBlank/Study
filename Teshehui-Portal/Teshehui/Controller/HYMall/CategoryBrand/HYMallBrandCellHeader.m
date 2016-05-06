//
//  HYMallBrandCellHeader.m
//  Teshehui
//
//  Created by Kris on 16/3/23.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYMallBrandCellHeader.h"

@interface HYMallBrandCellHeader ()

@property (weak, nonatomic) IBOutlet UILabel *cateNameLabel;

@end

@implementation HYMallBrandCellHeader

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor colorWithWhite:.96 alpha:1];
}

- (void)setText:(NSString *)text
{
    _cateNameLabel.text = text;
}

@end
