//
//  MainStoreView.h
//  Teshehui
//
//  Created by apple_administrator on 16/4/8.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//



#import <UIKit/UIKit.h>
#import "HYLocationManager.h"

@protocol MainStoreViewDelegate <NSObject>

- (void)QRcodeClickWithMainStoreView;
//- (void)popPersonGuideView;

@end

@interface MainStoreView : UIView
@property (nonatomic, strong) NSString              *cityName;
@property (nonatomic, strong) UIImageView           *myQRCode;
@property (nonatomic, assign) CLLocationCoordinate2D  coor;
@property (nonatomic, assign) id <MainStoreViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame city:(NSString *)city location:(CLLocationCoordinate2D) coor;

@end
