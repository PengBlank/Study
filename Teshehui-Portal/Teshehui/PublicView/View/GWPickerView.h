//
//  GWPickerView.h
//  Teshehui
//
//  Created by Kris on 15/11/4.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GWPickerViewDelegate;

@interface GWPickerView : UIView
<
UIPickerViewDelegate,
UIPickerViewDataSource
>
@property (nonatomic, weak) id<GWPickerViewDelegate> delegate;
@property (nonatomic, copy, readonly) NSString *pickResult;
@property (nonatomic, copy, readonly) NSString *pickIdCode;
@property (nonatomic, copy, readonly) NSString *pickInsuranceCode;
@property (nonatomic, copy, readonly) NSString *pickinsuranceProvision;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) NSMutableArray *idList;
@property (nonatomic, strong) NSMutableArray *insuranceList;

- (void)showWithAnimation:(BOOL)animation;
- (void)dismissWithAnimation:(BOOL)animation;

@end

@protocol GWPickerViewDelegate <NSObject>

@optional
- (void)pickerCancel;
- (void)selectComplete:(GWPickerView *)pickerView forIndexPath:(NSIndexPath *)indexPath;
@end
