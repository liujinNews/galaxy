//
//  SubmitFormView.h
//  galaxy
//
//  Created by hfk on 2017/7/13.
//  Copyright © 2017年 赵碚. All rights reserved.
//

typedef NS_ENUM(NSUInteger, formViewType) {
    formViewShowText=0,
    formViewShowAmount,
    formViewSelect,
    formViewLookSelect,
    formViewSelectCate,
    formViewShowCate,
    formViewSelectTime,
    formViewSelectDate,
    formViewSelectDateTime,
    formViewSelectYearDateTime,
    formViewEnterText,
    formViewEnterAmout,
    formViewEnterNegAmout,
    formViewEnterExchange,
    formViewEnterNum,
    formViewEnterDays,
    formViewEnterHalfNum,
    formViewEnterTextView,
    formViewVoiceTextView,
    formViewVoiceNoTitleTextView,
    formViewLongTextView,
    formViewShowAppover,
    formViewOnlySelect,
    formViewBankAccount

};

typedef NS_ENUM(NSUInteger, segmentType) {
    lineViewNone=0,
    lineViewOnlyLine,
    lineViewLine,
    lineViewDownLine,
    lineViewUpLine,
    lineViewNoneLine
};


#import <UIKit/UIKit.h>
#import "HKDatePickView.h"

@interface SubmitFormView : UIView<UITextViewDelegate,chooseTravelDateViewDelegate,UITextFieldDelegate,IFlyRecognizerViewDelegate,HKDatePickDelegate>
@property (nonatomic, strong) UIView *baseView;
@property (nonatomic, strong) UITextField *txfield_content;
@property (nonatomic, strong) UITextView *txview_content;
@property (nonatomic, strong) UITextField *txv_subview;
@property (nonatomic, strong) UILabel *lab_title;
@property (nonatomic, strong) UIImageView *img_des;
@property (nonatomic, strong) UIImageView *img_cate;
@property (nonatomic, strong) UIButton *selectBtn;
@property (nonatomic,assign)  formViewType curFormViewType;
@property (nonatomic,assign)  segmentType curSegmentType;
@property (nonatomic, strong) NSDictionary *InfoDict;
@property (nonatomic, strong) UIView *SegmentLineView;
@property (nonatomic, assign) NSInteger height;
@property (nonatomic, strong) MyProcurementModel *model;
@property (nonatomic,strong)UIDatePicker * datePicker;
@property (nonatomic,strong)chooseTravelDateView *DateChooseView;
/**
 选择日期的格式
 */
@property(nonatomic,strong)NSString *formatter_SelectTime;
/**
 日期选择model
 */
@property(nonatomic,assign)UIDatePickerMode model_DatePick;
/**
 *  日期选择结果
 */
@property(nonatomic,strong)NSString *selectDataString;

@property (nonatomic, strong) NSString *cateImg;




@property (nonatomic,strong)  IFlyRecognizerView *iflyRecognizerView;

@property (copy, nonatomic) void(^FormClickedBlock)(MyProcurementModel *model);

@property (copy, nonatomic) void(^ApproverClickedBlock)(MyProcurementModel *model, UIImageView *image);

@property (copy, nonatomic) void(^CateClickedBlock)(MyProcurementModel *model, UIImageView *image);

@property (copy, nonatomic) void(^TextChangedBlock)(NSString *text);

@property (copy, nonatomic) void(^AmountChangedBlock)(NSString *amount);

@property (copy, nonatomic) void(^ExchangeChangedBlock)(NSString *exchange);

@property (copy, nonatomic) void(^TimeClickedBlock)(MyProcurementModel *model, NSString *selectTime);

@property (copy, nonatomic) void(^viewClickedBackBlock)(id object);

@property (assign, nonatomic)NSInteger OtherHeight;



@property(nonatomic,strong)UILabel *DuringMonthDayLabel;

@property(nonatomic,strong)UILabel *DuringTimeLabel;


@property(nonatomic,strong)NSString *DuringFormat;

@property(nonatomic,strong)NSString *DuringTime;
@property(nonatomic,assign)NSInteger DuringType;

@property(nonatomic,strong)HKDatePickView *DuringDatePicker;
@property (copy, nonatomic) void(^ChooseTimeBlock)(NSString *time, NSInteger type);


-(SubmitFormView *)initBaseView:(UIView *)baseView WithContent:(id)txf  WithFormType:(formViewType)formViewType WithSegmentType:(segmentType)segmentType Withmodel:(MyProcurementModel *)model WithInfodict:(NSDictionary *)dict;
-(SubmitFormView *)initBaseView:(UIView *)baseView WithContent:(id)txf  WithFormType:(formViewType)formViewType WithSegmentType:(segmentType)segmentType WithString:(NSString *)string WithTips:(NSString *)tips WithInfodict:(NSDictionary *)dict;

-(SubmitFormView *)initBaseView:(UIView *)baseView WithContent:(id)txf  WithFormType:(formViewType)formViewType WithSegmentType:(segmentType)segmentType WithString:(NSString *)string WithInfodict:(NSDictionary *)dict WithTips:(NSString *)tips WithNumLimit:(NSInteger)enterLimit;
-(SubmitFormView *)initAddBtbWithBaseView:(UIView *)baseView withTitle:(NSString *)title withTitleAlignment:(NSInteger)alignment withImageArray:(NSArray *)imgArray withBtnLocation:(NSInteger)location withlineStyle:(NSInteger)lineStyle;

-(SubmitFormView *)initDuringTimeViewWithBaseView:(UIView *)baseView Withmodel:(MyProcurementModel *)model WithType:(NSInteger)DuringType WithTimeFormart:(NSString *)DuringFormat WithFormType:(formViewType)formViewType;


-(SubmitFormView *)initWithBaseView:(UIView *)baseView WithSwitch:(UISwitch *)swh WithString:(NSString *)string WithInfo:(BOOL)isOpen WithTips:(NSString *)tips;

@end
