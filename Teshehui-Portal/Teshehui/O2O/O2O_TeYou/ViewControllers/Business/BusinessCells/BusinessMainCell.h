//
//  BusinessMainCell.h
//  Teshehui
//
//  Created by apple_administrator on 16/4/1.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "BaseCell.h"
#import "SceneListInfo.h"
@interface BusinessMainCell : BaseCell
@property (nonatomic,strong) UIImageView    *mainImageV;
@property (nonatomic,strong) UIView         *backgroudView;
@property (nonatomic,strong) UILabel        *titleLabel;
//@property (nonatomic,strong) UILabel        *topicLabel;
@property (nonatomic,strong) UILabel        *desLabel;
//@property (nonatomic,strong) UILabel        *distanceLabel;
@property (nonatomic,strong) UIButton       *shareBtn;
@property (nonatomic,strong) UIButton       *praiseBtn;

@property (nonatomic,strong) UIView         *lineView;
@property (nonatomic,strong) UILabel        *praiseLabel;

@property (nonatomic,strong) SceneListInfo  *baseInfo;

- (void)bindData:(SceneListInfo *)sInfo;
@end
