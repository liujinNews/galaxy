//
//  RootViewController.h
//  galaxy
//
//  Created by hfk on 16/4/5.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "userData.h"
#import "NSString+Common.h"
#import "UIImage+ReatMark.h"
#import "NSObject+ModelToDic.h"
#import "GPClient.h"
#import "GPUtils.h"
#import "RDVTabBarController.h"
#import "NSDate+Change.h"
#import "NJKWebView.h"
#import "MyProcurementModel.h"
#import "WorkFormFieldsModel.h"
#import "EventCalendar.h"
#import "XBHepler.h"
#import "NSObject+ModelToDic.h"
#import "STOnePickDateView.h"
#import "ReserverdMainModel.h"
#import "ReserverdMainView.h"
#import "ReserverdLookMainView.h"
#import "HasSubmitDetailModel.h"
#import "FormBaseModel.h"

@protocol ByvalDelegate <NSObject>

@optional

- (id)dataSourceValues;

- (void)didFinishAcitonCallBack:(id)info;

- (void)didFinishAcitonCallBack:(id)info withObject:(id)info1;

- (void)didFinishAcitonCallBack:(id)info withObject:(id)info1 withObject:(id)info2;
@end


@interface RootViewController : UIViewController
{
    __unsafe_unretained id<ByvalDelegate>universalDelegate;
}
@property (nonatomic,assign)id<ByvalDelegate>universalDelegate;

@property (nonatomic, strong)userData *userdatas;
@property (nonatomic,assign)NSInteger backCount;
@property (nonatomic,copy)NSString *backIndex;


- (void)returnBack;
-(void)setTitle:(NSString *)title backButton:(BOOL)showBackButton;
-(void)setTitle:(NSString *)title backButton:(BOOL)showBackButton WithTitleImg:(NSString *)img;
-(void)Navback;
-(void)createOtherBackWithTag:(NSInteger)tag;
-(void)OtherBackBtn:(UIButton *)btn;

/**
 *  延迟执行
 *
 *  @param block 执行的block
 *  @param delay 延迟的时间：秒
 */
- (void)performBlock:(void(^)(void))block afterDelay:(NSTimeInterval)delay;

- (void)keyClose;

-(void)setNavigationController;
//获取当前屏幕显示的viewcontroller
+ (UIViewController *)getCurrentVC;
//转json
-(NSString*)transformToJson:(id)object;

/**
 tabbarItemClicked
 */
- (void)tabBarItemClicked;

//MARK:表单头视图(高度10)
-(UIView *)createLineView;
-(UIView *)createUpLineView;
-(UIView *)createDownLineView;
-(UIView *)createLineViewOfHeight:(CGFloat)height;
-(UIView *)createLineViewOfHeight:(CGFloat)height X:(CGFloat)x;
-(UIView *)createLineViewOfHeight_ByTitle:(CGFloat)height;

-(void)goToReSubmitWithModel:(FormBaseModel *)model;

-(void)goSubmitSuccessToWithModel:(FormBaseModel *)model;


@end
