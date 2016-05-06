

#import "ActionSheetStringPicker.h"
#import "DefineConfig.h"
@interface ActionSheetStringPicker()
@property (nonatomic,strong) NSArray *data;
@property (nonatomic,strong) NSMutableArray * selectedIndex;
@end

@implementation ActionSheetStringPicker

+ (instancetype)showPickerWithTitle:(NSString *)title rows:(NSArray *)strings initialSelection:(NSArray *)index doneBlock:(ActionStringDoneBlock)doneBlock cancelBlock:(ActionStringCancelBlock)cancelBlockOrNil origin:(id)origin {
    ActionSheetStringPicker * picker = [[ActionSheetStringPicker alloc] initWithTitle:title rows:strings initialSelection:index doneBlock:doneBlock cancelBlock:cancelBlockOrNil origin:origin];
    [picker showActionSheetPicker];
    return picker;
}

- (instancetype)initWithTitle:(NSString *)title rows:(NSArray *)strings initialSelection:(NSArray *)index doneBlock:(ActionStringDoneBlock)doneBlock cancelBlock:(ActionStringCancelBlock)cancelBlockOrNil origin:(id)origin {
    self = [self initWithTitle:title rows:strings initialSelection:index target:nil successAction:nil cancelAction:nil origin:origin];
    if (self) {
        self.onActionSheetDone = doneBlock;
        self.onActionSheetCancel = cancelBlockOrNil;
    }
    return self;
}

+ (instancetype)showPickerWithTitle:(NSString *)title rows:(NSArray *)data initialSelection:(NSArray *)index target:(id)target successAction:(SEL)successAction cancelAction:(SEL)cancelActionOrNil origin:(id)origin {
    ActionSheetStringPicker *picker = [[ActionSheetStringPicker alloc] initWithTitle:title rows:data initialSelection:index target:target successAction:successAction cancelAction:cancelActionOrNil origin:origin];
    [picker showActionSheetPicker];
    return picker;
}

- (instancetype)initWithTitle:(NSString *)title rows:(NSArray *)data initialSelection:(NSArray *)index target:(id)target successAction:(SEL)successAction cancelAction:(SEL)cancelActionOrNil origin:(id)origin {
    self = [self initWithTarget:target successAction:successAction cancelAction:cancelActionOrNil origin:origin];
    if (self) {
        self.data = data;
        self.selectedIndex = [NSMutableArray arrayWithArray:index];
        self.title = title;
    }
    return self;
}


- (UIView *)configuredPickerView {
    if (!self.data)
        return nil;
    CGRect pickerFrame = CGRectMake(0, 40, self.viewSize.width, 216);
    UIPickerView *stringPicker = [[UIPickerView alloc] initWithFrame:pickerFrame];
    stringPicker.delegate = self;
    stringPicker.dataSource = self;
    for (int i=0; i<self.selectedIndex.count; i++) {
        NSNumber *curSelectedIndex = [self.selectedIndex objectAtIndex:i];
        [stringPicker selectRow:curSelectedIndex.integerValue inComponent:i animated:NO];
    }
    if (self.data.count == 0) {
        stringPicker.showsSelectionIndicator = NO;
        stringPicker.userInteractionEnabled = NO;
    } else {
        stringPicker.showsSelectionIndicator = YES;
        stringPicker.userInteractionEnabled = YES;
    }
    
    //need to keep a reference to the picker so we can clear the DataSource / Delegate when dismissing
    self.pickerView = stringPicker;
    
    return stringPicker;
}

- (void)notifyTarget:(id)target didSucceedWithAction:(SEL)successAction origin:(id)origin {    
    if (self.onActionSheetDone) {
        NSMutableArray *selectedObject = [[NSMutableArray alloc] init];
        
        NSArray *curData = self.data.firstObject;
        NSNumber *curSelectedIndex = self.selectedIndex.firstObject;
        [selectedObject addObject:(curData)[curSelectedIndex.integerValue]];
        
        if (self.selectedIndex.count > 1) {
            curData = [self.data.lastObject objectForKey:(curData)[curSelectedIndex.integerValue]];
            curSelectedIndex = self.selectedIndex.lastObject;
            [selectedObject addObject:(curData)[curSelectedIndex.integerValue]];
        }
        _onActionSheetDone(self, self.selectedIndex, selectedObject);
        return;
    }
    else if (target && [target respondsToSelector:successAction]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [target performSelector:successAction withObject:self.selectedIndex withObject:origin];
#pragma clang diagnostic pop
        return;
    }
    NSLog(@"Invalid target/action ( %s / %s ) combination used for ActionSheetPicker", object_getClassName(target), sel_getName(successAction));
}

- (void)notifyTarget:(id)target didCancelWithAction:(SEL)cancelAction origin:(id)origin {
    if (self.onActionSheetCancel) {
        _onActionSheetCancel(self);
        return;
    }
    else if (target && cancelAction && [target respondsToSelector:cancelAction]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [target performSelector:cancelAction withObject:origin];
#pragma clang diagnostic pop
    }
}

#pragma mark - UIPickerViewDelegate / DataSource

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    [self.selectedIndex replaceObjectAtIndex:component withObject:[NSNumber numberWithInteger:row]];
    if (component == 0 && self.data.count > 1) {
        [pickerView reloadComponent:1];
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return self.data.count;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSArray *curComponentData;
    if (component == 0) {
        curComponentData = (self.data)[(NSUInteger) component];
    }else{
        NSNumber *curSelectedIndex = self.selectedIndex.firstObject;
        curComponentData = [self.data.lastObject objectForKey:[self.data.firstObject objectAtIndex:curSelectedIndex.intValue]];
    }
    return curComponentData.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSArray *curComponentData;
    if (component == 0) {
        curComponentData = (self.data)[(NSUInteger) component];
    }else{
        NSNumber *curSelectedIndex = self.selectedIndex.firstObject;
        curComponentData = [self.data.lastObject objectForKey:[self.data.firstObject objectAtIndex:curSelectedIndex.intValue]];
    }
    id obj = (curComponentData)[(NSUInteger) row];

    // return the object if it is already a NSString,
    // otherwise, return the description, just like the toString() method in Java
    // else, return nil to prevent exception

    if ([obj isKindOfClass:[NSString class]])
        return obj;

    if ([obj respondsToSelector:@selector(description)])
        return [obj performSelector:@selector(description)];

    return nil;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return (kScreen_Width/self.data.count);
}


@end