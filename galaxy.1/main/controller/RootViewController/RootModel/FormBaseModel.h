//
//  FormBaseModel.h
//  galaxy
//
//  Created by hfk on 2017/12/7.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SubmitPersonalModel.h"
#import "STOnePickModel.h"
#import "ReserverdMainModel.h"

@interface FormBaseModel : NSObject

@property (nonatomic,strong) NSDictionary *dict_resultDict;


@property (nonatomic, copy) NSString *str_directType;

@property (nonatomic, copy) NSString *str_lastAmount;

@property (nonatomic, strong) SubmitPersonalModel *personalData;

@property (nonatomic, strong) ReserverdMainModel *model_ReserverModel;


@property (nonatomic, strong) NSMutableDictionary *dict_isRequiredmsdic,*dict_isCtrlTypdic;



@property (nonatomic, strong) NSMutableArray *arr_isShowmsArray;

@property (nonatomic, strong) NSMutableArray *arr_UnShowmsArray;

@property (nonatomic, strong) NSMutableDictionary *dict_reservedDic;

@property (nonatomic, strong) NSMutableArray *arr_FormMainArray;



@property (nonatomic, assign) BOOL bool_DetailsShow;



@property (nonatomic, strong) NSMutableArray *arr_DetailsArray;


@property (nonatomic, strong) NSMutableArray *arr_DetailsDataArray;


@property (nonatomic, strong) NSMutableDictionary *dict_isRequiredmsDetaildic;


@property (nonatomic, strong) NSMutableArray *arr_isShowmDetailArray;



@property (nonatomic, assign) BOOL bool_SecDetailsShow;



@property (nonatomic, strong) NSMutableArray *arr_SecDetailsArray;


@property (nonatomic, strong) NSMutableArray *arr_SecDetailsDataArray;


@property (nonatomic, strong) NSMutableDictionary *dict_SecisRequiredmsDetaildic;


@property (nonatomic, strong) NSMutableArray *arr_SecisShowmDetailArray;





@property (nonatomic, assign) BOOL bool_ThirDetailsShow;



@property (nonatomic, strong) NSMutableArray *arr_ThirDetailsArray;


@property (nonatomic, strong) NSMutableArray *arr_ThirDetailsDataArray;


@property (nonatomic, strong) NSMutableDictionary *dict_ThirisRequiredmsDetaildic;


@property (nonatomic, strong) NSMutableArray *arr_ThirisShowmDetailArray;

@property (nonatomic, assign) BOOL bool_ThirdHaveAttchs;

@property (nonatomic, assign) BOOL bool_FouDetailsShow;

@property (nonatomic, strong) NSMutableArray *arr_FouDetailsArray;

@property (nonatomic, strong) NSMutableArray *arr_FouDetailsDataArray;

@property (nonatomic, strong) NSMutableDictionary *dict_FouisRequiredmsDetaildic;

@property (nonatomic, strong) NSMutableArray *arr_FouisShowmDetailArray;

@property (nonatomic, assign) BOOL bool_FourthHaveAttchs;



@property (nonatomic, copy) NSString *str_SupplierParam;


@property (nonatomic, strong) MyProcurementModel *model_ApprovelPeoModel;
@property (nonatomic, strong) MyProcurementModel *model_ApprovalMode;


@property (nonatomic, strong) NSMutableArray *arr_CurrencyCode;


@property (nonatomic, strong) NSDictionary *dict_CurrencyCodeParameter;


@property (nonatomic, copy) NSString *str_CurrencyCode;


@property (nonatomic, copy) NSString *str_Currency;


@property (nonatomic, copy) NSString *str_ExchangeRate;


@property (nonatomic, strong) NSMutableArray *arr_TaxRates;


@property (nonatomic, copy) NSString *str_imageDataString;


@property (nonatomic, strong) NSMutableArray *arr_imagesArray;


@property (nonatomic, strong) NSMutableArray *arr_totalFileArray;


@property (nonatomic, copy) NSString *str_firstHanderId;

@property (nonatomic, copy) NSString *str_firstHanderPhotoGraph;


@property (nonatomic, copy) NSString *str_firstHandlerGender;


@property (nonatomic, copy) NSString *str_firstHanderName;


@property (nonatomic, copy) NSString *str_CcUsersId;


@property (nonatomic, copy) NSString *str_CcUsersName;


@property (nonatomic, strong) NSMutableArray * arr_CategoryArr;


@property (nonatomic, strong) NSDictionary * dict_CategoryParameter;

//费用类别
@property (nonatomic, copy) NSString *str_ExpenseCode;
@property (nonatomic, copy) NSString *str_ExpenseType;
@property (nonatomic, copy) NSString *str_ExpenseIcon;
@property (nonatomic, copy) NSString *str_ExpenseCatCode;
@property (nonatomic, copy) NSString *str_ExpenseCat;
//关联费用申请单
@property(nonatomic,strong)NSString *str_FeeAppNumber;//费用申请单ID
@property(nonatomic,strong)NSString *str_FeeAppInfo;//费用申请单ID


@property (nonatomic, strong) NSMutableArray *arr_noteDateArray;


@property (nonatomic, strong) NSDictionary *dict_parametersDict;



@property (nonatomic, assign) NSInteger int_SubmitSaveType;



@property (nonatomic, copy) NSString *str_IsDeptBearExps;


@property (nonatomic, assign) BOOL bool_IsAllowExpand;


@property (nonatomic, assign) BOOL bool_IsHasShowProject;




@property (nonatomic, copy) NSString *str_expenseCode;
@property (nonatomic, copy) NSString *str_expenseIcon;
@property (nonatomic, copy) NSString *str_expenseType;
@property (nonatomic, copy) NSString *str_parentCode;


@property (nonatomic, assign) BOOL bool_isDataIntegrity;

@property (nonatomic, assign) BOOL bool_isNeedAdvance;


@property (nonatomic, assign) BOOL bool_IsNotShowAddExpense;


@property (nonatomic, assign) BOOL bool_isConsistentAmount;


@property (nonatomic, assign) BOOL bool_isShareRequire;


@property (nonatomic, assign) BOOL bool_isSameShareAMT;

@property (nonatomic, strong) NSMutableArray *arr_overDueList;


@property (nonatomic, copy) NSString *str_deadlineDateTime;


@property (nonatomic, assign) BOOL bool_limitExpirationTime;


@property (nonatomic, copy) NSString *str_expirationTime;

@property (nonatomic, strong) NSMutableArray *arr_sonItem;

@property (nonatomic, strong) NSMutableArray *arr_itemShow;

@property (nonatomic, strong) NSMutableArray *arr_hasTaxExpense;

@property (nonatomic, strong) NSMutableArray *arr_itemShowDes;

@property (nonatomic, copy) NSString *str_amountTotal;
@property (nonatomic, copy) NSString *str_amountPrivate;
@property (nonatomic, copy) NSString *str_amountCompany;
@property (nonatomic, copy) NSString *str_LoanTotalAmount;
@property (nonatomic, copy) NSString *str_amountActual;
@property (nonatomic, copy) NSString  *str_NoInvAmount;

@property (nonatomic, copy) NSString  *str_InvTotalAmount;
@property (nonatomic, copy) NSString  *str_InvActualAmount;
@property (nonatomic, copy) NSString  *str_InvLoanAmount;




@property (nonatomic, assign) BOOL bool_ShareShow;
@property (nonatomic, assign) NSInteger int_ShareShowModel;
@property (nonatomic, strong) NSMutableArray *arr_ShareForm;
@property (nonatomic, strong) NSMutableArray *arr_ShareData;
@property (nonatomic, strong) NSMutableArray *arr_ShareDeptSumData;



@property (nonatomic, copy) NSString *str_ShareDeptIds;

@property (nonatomic, strong) NSMutableArray *arr_ShareProjId;
@property (nonatomic, strong) NSMutableArray *arr_ShareProjMgrId;
@property (nonatomic, strong) NSMutableArray *arr_ShareDeptId;
@property (nonatomic, strong) NSMutableArray *arr_SubmitExpenseCodes;
@property (nonatomic, strong) NSMutableArray *arr_SubmitExpenseTypes;



@property (nonatomic, strong) NSDictionary *dict_ReimPolicyDict;
@property (nonatomic, assign) BOOL bool_NeedCostDate;
@property (nonatomic, copy) NSString *str_travel_FromDate;
@property (nonatomic, copy) NSString *str_travel_ToDate;

@property (nonatomic, assign) BOOL bool_OvEstimatSubmit;
@property (nonatomic, assign) BOOL bool_editRelateTravelForm;
@property (nonatomic, strong) NSMutableDictionary *dict_ClaimAttRule;
@property (nonatomic, strong) NSMutableArray *arr_ClaimType;


@property (nonatomic, strong) NSDictionary *dict_SignInfo;



@property (nonatomic, assign) BOOL bool_AddFilesShow;

@property (nonatomic, strong) NSMutableArray *arr_table;
@property (nonatomic, strong) NSMutableArray *arr_projbudinfo;
@property (nonatomic, strong) NSMutableArray *arr_BudgetInfo;

@property (nonatomic, copy) NSString *str_projbuddata;
@property (nonatomic, copy) NSString *str_overlimit;

@property (nonatomic, assign) NSInteger index_item;

@property (nonatomic, copy) NSString *str_submitId;

@property (nonatomic, strong) NSMutableArray *arr_expirationTimeId;

@property (nonatomic, assign) BOOL bool_IsAllowModCostCgyOrInvAmt;


@property (nonatomic, assign) BOOL bool_isPrint;


@property (nonatomic, assign)  BOOL bool_isShowCurrencySum;


@property (nonatomic,strong)NSMutableArray *arr_CurrencySum;


@property (nonatomic,strong)NSMutableArray *arr_travelSum;


@property(nonatomic,strong)NSMutableDictionary *dict_budgetInfo;


@property (nonatomic, assign) BOOL bool_needSure;

@property (nonatomic, strong)NSMutableArray *arr_ApprovBefoEditExpense;
@property(nonatomic,strong)NSMutableDictionary *dict_JudgeAmount;

@property (nonatomic, copy) NSString *str_BudgetSubDate;

@property (nonatomic, copy) NSString *str_beforeBudgetSubDate;

@property (nonatomic, assign) BOOL bool_ReceiptOfInv;

@property (nonatomic, strong) NSMutableArray *arr_ReceiptOfInv;


@property (nonatomic, strong) NSMutableArray *arr_InvoiceTypes;
@property (nonatomic, strong) NSMutableArray *arr_New_InvoiceTypes;

@property (nonatomic, strong) NSMutableArray *arr_SexType;


@property (nonatomic, strong) NSMutableArray *arr_IsOrNot;


@property (nonatomic, strong) NSMutableArray *arr_TimeNoon;



@property (nonatomic, copy) NSString *str_SerialNo;

@property (nonatomic, copy) NSString *str_canEndorse;

@property (nonatomic, copy) NSString *str_noteStatus;

@property (nonatomic, copy) NSString *str_twoHandeId;

@property (nonatomic, copy) NSString *str_twoApprovalName;

@property (nonatomic, copy) NSString *str_commentIdea;

@property (nonatomic, assign) BOOL bool_isOpenDetail;

@property (nonatomic, assign) BOOL bool_SecisOpenDetail;

@property (nonatomic, assign) BOOL bool_ThirisOpenDetail;
@property (nonatomic, assign) BOOL bool_FourisOpenDetail;



@property (nonatomic, copy) NSString  *str_flowGuid;
@property (nonatomic, copy) NSString  *str_flowCode;
@property (nonatomic, copy) NSString  *str_taskId;
@property (nonatomic, copy) NSString  *str_userId;
@property (nonatomic, copy) NSString  *str_procId;
@property (nonatomic, assign) NSInteger  int_comeEditType;//1可编辑

@property (nonatomic, strong) userData *userdatas;


@property (nonatomic, assign) NSInteger int_comeStatus;


@property (nonatomic, assign) NSInteger int_formStatus;

-(instancetype)initBaseWithStatus:(NSInteger)status;

-(NSDictionary *)OpenFormParameters;

-(NSDictionary *)ApproveNoteOrFlowChartOrPushLinkParameters;

-(NSString *)ApproveNoteUrl;

-(NSString *)PrintLinkUrl;



-(NSString *)reCallUrl;

-(NSDictionary *)reCallParameters;


-(NSString *)urgeUrl;

-(NSDictionary *)urgeParameters;


-(void)getFormSettingBaseData:(NSDictionary *)result;

-(void)getCurrencyData:(NSDictionary *)dict;

-(void)getFirGroupDetail:(NSDictionary *)dict;

-(void)getSecGroupDetail:(NSDictionary *)dict WithTableName:(NSString *)tabName;

-(void)getThirGroupDetail:(NSDictionary *)dict WithTableName:(NSString *)tabName;

- (void)getFouGroupDetail:(NSDictionary *)dict WithTableName:(NSString *)tabName;

-(void)getMainFormShowAndData:(NSDictionary *)dict WithAttachmentsMaxCount:(NSInteger)maxCount;

-(void)getHasTaxExpenseList:(NSDictionary *)result;


-(void)getApproveNoteData;

-(void)getEndShowArray;

-(NSString *)getFlowChartUrl;


-(void)inModelContent;


-(void)inModelHasApproveContent;



-(NSString *)testModel;
-(void)showerror:(NSString*)info WithShowTips:(NSString *)tips;
-(void)showerrorDetail:(NSString*)info WithShowTips:(NSString *)tips;


-(void)contectData;


-(void)addImagesInfo;

-(void)addAttFileInfoWithKey:(NSString *)key withData:(NSString *)data;


-(void)contectHasDataWithTableName:(NSString *)tableName;

-(void)contectHasPayDataWithTableName:(NSString *)tableName;



-(NSString *)getCommonField;

-(NSString *)getSaveUrl;
-(NSDictionary *)SaveFormDateWithExpIds:(NSString *)ExpIds WithComment:(NSString *)Comment WithCommonField:(NSString *)CommonField;

-(NSString *)getCheckSubmitUrl;

-(NSDictionary *)getCheckSubmitOtherPar;
-(NSDictionary *)GetCheckSubmitWithAmount:(NSString *)Amount WithExpIds:(NSString *)ExpIds otherParameters:(NSDictionary *)parDict;


-(NSString *)getSubmitUrl;
-(NSDictionary *)SubmitFormDateWithExpIds:(NSString *)ExpIds WithComment:(NSString *)Comment WithCommonField:(NSString *)CommonField;

-(NSString *)getBackSubmitUrl;
-(NSDictionary *)SubmitFormAgainWithExpIds:(NSString *)ExpIds WithComment:(NSString *)Comment WithCommonField:(NSString *)CommonField;

-(NSString *)getDirectUrl;
-(NSDictionary *)DirectFormWithExpIds:(NSString *)ExpIds WithComment:(NSString *)Comment WithCommonField:(NSString *)CommonField;

-(NSString *)getSinglePayUrl;
-(NSDictionary *)SinglePayFormWithComment:(NSString *)Comment WithAdvanceNumber:(NSString *)AdvanceNumber WithExpIds:(NSString *)ExpIds WithMainForm:(NSMutableDictionary *)MainForm WithCommonField:(NSString *)CommonField;

-(NSString *)getApproveJudgeUrl;
-(NSDictionary *)getApproveJudgeParameter;



-(void)getFormBudgetInfoWithDict:(NSDictionary *)result;


-(void)getTravel_Daily_OtherReimData:(NSDictionary *)result WithParameter:(NSDictionary *)parameter WithType:(NSInteger)type;


-(void)getTravel_Daily_OtherHasReimData:(NSDictionary *)result WithParameter:(NSDictionary *)parameter WithType:(NSInteger)type;


-(void)getExpenseShareDataWithData:(NSDictionary *)result WithParameter:(NSDictionary *)parameter;





-(void)dealWithCateDateWithType:(NSInteger)type;



-(void)getAddFilesShowWithDict:(NSDictionary *)result;


-(void)travel_daily_otherReimAddCost:(id)obj;
-(void)travel_daily_otherReimEditCost:(NSDictionary *)dict;
-(void)getTravel_Daily_OtherReimTotalAmount;


-(NSString *)getTravel_Daily_OtherReimImportExpJson;



-(void)getHasSubmitDetailModelSubContent:(HasSubmitDetailModel *)model;


-(void)getSubmitSaveIdString;


-(NSInteger)getVerifyBudegt;


-(NSString *)testApporveEditModel;

-(NSString *)ApproveAgreeWithPayJudge;

-(void)dealWithAgreeAmount;


-(NSArray *)getMoreBtnList;


-(NSDictionary *)getExpShareApprovalIdParam;


-(NSDictionary *)getExpShareInfoParam;



-(NSDictionary *)getProjsByCostcenterParam;

-(NSString *)getProjsByCostcenterCheck:(NSDictionary *)result;


@end
