//
//  GWPhotoBrowserViewController.h
//  Teshehui
//
//  Created by Kris on 15/10/10.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HYAfterSaleDeletePhotoDelegate <NSObject>

@optional
- (void)updatePicData:(NSMutableArray *)picData;

@end

@interface GWPhotoBrowserViewController : UIViewController

@property (nonatomic, strong) NSMutableArray *picData;
@property (nonatomic, weak) id<HYAfterSaleDeletePhotoDelegate> delegate;
@property (nonatomic, assign) NSUInteger index;

@end
