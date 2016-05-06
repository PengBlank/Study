//
//  GetImageTableCell.h
//  Teshehui
//
//  Created by macmini5 on 15/11/20.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

/**
 查看评论页面－图片cell
 **/

#import "BaseCell.h"

@interface GetImageTableCell : BaseCell<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong) UICollectionView       *mediaView;     // tableCell中嵌套的collectionView
@property (nonatomic,strong) NSArray                *images;        // 图片url的数组
@property (nonatomic,strong) void(^imageBlock)(NSArray *images, NSInteger index);

- (void)loadMediaView:(NSArray *)arr;
+ (CGFloat)cellHeightWithArr:(NSArray *)arr;
@end
