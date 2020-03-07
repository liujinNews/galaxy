//
//  FilterBaseViewController.h
//  galaxy
//
//  Created by hfk on 16/8/9.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "RootViewController.h"
#import "FilterBaseCell.h"
#import "MyApprovalFilterController.h"
#import "MyApplyFilterResultController.h"

@interface FilterBaseViewController : RootViewController<UIScrollViewDelegate,GPClientDelegate,UICollectionViewDelegate,UICollectionViewDataSource,chooseTravelDateViewDelegate,UITextFieldDelegate>
/**
 *  下部按钮底层视图
 */
@property (nonatomic, strong) UIView *dockView;
/**
 *  重置按钮
 */
@property(nonatomic,strong)UIButton *resetBtn;
/**
 *  确定按钮
 */
@property(nonatomic,strong)UIButton *sureBtn;
/**
 *  滚动视图
 */
@property (nonatomic,strong)UIScrollView * scrollView;
/**
 *  滚动视图contentView
 */
@property (nonatomic,strong)UIView *contentView;
/**
 *  选择视图
 */
@property (nonatomic,strong)UIView *View_Collect;
/**
 *  网格视图
 */
@property(nonatomic,strong)UICollectionView *collView;
/**
 *  网格规则
 */
@property(nonatomic,strong)UICollectionViewFlowLayout *layOut;
/**
 *  网格cell
 */
@property(nonatomic,strong)FilterBaseCell *cell;
/**
 *  公司视图
 */
@property (nonatomic,strong)UIView *View_Branch;
@property (nonatomic,strong)UITextField *txf_Branch;
@property (nonatomic,copy)NSString *str_BranchId;
/**
 *  申请人视图
 */
@property (nonatomic,strong)UIView *View_Apply;
@property (nonatomic,strong)UITextField *ApplyPeopleTF;
/**
 *  部门视图
 */
@property (nonatomic,strong)UIView *View_Department;
@property (nonatomic,strong)UITextField *DepartmentTF;
/**
 *  成本中心视图
 */
@property (nonatomic,strong)UIView *View_CostCenter;
@property (nonatomic,strong)UITextField *txf_CostCenter;
@property (nonatomic,copy)NSString *str_CostCenterId;

/**
 *  单号视图
 */
@property (nonatomic,strong)UIView *View_SerialNo;
/**
 *  单号输入框
 */
@property (nonatomic,strong)UITextField *SerialNoTF;
/**
 *  标题视图
 */
@property (nonatomic,strong)UIView *View_TaskName;
/**
 *  标题输入框
 */
@property (nonatomic,strong)UITextField *txf_TaskName;
/**
 *  时间选择视图
 */
@property (nonatomic,strong)UIView *View_Time;
@property (nonatomic,strong)UITextField *startTimeTxf;
@property (nonatomic,strong)UITextField *endTimeTxf;
/**
 *  开始日期选择结果
 */
@property(nonatomic,strong)NSString *startSelectData;
/**
 *  结束日期选择结果
 */
@property(nonatomic,strong)NSString *endSelectData;
/**
 *  审批完成视图
 */
@property (nonatomic,strong)UIView *View_FinishData;
@property (nonatomic,strong)UITextField *finishDateSTxf;
@property (nonatomic,strong)UITextField *finishDateETxf;
/**
 *  开始日期选择结果
 */
@property(nonatomic,strong)NSString *finishDateS;
/**
 *  结束日期选择结果
 */
@property(nonatomic,strong)NSString *finishDateE;
/**
 *  日期选择视图
 */
@property (nonatomic,strong)UIDatePicker * datePicker;
/**
 *  日期选择底层视图
 */
@property (nonatomic,strong)chooseTravelDateView *DateChooseView;
/**
 *  金额视图
 */
@property (nonatomic,strong)UIView *View_Amount;
/**
 *  金额输入框
 */
@property (nonatomic,strong)UITextField *StartAmountTF;
/**
 *  金额输入框
 */
@property (nonatomic,strong)UITextField *EndAmountTF;

@property(nonatomic,assign)NSInteger btnIndex;




@property(nonatomic,strong)NSMutableArray *mainArray;
@property(nonatomic,strong)NSMutableArray *firstArray;//流程
@property(nonatomic,strong)NSMutableArray *secondArray;//审批状态
@property(nonatomic,strong)NSMutableArray *thirdArray;//支付状态

@property(nonatomic,strong)NSString *firstSelect;
@property(nonatomic,strong)NSString *secondSelect;
@property(nonatomic,strong)NSString *thirdSelect;
@property(nonatomic,assign)NSInteger collectHeight;





@property (nonatomic, copy) void (^block)(NSDictionary *dict);


-(id)initWithType:(NSString *)type;
@end

