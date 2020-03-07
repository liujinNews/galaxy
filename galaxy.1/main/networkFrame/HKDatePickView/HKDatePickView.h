//
//  HKDatePickView.h
//  ChooseTime
//
//  Created by hfk on 16/5/13.
//  Copyright © 2016年 xutai. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^HKDatePickBlock)(NSString *date,NSInteger type);
@protocol HKDatePickDelegate <NSObject>
@optional
-(void)didFinishPickView:(NSString*)date withType:(NSInteger)type;
-(void)pickerviewbuttonclick:(UIButton *)sender;
-(void)hiddenPickerView;


@end


@interface HKDatePickView : UIView
@property BOOL isShow;
@property (nonatomic, copy) NSString *province;
@property(nonatomic,strong)NSDate*curDate;
@property(nonatomic,assign)NSInteger type;
@property(nonatomic,copy)NSString *formartTime;

@property (nonatomic,strong)UITextField *myTextField;
@property(nonatomic,weak)id<HKDatePickDelegate>delegate;
@property (nonatomic, strong) HKDatePickBlock block;
- (void)showInView:(UIView *)view;
- (void)hiddenPickerView;
- (id)initWithType:(NSInteger)type WithTimeFormart:(NSString *)formartTime;
@end
