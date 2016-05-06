//
//  HYGoodsRetDetailCell.h
//  Teshehui
//
//  Created by RayXiang on 14-9-18.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYGoodsRetGrayCell.h"

/**
 *  退换货申请中用来做地址的cell
 *  两行
 *  标准高度80
 */
@interface HYGoodsRetDetailCell : HYGoodsRetGrayCell

@property (nonatomic, strong) UILabel *detailLab;

@property (nonatomic, strong) NSString *detailContent;

+ (CGFloat)heightForDetailContent:(NSString *)content;

@end
