//
//  HYAddCommentsPhotoCell.h
//  Teshehui
//
//  Created by RayXiang on 14-9-22.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HYAddCommentsPhotoCell;

@protocol HYAddCommentsPhotoCellDelegate <NSObject>

@optional
- (void)photoCellDidClickAddPhoto:(UITableViewCell *)cell;
- (void)photoCell:(UITableViewCell *)cell didClickDeletePhotoWithIndex:(NSInteger)idx;

@end


@interface HYAddCommentsPhotoCell : UITableViewCell

@property (nonatomic, strong) NSArray *photos; //评价照片

@property (nonatomic, weak) id<HYAddCommentsPhotoCellDelegate> delegate;

@property (nonatomic, assign) BOOL enable;

@end
