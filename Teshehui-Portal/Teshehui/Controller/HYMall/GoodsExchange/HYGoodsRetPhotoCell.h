//
//  HYGoodsPhotoCell.h
//  Teshehui
//
//  Created by RayXiang on 14-9-18.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYAddCommentsPhotoCell.h"

/**
 *  照片
 * 高度80
 */
@interface HYGoodsRetPhotoCell : UITableViewCell

@property (nonatomic, weak) id<HYAddCommentsPhotoCellDelegate> delegate;
@property (nonatomic, strong) NSArray *photos;

@end
