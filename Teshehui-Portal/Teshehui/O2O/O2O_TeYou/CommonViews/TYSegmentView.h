//
//  TYSegmentView.h
//  Catering
//
//  Created by apple_administrator on 16/3/28.
//  Copyright © 2016年 TeYou. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^TitlebtnClickBlock)(UIButton *btn);
@interface TYSegmentView : UIView

/**
 *  标题个数
 */
@property (nonatomic,assign) NSInteger titileCount;
/**
 *  底部红线
 */
@property (nonatomic,strong) UIView *lineView;
/**
 *  底部灰线
 */
@property (nonatomic,strong) UIView *bottomView;
/**
 *  标题数组
 */
@property (nonatomic,strong) NSMutableArray *titleArray;
/**
 *  标题按钮数组
 */
@property (nonatomic,strong) NSMutableArray *titleButtonArray;
/**
 *  存放每一个按钮的滚动位置 点击滚到该位置
 */
@property (nonatomic,strong) NSMutableArray *scrollOffSet;
/**
 *  滚动条
 */
@property (nonatomic,strong) UIScrollView *titleScroll;
/**
 *  点击回调
 */
@property (nonatomic, copy) TitlebtnClickBlock titlebtnClickBlock ;

@end
