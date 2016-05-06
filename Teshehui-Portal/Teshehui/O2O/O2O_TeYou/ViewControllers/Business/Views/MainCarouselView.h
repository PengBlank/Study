//
//  MainCarouselView.h
//  Teshehui
//
//  Created by apple_administrator on 16/4/7.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

/**
 *  实体店首页view
 */

#import <UIKit/UIKit.h>
#import "HYLocationManager.h"

@protocol MainCarouselViewDelegate <NSObject>

- (void)MainCarouseQRcodeClick;
- (void)MainCarousePopPersonGuideView;

@end

@interface MainCarouselView : UIView
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) NSString   *cityName;
@property (nonatomic,assign) CLLocationCoordinate2D  coor;
@property (nonatomic,strong) UIImageView           *myQRCode;
@property (nonatomic,assign) id <MainCarouselViewDelegate> delegate;
@end
