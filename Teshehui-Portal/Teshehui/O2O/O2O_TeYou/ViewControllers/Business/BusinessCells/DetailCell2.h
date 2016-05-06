//
//  DetailCell2.h
//  Teshehui
//
//  Created by apple_administrator on 16/3/3.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "BaseCell.h"
#import "DLStarRatingControl.h"
#import "BusinessdetailInfo.h"
@interface DetailCell2 : BaseCell
{
    NSString *tmpString;
    NSInteger _index;
    CGSize _tmpSize;
    
}
@property (nonatomic, strong) BusinessdetailInfo   *baseInfo;
@property (nonatomic, strong) UILabel   *titleLabel;
@property (nonatomic, strong) UILabel   *contentLabel;
@property (nonatomic, strong) UIButton  *btn;
@property (nonatomic, assign) BOOL      isDown;;

@property (nonatomic,copy)   void (^btnClickBlock)(BusinessdetailInfo *bInfo,UIButton *btn);
- (void)bindata:(BusinessdetailInfo *)baseInfo andIndex:(NSInteger)index;
- (CGFloat)cellHeight;
@end
