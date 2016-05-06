
//

#import "AbstractActionSheetPicker.h"

@class ActionSheetStringPicker;
typedef void(^ActionStringDoneBlock)(ActionSheetStringPicker *picker, NSArray *selectedIndex, NSArray *selectedValue);
typedef void(^ActionStringCancelBlock)(ActionSheetStringPicker *picker);

@interface ActionSheetStringPicker : AbstractActionSheetPicker <UIPickerViewDelegate, UIPickerViewDataSource>
/**
 *  Create and display an action sheet picker.
 *
 *  @param title             Title label for picker
 *  @param data              is an array of strings to use for the picker's available selection choices
 *  @param index             is used to establish the initially selected row;
 *  @param target            must not be empty.  It should respond to "onSuccess" actions.
 *  @param successAction
 *  @param cancelActionOrNil cancelAction
 *  @param origin            must not be empty.  It can be either an originating container view or a UIBarButtonItem to use with a popover arrow.
 *
 *  @return  return instance of picker
 */
+ (instancetype)showPickerWithTitle:(NSString *)title rows:(NSArray *)data initialSelection:(NSArray *)index target:(id)target successAction:(SEL)successAction cancelAction:(SEL)cancelActionOrNil origin:(id)origin;

    // Create an action sheet picker, but don't display until a subsequent call to "showActionPicker".  Receiver must release the picker when ready. */
- (instancetype)initWithTitle:(NSString *)title rows:(NSArray *)data initialSelection:(NSArray *)index target:(id)target successAction:(SEL)successAction cancelAction:(SEL)cancelActionOrNil origin:(id)origin;



+ (instancetype)showPickerWithTitle:(NSString *)title rows:(NSArray *)strings initialSelection:(NSArray *)index doneBlock:(ActionStringDoneBlock)doneBlock cancelBlock:(ActionStringCancelBlock)cancelBlock origin:(id)origin;

- (instancetype)initWithTitle:(NSString *)title rows:(NSArray *)strings initialSelection:(NSArray *)index doneBlock:(ActionStringDoneBlock)doneBlock cancelBlock:(ActionStringCancelBlock)cancelBlockOrNil origin:(id)origin;

@property (nonatomic, copy) ActionStringDoneBlock onActionSheetDone;
@property (nonatomic, copy) ActionStringCancelBlock onActionSheetCancel;

@end