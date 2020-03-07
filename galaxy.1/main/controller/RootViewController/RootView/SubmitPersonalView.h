//
//  SubmitPersonalView.h
//  galaxy
//
//  Created by hfk on 2017/12/2.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SubmitPersonalModel.h"
#import "ChangePhoneNumController.h"
#import "FormBaseModel.h"
@interface SubmitPersonalView : UIView
/**
 *  申请人带图片的视图
 */
@property(nonatomic,strong)UIView *View_RequestorImg;
/**
 *  填表人视图
 */
@property(nonatomic,strong)UIView *OperatorView;
/**
 *  填表人视图tf
 */
@property(nonatomic,strong)UITextField *txf_Operator;
/**
 *  填表人部门视图
 */
@property(nonatomic,strong)UIView *OperatorDeptView;
/**
 *  填表人部门txf
 */
@property(nonatomic,strong)UITextField *txf_OperatorDept;
/**
 *  申请人视图
 */
@property(nonatomic,strong)UIView *RequestorView;
/**
 *  申请人tf
 */
@property(nonatomic,strong)UITextField *txf_Requestor;
/**
 *  联系方式视图
 */
@property(nonatomic,strong)UIView *ContectView;
/**
 *  联系方式Label
 */
@property(nonatomic,strong)UITextField *txf_Contect;
/**
 *  部门视图
 */
@property(nonatomic,strong)UIView *DepartmentView;
/**
 *  部门
 */
@property(nonatomic,strong)UITextField *txf_Department;
/**
 *  职位视图
 */
@property(nonatomic,strong)UIView *PositionView;
/**
 *  职位label
 */
@property(nonatomic,strong)UITextField *txf_Position;
/**
 *  级别视图
 */
@property(nonatomic,strong)UIView *View_UserLevel;
/**
 *  级别label
 */
@property(nonatomic,strong)UITextField *txf_UserLevel;
/**
 *  员工工号视图
 */
@property(nonatomic,strong)UIView *View_EmployeeNo;
/**
 *  员工工号label
 */
@property(nonatomic,strong)UITextField *txf_EmployeeNo;
/**
 * 公司视图
 */
@property(nonatomic,strong)UIView *View_BranchCompany;
/**
 *  公司label
 */
@property(nonatomic,strong)UITextField *txf_BranchCompany;
/**
 *  成本中心视图
 */
@property(nonatomic,strong)UIView *View_CostCenter;
/**
 *  成本中心Label
 */
@property(nonatomic,strong)UITextField *txf_CostCenter;
/**
 * 业务部门视图
 */
@property(nonatomic,strong)UIView *View_BDivision;
/**
 *  业务部门label
 */
@property(nonatomic,strong)UITextField *txf_BDivision;
/**
 * 地区视图
 */
@property(nonatomic,strong)UIView *View_Area;
/**
 *  地区label
 */
@property(nonatomic,strong)UITextField *txf_Area;

/**
 * 办事处视图
 */
@property(nonatomic,strong)UIView *View_Location;
/**
 *  办事处label
 */
@property(nonatomic,strong)UITextField *txf_Location;

/**
 *  员工自定义字段
 */
@property(nonatomic,strong)UIView *View_Personal_Fir;
@property(nonatomic,strong)UITextField *txf_Personal_Fir;
@property(nonatomic,strong)UIView *View_Personal_Sec;
@property(nonatomic,strong)UITextField *txf_Personal_Sec;
@property(nonatomic,strong)UIView *View_Personal_Thir;
@property(nonatomic,strong)UITextField *txf_Personal_Thir;
@property(nonatomic,strong)UIView *View_Personal_Four;
@property(nonatomic,strong)UITextField *txf_Personal_Four;
@property(nonatomic,strong)UIView *View_Personal_Fif;
@property(nonatomic,strong)UITextField *txf_Personal_Fif;
@property(nonatomic,strong)UIView *View_Personal_Six;
@property(nonatomic,strong)UITextField *txf_Personal_Six;
@property(nonatomic,strong)UIView *View_Personal_Sev;
@property(nonatomic,strong)UITextField *txf_Personal_Sev;
@property(nonatomic,strong)UIView *View_Personal_Eig;
@property(nonatomic,strong)UITextField *txf_Personal_Eig;
@property(nonatomic,strong)UIView *View_Personal_Nin;
@property(nonatomic,strong)UITextField *txf_Personal_Nin;
@property(nonatomic,strong)UIView *View_Personal_Ten;
@property(nonatomic,strong)UITextField *txf_Personal_Ten;
/**
 *  申请日期视图
 */
@property(nonatomic,strong)UIView *ApplyDataView;

@property(nonatomic,strong)NSMutableArray *dateArray;
@property(nonatomic,strong)NSMutableDictionary *requireDict;
@property(nonatomic,strong)NSMutableArray *unShowArray;
@property(nonatomic,strong)VoiceBaseController *baseController;
@property(nonatomic,strong)FormBaseModel *baseModel;
@property (nonatomic, assign) NSInteger int_RequestorLine;//申请人底下是否有线
//申请人返回数据
@property (nonatomic, copy) void(^SubmitPersonalViewBackBlock)(id backObj);

/**
 提交页面申请人信息视图

 @param dateArray 表单显示数据
 @param requireDict 必填项判断
 @param unShowArray 表单不显示数组
 @param personalModel 个人信息Model
 @param baseController 当前controller
 */
-(void)initSubmitPersonalViewWithDate:(NSMutableArray *)dateArray WithRequireDict:(NSMutableDictionary *)requireDict WithUnShowArray:(NSMutableArray *)unShowArray WithSumbitBaseModel:(FormBaseModel *)baseModel Withcontroller:(VoiceBaseController *)baseController;


/**
 查看页面申请人信息视图

 @param dateArray 表单显示数据
 @param baseModel 表单数据
 @param type 1差旅日常专项中 2其他

 */
-(void)initOnlyApprovePersonalViewWithDate:(NSMutableArray *)dateArray WithApproveModel:(FormBaseModel *)baseModel withType:(NSInteger)type;

/**
  查看审批页面申请人信息视图

 @param dateArray 表单显示数据
 @param personalModel 个人信息Model
 */
-(void)initApprovePersonalViewWithDate:(NSMutableArray *)dateArray WithSumbitBaseModel:(FormBaseModel *)baseModel;

@end
