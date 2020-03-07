//
//  ReimShareController.h
//  galaxy
//
//  Created by hfk on 2017/9/18.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "VoiceBaseController.h"
#import "ReimShareModel.h"
#import "CategoryCollectCell.h"
#import "CostCateNewModel.h"
#import "STPickerCategory.h"
#import "ChooseCategoryModel.h"
#import "ExpenseCodeListViewController.h"
@protocol ReimShareDelegate <NSObject>
@optional
-(void)ReimShareData:(ReimShareModel *)model WithType:(NSInteger)type;
@end
@interface ReimShareController : VoiceBaseController<UIScrollViewDelegate,UITextFieldDelegate,UITextViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,GPClientDelegate>

@property(weak,nonatomic)id<ReimShareDelegate>delegate ;
/**
 *  请求结果字典
 */
@property (nonatomic,strong)NSDictionary *resultDict;

/**
 *  滚动视图
 */
@property (nonatomic,strong)UIScrollView * scrollView;
/**
 *  滚动视图contentView
 */
@property (nonatomic,strong)BottomView *contentView;
/**
 *  底部按钮视图
 */
@property (nonatomic,strong)DoneBtnView * dockView;

/**
 * 公司视图
 */
@property(nonatomic,strong)UIView *View_BranchCompany;
/**
 *  公司label
 */
@property(nonatomic,strong)UITextField *txf_BranchCompany;
///**
// *  公司Id
// */
//@property(nonatomic,copy)NSString *BranchId;
///**
// *  公司名称
// */
//@property(nonatomic,copy)NSString *Branch;
/**
 *  部门视图
 */
@property(nonatomic,strong)UIView *DepartmentView;

/**
 *  部门
 */
@property(nonatomic,strong)UITextField *txf_Department;
///**
// *  部门Id
// */
//@property(nonatomic,copy)NSString *DepartmentId;
///**
// *  部门名称
// */
//@property(nonatomic,copy)NSString *Department;
/**
 * 业务部门视图
 */
@property(nonatomic,strong)UIView *View_BDivision;
/**
 *  业务部门label
 */
@property(nonatomic,strong)UITextField *txf_BDivision;
///**
// *  业务部门Id
// */
//@property(nonatomic,copy)NSString *BDivisionId;
///**
// *  业务部门名称
// */
//@property(nonatomic,copy)NSString *BDivision;
/**
 *  成本中心视图
 */
@property(nonatomic,strong)UIView *CostCenterView;
/**
 *  成本中心Label
 */
@property(nonatomic,strong)UITextField *txf_CostCenter;
///**
// *  成本中心Id
// */
//@property(nonatomic,copy)NSString *CostCenterId;
///**
// *  成本中心名称
// */
//@property(nonatomic,copy)NSString *CostCenter;
/**
 *  项目名称视图
 */
@property(nonatomic,strong)UIView *ProjectView;
/**
 *  项目名称Label
 */
@property(nonatomic,strong)UITextField *txf_Project;
///**
// *  项目Id
// */
//@property(nonatomic,copy)NSString *ProjId;
///**
// *  项目名称
// */
//@property(nonatomic,copy)NSString *ProjName;
///**
// *  项目负责人id
// */
//@property(nonatomic,copy)NSString *ProjMgrId;
///**
// *  项目负责人姓名
// */
//@property(nonatomic,copy)NSString *ProjMgrName;
/**
 *  费用类别视图
 */
@property(nonatomic,strong)UIView *View_Cate;
/**
 *  费用类别Label
 */
@property (nonatomic,strong)UITextField * txf_Cate;
/**
 *  费用类别图片
 */
@property(nonatomic,strong)UIImageView * categoryImage;
/**
 *  费用类别
 */
@property(nonatomic,strong)NSMutableArray * categoryArr;

/**
 *  记一笔费用类别是否分级(1/2)
 */
@property(nonatomic,strong)NSString *CateLevel;
/**
 *  费用类型是否打开的
 */
@property(nonatomic,assign)BOOL isOpenGener;
/**
 *  费用类别
 */
@property(nonatomic,assign)NSInteger categoryRows;

///**
// 费用类别相关数据
// */
//@property(nonatomic,copy)NSString *ExpenseCode;
//@property(nonatomic,copy)NSString *ExpenseType;
//@property(nonatomic,copy)NSString *ExpenseIcon;
//@property(nonatomic,copy)NSString *ExpenseCatCode;
//@property(nonatomic,copy)NSString *ExpenseCat;
/**
 *  费用类别选择视图
 */
@property(nonatomic,strong)UIView *CategoryView;
/**
 *  费用类别collectView
 */
@property(nonatomic,strong)UICollectionView *CategoryCollectView;
@property(nonatomic,strong)UICollectionViewFlowLayout *CategoryLayOut;
@property(nonatomic,strong)CategoryCollectCell *cell;

/**
 *  自定义字段
 */
@property(nonatomic,strong)UIView *View_Reserved;
/**
 自定义字段Model
 */
@property (nonatomic, strong) ReserverdMainModel *model_ReserverModel;
/**
 *  借款金额视图
 */
@property(nonatomic,strong)UIView *acountView;
/**
 *  借款金额输入框
 */
@property (nonatomic,strong)GkTextField * txf_Acount;
/**
 *  备注视图
 */
@property(nonatomic,strong)UIView *RemarkView;
/**
 *  备注输入框
 */
@property(nonatomic,strong)UITextView *txv_Remark;


@property(nonatomic,strong)NSMutableArray *ShareFormArray;
@property(nonatomic,strong)NSMutableDictionary *isRequiredmsdic,*isCtrlTypdic,*reservedDic;
@property(nonatomic,strong)ReimShareModel *model;
/**
 *  可能验证显示数组
 */
@property(nonatomic,strong)NSMutableArray *isShowmsArray;
/**
 *  不显示数组
 */
@property(nonatomic,strong)NSMutableArray *UnShowmsArray;

//1差旅2日常3专项4付款
@property(nonatomic,assign)NSInteger comeplace;
//1新增2修改
@property(nonatomic,assign)NSInteger type;


@end

