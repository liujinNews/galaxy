//
//  VoiceBaseController.h
//  galaxy
//
//  Created by hfk on 16/4/26.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "RootViewController.h"
#import "iflyMSC/iflyMSC.h"
#import "iflyMSC/IFlySpeechRecognizerDelegate.h"
#import "iflyMSC/IFlySpeechRecognizer.h"
#import "ISRDataHelper.h"
#import "IATConfig.h"
#import "ZLPhotoPickerBrowserViewController.h"
#import "ProcureCollectCell.h"
#import "JKAlertDialog.h"
#import "BottomView.h"
#import "boWebViewController.h"
#import "ReservedView.h"
#import "MasterListViewController.h"
#import "SubmitFormView.h"
#import "FlowChartView.h"
#import "DoneBtnView.h"
#import "IQKeyboardManager.h"
#import "IQKeyboardReturnKeyHandler.h"
#import "SendEmailModel.h"
#import "FormSignInfoView.h"

@interface VoiceBaseController : RootViewController<IFlyRecognizerViewDelegate>
{
    UITextView *_remarksTextView;
    UITextField *_remarkTipField;
    UIButton *_remarkVoiceBtn;
    /**
     *  带界面的识别对象
     */
    IFlyRecognizerView *_iflyRecognizerView;
    /**
     *  语音是否取消
     */
    BOOL _isCanceled;
    /**
     *  语音结果
     */
    NSString *_result;
    IQKeyboardReturnKeyHandler *returnHandler;

}
-(void)startVoice;

/**
 *  图片展示
 */
@property(nonatomic,strong)NSMutableArray *showImageArray;
@property(nonatomic,strong)UICollectionView *imgCollectView;
@property(nonatomic,strong)ProcureCollectCell *Imagecell;
@property(nonatomic,strong)UIButton *PrintfBtn;

//@param array 包含(1:转交 2:抄送 3:打印)
@property(nonatomic,strong)NSArray *arr_MoreBtn;
@property(nonatomic,strong)NSDictionary *dict_MoreBtnDict;
/**
 打印
 @param message 打印地址
 */
-(void)createPrintNoticeWithMessage:(NSString *)message;

/**
 创建更多的按钮
 @param array 包含(1:转交 2:抄送 3:打印)
 @param dict 参数
 */
-(void)createMoreBtnWithArray:(NSArray *)array WithDict:(NSDictionary *)dict;

-(void)GoToDeliver;
-(void)GoToCopy;
-(void)GoToPush;

-(void)updateAprovalProcess:(NSString *)flowCode WithProcId:(NSString *)procid;

-(void)gotoPrintfForm:(SendEmailModel *)model;

-(void)LookViewLinkToFormWithTaskId:(NSString *)taskId WithFlowCode:(NSString *)flowCode;

-(void)goToFlowChartWithUrl:(NSString *)url;

@end
