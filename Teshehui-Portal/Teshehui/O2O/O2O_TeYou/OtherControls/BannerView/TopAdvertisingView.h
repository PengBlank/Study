//
//  HeadMenuView.h
//  YYHealth
//
//  Created by xkun on 15/6/10.
//  Copyright (c) 2015年 xkun. All rights reserved.
//

typedef NS_ENUM(NSInteger, ImageType)
{
    qiniu       = 1,
    aliyun      = 2
};

#import <UIKit/UIKit.h>

@class TopAdvertisingView;

@protocol TopAdvertisingViewDelegate <NSObject>
@optional
/**
 * @brief     滚动视图点选回调
 * @param     TopAdvertisingView 回传对象，如果创建多个是区分对象
 * @param     paramIndex 图片数组索引
 */
- (void)topAdvertisingViewCallBack:(TopAdvertisingView *)TopAdvertisingView didSelectImageView:(NSUInteger)paramIndex;

/**
 * @brief     滚动当前视图回调
 * @param     TopAdvertisingView 回传对象，如果创建多个是区分对象
 * @param     paramIndex 图片数组索引
 */
- (void)topAdvertisingViewCallBack:(TopAdvertisingView *)TopAdvertisingView didScrollImageView:(NSUInteger)paramIndex;

@end

@interface TopAdvertisingView : UIView<UIScrollViewDelegate>
{
    UIScrollView   *_scrollView;
    UIImageView    *_curImageView;
    
    NSUInteger      _totalPage;
    NSUInteger      _curPage;
    
    NSMutableArray *_curImages;                 //存放当前滚动的三张图片
 
   
}

@property (nonatomic,strong  ) NSTimer                    *autoTimer;
@property (nonatomic, assign ) id<TopAdvertisingViewDelegate> delegate;

@property (nonatomic , assign) ImageType                  imageType;
@property (nonatomic , strong) NSTimer                    *animationTimer;
@property (nonatomic , assign) NSTimeInterval             animationDuration;
@property (nonatomic, retain ) NSMutableArray             *imagesArray;//存放所有需要滚动的图片 UIImage
/**
 * @brief     初始化一个Bananer滚动视图
 * @param     input 此视图frame
 * @param     pictureArray 图片数组，存储为（UIImage *）对象
 * @return    YES已经登陆，NO为未登陆
 */

- (id)initWithFrame:(CGRect)frame;

@end
