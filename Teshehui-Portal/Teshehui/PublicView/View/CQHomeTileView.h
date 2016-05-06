//
//  CQHomeTileView.h
//  Teshehui
//
//  Created by ChengQian on 13-10-25.
//  Copyright (c) 2013年 Charse. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum _kHomeTileType {
    ShoppingMall = 1,   //商城
    Flight ,  //头等舱
    Flowers,   //鲜花
    CheapFlight,  //经济舱
    Hotels  //酒店
}kHomeTileType;

@protocol CQHomeTileViewDelegate;

@interface CQHomeTileView : UIView

@property (nonatomic, assign) id<CQHomeTileViewDelegate> delegate;
@property (nonatomic, assign, readonly) kHomeTileType type;
@property (nonatomic, strong, readonly) UIImageView *iconeView;
@property (nonatomic, strong, readonly) UILabel *titleLabel;

- (id)initWithFrame:(CGRect)frame type:(kHomeTileType)type;

@end

@protocol CQHomeTileViewDelegate <NSObject>

@optional

- (void)didClckTileView:(CQHomeTileView *)view;

@end
