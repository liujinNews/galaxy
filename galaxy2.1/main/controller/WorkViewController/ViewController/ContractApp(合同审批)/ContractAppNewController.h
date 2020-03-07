//
//  ContractAppNewController.h
//  galaxy
//
//  Created by hfk on 2018/10/27.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "VoiceBaseController.h"
#import "BottomView.h"
#import "MyProcurementModel.h"
#import "FormDetailBaseCell.h"
#import "ContractTermDetail.h"
#import "ContractPayMethodDetail.h"
#import "contactsVController.h"
#import "buildCellInfo.h"
#import "ContractAppData.h"
#import "STPickerCategory.h"
#import "ContractAppFormData.h"
#import "ContractYearExpDetail.h"
#import "STOnePickModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ContractAppNewController : VoiceBaseController<UIScrollViewDelegate,GPClientDelegate,ByvalDelegate,UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

/**
 表单上数据
 */
@property (nonatomic,strong)ContractAppFormData *FormDatas;
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
 *  报销政策视图
 */
@property(nonatomic,strong)UIView *ReimPolicyUpView;
/**
 提交人相关视图
 */
@property(nonatomic,strong)SubmitPersonalView *SubmitPersonalView;
/**
 *  合同编号视图
 */
@property(nonatomic,strong)UIView *View_ContNo;
@property(nonatomic,strong)UITextField *txf_ContNo;
/**
 *  合同名称视图
 */
@property(nonatomic,strong)UIView *View_ContName;
@property(nonatomic,strong)UITextField *txf_ContName;
/**
 *  描述
*/
@property(nonatomic,strong)UIView *View_Description;
@property(nonatomic,strong)UITextField *txf_Description;
/**
 *  费用类别视图
 */
@property (nonatomic, strong) UIView *View_Cate;
@property (nonatomic, strong) UITextField * txf_Cate;
/**
 *  费用类别图片
 */
@property (nonatomic, strong) UIImageView * Imv_category;
/**
 *  费用类别选择视图
 */
@property (nonatomic, strong) UIView *CategoryView;
@property (nonatomic, strong) UICollectionView *CategoryCollectView;
@property (nonatomic, strong) UICollectionViewFlowLayout *CategoryLayOut;
@property (nonatomic, strong) CategoryCollectCell *cell;
/**
 *  关联合同视图
 */
@property(nonatomic,strong)UIView *View_RelCont;
@property(nonatomic,strong)UITextField *txf_RelCont;
/**
 *  采购申请单视图
 */
@property(nonatomic,strong)MulChooseShowView *View_PurchaseForm;
/**
 项目客户等相关视图
 */
@property(nonatomic,strong)FormRelatedView *FormRelatedView;
/**
 *  合同类型视图
 */
@property(nonatomic,strong)UIView *View_ContType;
@property(nonatomic,strong)UITextField *txf_ContType;
/**
*  是否使用标准合同模版 IsStandardContractTemplate
*/
@property (nonatomic, strong) WorkFormFieldsModel *model_StdConTemplate;
@property (nonatomic, strong) NSMutableArray *array_IsStdConTemplate;
@property (nonatomic, copy) NSString *str_IsStandardContractTemplate;
/**
 *  合同金额视图
 */
@property(nonatomic,strong)UIView *View_Amount;
@property(nonatomic,strong)UITextField *txf_Amount;
/**
 *  大写视图
 */
@property(nonatomic,strong)UIView *View_Capitalized;
@property(nonatomic,strong)UITextField *txf_Capitalized;
/**
 币种视图
 */
@property (nonatomic, strong) UIView *View_CurrencyCode;
@property (nonatomic, strong) UITextField *txf_CurrencyCode;
/**
 汇率视图
 */
@property (nonatomic, strong) UIView *View_ExchangeRate;
@property (nonatomic, strong) UITextField *txf_ExchangeRate;
/**
 本位币视图
 */
@property (nonatomic, strong) UIView *View_LocalCyAmount;
@property (nonatomic, strong) UITextField *txf_LocalCyAmount;
/**
 签订日期视图
 */
@property (nonatomic, strong) UIView *View_ContractDate;
@property (nonatomic, strong) UITextField *txf_ContractDate;
/**
 开始日期视图
 */
@property (nonatomic, strong) UIView *View_EffectiveDate;
@property (nonatomic, strong) UITextField *txf_EffectiveDate;
/**
截止日期视图
 */
@property (nonatomic, strong) UIView *View_ExpiryDate;
@property (nonatomic, strong) UITextField *txf_ExpiryDate;
/**
 付款方式视图
 */
@property (nonatomic, strong) UIView *View_PayCode;
@property (nonatomic, strong) UITextField *txf_PayCode;
/**
 汇票比例视图
 */
@property (nonatomic, strong) UIView *View_MoneyOrderRate;
@property (nonatomic, strong) UITextField *txf_MoneyOrderRate;
/**
 签订份数视图
 */
@property (nonatomic, strong) UIView *View_ContractCopies;
@property (nonatomic, strong) UITextField *txf_ContractCopies;
/**
 我方单位视图
 */
@property (nonatomic, strong) UIView *View_PartyA;
@property (nonatomic, strong) UITextField *txf_PartyA;
/**
 我方单位负责人视图
 */
@property (nonatomic, strong) UIView *View_PartyAStaff;
@property (nonatomic, strong) UITextField *txf_PartyAStaff;
/**
 我方单位电话视图
 */
@property (nonatomic, strong) UIView *View_PartyATel;
@property (nonatomic, strong) UITextField *txf_PartyATel;
/**
 对方单位电话视图
 */
@property (nonatomic, strong) UIView *View_PartyB;
@property (nonatomic, strong) UITextField *txf_PartyB;
/**
 对方单位地址视图
 */
@property (nonatomic, strong) UIView *View_PartyBAddr;
@property (nonatomic, strong) UITextField *txf_PartyBAddr;
/**
 对方单位邮编视图
 */
@property (nonatomic, strong) UIView *View_PartyBPostCode;
@property (nonatomic, strong) UITextField *txf_PartyBPostCode;
/**
 对方单位负责人视图
 */
@property (nonatomic, strong) UIView *View_PartyBStaff;
@property (nonatomic, strong) UITextField *txf_PartyBStaff;
/**
 对方单位电话视图
 */
@property (nonatomic, strong) UIView *View_PartyBTel;
@property (nonatomic, strong) UITextField *txf_PartyBTel;
/**
 开户银行视图
 */
@property (nonatomic, strong) UIView *View_BankName;
@property (nonatomic, strong) UITextField *txf_BankName;
/**
 银行账号视图
 */
@property (nonatomic, strong) UIView *View_BankAccount;
@property (nonatomic, strong) UITextField *txf_BankAccount;
/**
发票抬头视图
 */
@property (nonatomic, strong) UIView *View_InvoiceTitle;
@property (nonatomic, strong) UITextField *txf_InvoiceTitle;
/**
发票类型视图
 */
@property (nonatomic, strong) UIView *View_InvoiceType;
@property (nonatomic, strong) UITextField *txf_InvoiceType;
/**
税率视图
 */
@property (nonatomic, strong) UIView *View_TaxRate;
@property (nonatomic, strong) UITextField *txf_TaxRate;
/**
 客户名称视图
 */
@property (nonatomic, strong) UIView *View_ClientName;
@property (nonatomic, strong) UITextField *txf_ClientName;
/**
 客户地址视图
 */
@property (nonatomic, strong) UIView *View_ClientAddr;
@property (nonatomic, strong) UITextField *txf_ClientAddr;
/**
 IbanName视图
 */
@property (nonatomic, strong) UIView *View_IbanName;
@property (nonatomic, strong) UITextField *txf_IbanName;
/**
 IbanAccount视图
 */
@property (nonatomic, strong) UIView *View_IbanAccount;
@property (nonatomic, strong) UITextField *txf_IbanAccount;
/**
 IbanAddr视图
 */
@property (nonatomic, strong) UIView *View_IbanAddr;
@property (nonatomic, strong) UITextField *txf_IbanAddr;
/**
 SwiftCode视图
 */
@property (nonatomic, strong) UIView *View_SwiftCode;
@property (nonatomic, strong) UITextField *txf_SwiftCode;
/**
 IbanNo视图
 */
@property (nonatomic, strong) UIView *View_BankNo;
@property (nonatomic, strong) UITextField *txf_BankNo;
/**
 IbanADDRESS视图
 */
@property (nonatomic, strong) UIView *View_BankADDRESS;
@property (nonatomic, strong) UITextField *txf_BankADDRESS;
/**
 *  自定义字段
 */
@property(nonatomic,strong)UIView *View_Reserved;
/**
 *  备注视图
 */
@property(nonatomic,strong)UIView *View_Remark;
@property(nonatomic,strong)UITextView *txv_Remark;
/**
 *  图片视图
 */
@property(nonatomic,strong)UIView *View_AttachImg;
/**
 *  合同条款明细视图
 */
@property(nonatomic,strong)UITableView *View_TermTable;
@property(nonatomic,strong)UIView *View_TermHead;
@property(nonatomic,strong)UIView *View_TermAdd;
/**
* 会签人员试图
*/
@property (nonatomic, strong) UIView *view_ApprovalPersonnel;//会签人员view
@property (nonatomic, strong) UITextField *txf_ApprovalPersonnel;//会签人员文本
@property (nonatomic, strong) NSString *str_ApprovalPersonnel;//会签人员id

/**
 * 付款方式明细视图
 */
@property(nonatomic,strong)UITableView *View_PayModeTable;
@property(nonatomic,strong)UIView *View_PayModeHead;
@property(nonatomic,strong)UIView *View_PayModeAdd;
@property(nonatomic,strong)UIView *View_PayModeFoot;

/**
 * 费用类别明细
 */
@property(nonatomic,strong)NSMutableArray *arr_ExpTypeTable;
//@property(nonatomic,strong)NSMutableArray *arr_ExpTypeHead;
@property(nonatomic,strong)UITableView *View_ExpTypeTable;
@property(nonatomic,strong)UIView *View_ExpTypeHead;
@property(nonatomic,strong)UIView *View_ExpTypeAdd;
/**
 * 年度费用明细明细视图
 */
@property(nonatomic,strong)UITableView *View_ConYearExpTable;
@property(nonatomic,strong)UIView *View_ConYearExpHead;
@property(nonatomic,strong)UIView *View_ConYearExpAdd;
/**
 *  审批记录
 */
@property (nonatomic,strong)UIView *View_Note;
/**
 *  采购审批人视图
 */
@property(nonatomic,strong)UIView *View_Approve;
@property(nonatomic,strong)UIImageView *View_ApproveImg;
@property(nonatomic,strong)UITextField *txf_Approver;
/**
 *  抄送人视图
 */
@property(nonatomic,strong)UIView *View_CcToPeople;
@property(nonatomic,strong)UITextField *txf_CcToPeople;
/**
 *  报销政策视图
 */
@property(nonatomic,strong)UIView *ReimPolicyDownView;


@end

NS_ASSUME_NONNULL_END
