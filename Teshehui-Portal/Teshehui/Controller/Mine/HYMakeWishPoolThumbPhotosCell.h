//
//  HYMakeWishPoolThumbPhotosCell.h
//  Teshehui
//
//  Created by HYZB on 15/11/10.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HYMakeWishPoolThumbPhotosCellDelegate <NSObject>

- (void)imageBtnSelected;
- (void)photoBrowserAndPhotoIndex:(NSInteger)PhotoIndex;

@end

@interface HYMakeWishPoolThumbPhotosCell : UITableViewCell

@property (nonatomic, weak) id<HYMakeWishPoolThumbPhotosCellDelegate>delegate;
@property (nonatomic, strong) NSMutableArray *upPicture;

- (void)setImageToImageBtnWithImage:(NSMutableArray *)photos;

@end
