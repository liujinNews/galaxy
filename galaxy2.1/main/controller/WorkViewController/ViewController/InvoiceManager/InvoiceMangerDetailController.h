//
//  InvoiceMangerDetailController.h
//  galaxy
//
//  Created by hfk on 2017/11/23.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "VoiceBaseController.h"
#import "InvoiceManagerModel.h"
#import "EXInvoiceView.h"
#import "PdfReadViewController.h"
@interface InvoiceMangerDetailController : VoiceBaseController<UIScrollViewDelegate,GPClientDelegate>

@property (nonatomic, strong) InvoiceManagerModel *model_InvoiceDetail;
/**
 *  滚动视图
 */
@property (nonatomic,strong)UIScrollView * scrollView;
/**
 *  滚动视图contentView
 */
@property (nonatomic,strong)BottomView *contentView;
/**
 发票信息视图
 */
@property (nonatomic, strong) EXInvoiceView *exv_view;
/**
 费用类别视图
 */
@property (nonatomic, strong) UIView *View_Cate;
@property (nonatomic, strong) UITextField *txf_Cate;
@property (nonatomic, strong) UIImageView *img_category;
/**
 Pdf视图
 */
@property (nonatomic, strong) UIView *View_Pdf;
/**
 关联表单视图
 */
@property (nonatomic, strong) UIView *view_linkForm;
/**
 来源
 */
@property (nonatomic, strong) UILabel *lab_source;


@end
