//
//  HYMallOrderExpandSectionView.h
//  Teshehui
//
//  Created by HYZB on 14-9-17.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HYMallOrderExpandSectionViewDelegate <NSObject>

@required
- (void)didExpandAllCell:(BOOL)expand;

@end

@interface HYMallOrderExpandSectionView : UIView
{
    BOOL _expand;
    UIButton *_expandBtn;
}
@property (nonatomic, weak) id<HYMallOrderExpandSectionViewDelegate> delegate;

@end
