//
//  InvoicePhotoViewController.m
//  galaxy
//
//  Created by hfk on 2018/6/22.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "InvoicePhotoViewController.h"
#import "EXInvoiceView.h"
#import "ChooseCategoryModel.h"
#import "NewAddCostModel.h"
#import "PdfReadViewController.h"
#import "ManInputInvoiceController.h"

@interface InvoicePhotoViewController ()<UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,GPClientDelegate>
@property (nonatomic, strong) UIScrollView *scr_rootView;
@property (nonatomic, strong) UIView *view_botton;
@property (nonatomic, strong) UIView *view_Sure;
@property (nonatomic, strong) UIView *view_Error;
@property (nonatomic, strong) EXInvoiceView *exv_view;
@property (nonatomic, strong) UIView *view_formatFile;

@property (nonatomic, strong) UIView *view_Genre;
@property (nonatomic, strong) UITextField *txf_genre;
@property (nonatomic, strong) UIView *View_Cate;
@property (nonatomic, strong) UITextField *txf_Cate;
@property (nonatomic, strong) UIImageView *img_category;
@property (nonatomic, strong) UIView *View_Category;
@property (nonatomic, strong) UICollectionView *clv_Category;
@property (nonatomic, strong) UICollectionViewFlowLayout *CategoryLayOut;
@property (nonatomic, strong) CategoryCollectCell *cell;

@property (nonatomic, strong) UIView *View_Invoice;
@property (nonatomic, strong) UIView *view_image;
@property (nonatomic, strong) UIView *view_CateDes;
@property (nonatomic, strong) UITextView *txv_CateDes;
@property (nonatomic, strong) UIView *view_linkForm;



@property (nonatomic, strong) NSString *str_category;    //类别字符串
@property (nonatomic, strong) NSString *str_expenseCode;   //费用类别编码
@property (nonatomic, strong) NSString *str_expenseIcon;   //费用类别图片编码
@property (nonatomic, strong) NSString *str_expenseCat;   //费用类别编码
@property (nonatomic, strong) NSString *str_expenseCatCode;   //费用类别图片编码
@property (nonatomic, strong) NSString *str_expenseTag;   //费用类别tag
@property (nonatomic, strong) NSString *ste_CateLevel;
@property (nonatomic, strong) NSString *str_type;
@property (nonatomic, strong) NSString *str_typeName;

@property (nonatomic, assign) BOOL isOpenGener;

@property (nonatomic, strong) NSDictionary *dic_baiwang;
@property (nonatomic, strong) NSMutableArray *arr_category;
@property (nonatomic, assign) NSInteger int_categoryRows;
@property (nonatomic, strong) NSMutableArray *arr_ClaimType;//报销类型


@property (nonatomic, strong) NSMutableArray *totalArray;
@property (nonatomic, strong) NSMutableArray *imagesArray;
@property (nonatomic, strong) NSString *str_imageDataString;
@property (nonatomic, strong) NSMutableArray *imageTypeArray;
@property (nonatomic, strong) NewAddCostModel *model_NewAddCost;//上传需用数据

@property (nonatomic, assign) BOOL isAgain;

@property (nonatomic, strong) NSDictionary *dic_requestBwInvoice;

@end

@implementation InvoicePhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:Custing(@"导入发票", nil) backButton:YES];
    [self getReimTypes];
}

#define mark - function
//创建主视图
-(void)createMainView{
    _scr_rootView = UIScrollView.new;
    _scr_rootView.backgroundColor =Color_White_Same_20;
    _scr_rootView.showsVerticalScrollIndicator=NO;
    _scr_rootView.scrollEnabled = YES;
    _scr_rootView.delegate = self;
    [self.view addSubview:_scr_rootView];
    
    [_scr_rootView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(@-50);
    }];
}

//创建扫描成功视图
-(void)createSureView{
    _view_Sure =[[UIView alloc]init];
    _view_Sure.userInteractionEnabled=YES;
    _view_Sure.backgroundColor=Color_White_Same_20;
    [_scr_rootView addSubview:_view_Sure];
    [_view_Sure mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scr_rootView);
        make.width.equalTo(self.scr_rootView);
    }];
    
    _exv_view = [[[NSBundle mainBundle] loadNibNamed:@"EXInvoiceView" owner:self options:nil]lastObject];
    [_view_Sure addSubview:_exv_view];
    [_exv_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_Sure.top).offset(@10);
        make.left.right.equalTo(self.view_Sure);
        make.height.equalTo(@410);
    }];
    
    _view_formatFile = [[UIView alloc]init];
    _view_formatFile.backgroundColor=Color_WhiteWeak_Same_20;
    [_view_Sure addSubview:_view_formatFile];
    [_view_formatFile mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.exv_view.bottom);
        make.left.right.equalTo(self.view_Sure);
    }];
    
    _view_Genre=[[UIView alloc]init];
    _view_Genre.backgroundColor=Color_WhiteWeak_Same_20;
    [_view_Sure addSubview:_view_Genre];
    [_view_Genre mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_formatFile.bottom);
        make.left.right.equalTo(self.view_Sure);
    }];
    
    _View_Cate=[[UIView alloc]init];
    _View_Cate.backgroundColor=Color_WhiteWeak_Same_20;
    [_view_Sure addSubview:_View_Cate];
    [_View_Cate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_Genre.bottom);
        make.left.right.equalTo(self.view_Sure);
    }];
    
    _View_Category=[[UIView alloc]init];
    _View_Category.backgroundColor=Color_White_Same_20;
    [_view_Sure addSubview:_View_Category];
    [_View_Category mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Cate.bottom);
        make.left.right.equalTo(self.view_Sure);
    }];
    
    _CategoryLayOut = [[UICollectionViewFlowLayout alloc] init];
    _CategoryLayOut.minimumInteritemSpacing =1;
    _CategoryLayOut.minimumLineSpacing =1;
    _clv_Category = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:_CategoryLayOut];
    _clv_Category.delegate = self;
    _clv_Category.dataSource = self;
    _clv_Category.backgroundColor =Color_White_Same_20;
    _clv_Category.scrollEnabled=NO;
    [_clv_Category registerClass:[CategoryCollectCell class] forCellWithReuseIdentifier:@"CategoryCollectCell"];
    [_View_Category addSubview:_clv_Category];
    [_clv_Category makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Category.top);
        make.left.right.equalTo(self.View_Category);
    }];
    
    _View_Invoice = [[UIView alloc]init];
    _View_Invoice.backgroundColor = Color_form_TextFieldBackgroundColor;
    [_view_Sure addSubview:_View_Invoice];
    [_View_Invoice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Category.bottom);
        make.left.right.equalTo(self.view_Sure);
    }];
    
    _view_CateDes = [[UIView alloc]init];
    _view_CateDes.backgroundColor = Color_WhiteWeak_Same_20;
    [_view_Sure addSubview:_view_CateDes];
    [_view_CateDes mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Invoice.bottom);
        make.left.right.equalTo(self.view_Sure);
    }];
    
    _view_image = [[UIView alloc]init];
    _view_image.backgroundColor = Color_White_Same_20;
    [_view_Sure addSubview:_view_image];
    [_view_image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_CateDes.bottom);
        make.left.right.equalTo(self.view_Sure);
    }];
    
    _view_linkForm = [[UIView alloc]init];
    _view_linkForm.backgroundColor = Color_White_Same_20;
    [_view_Sure addSubview:_view_linkForm];
    [_view_linkForm mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_image.bottom);
        make.left.right.equalTo(self.view_Sure);
    }];
    
}

//创建失败视图
-(void)createErrorView{
    
    [_scr_rootView updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.bottom);
    }];
    
    _view_Error =[[UIView alloc]init];
    _view_Error.userInteractionEnabled=YES;
    _view_Error.backgroundColor=Color_White_Same_20;
    [_scr_rootView addSubview:_view_Error];
    [_view_Error mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scr_rootView);
        make.width.equalTo(self.scr_rootView);
    }];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 10, Main_Screen_Width, 100)];
    view.backgroundColor = Color_form_TextFieldBackgroundColor;
    [_view_Error addSubview:view];
    
    UIImageView *image = [GPUtils createImageViewFrame:CGRectMake(Main_Screen_Width/2-21, 15, 42, 42) imageName:@"EXInvoice_False"];
    [view addSubview:image];
    
    UILabel *lab = [GPUtils createLable:CGRectMake(0, 60, Main_Screen_Width, 30) text:Custing(@"没有查询到此发票", nil) font:Font_Important_15_20 textColor:Color_form_TextField_20 textAlignment:NSTextAlignmentCenter];
    [view addSubview:lab];
    
    UILabel *labs = [GPUtils createLable:CGRectMake(0, 110, Main_Screen_Width, 40) text:Custing(@"发票信息会延迟一天,请开票次日扫描", nil) font:Font_Important_15_20 textColor:Color_form_TextField_20 textAlignment:NSTextAlignmentCenter];
    [view addSubview:labs];
}

-(void)updateMainView{
    
        _exv_view.lab_purchaserName.text = [NSString stringWithIdOnNO:_dic_baiwang[@"purchaserName"]];
        _exv_view.lab_purchaserTaxNo.text = [NSString stringWithIdOnNO:_dic_baiwang[@"purchaserTaxNo"]];
        _exv_view.lab_salesName.text = [NSString stringWithIdOnNO:_dic_baiwang[@"salesName"]];
        _exv_view.lab_totalAmount.text = [GPUtils transformNsNumber:_dic_baiwang[@"amountTax"]];
        _exv_view.lab_shuier.text = [GPUtils transformNsNumber:_dic_baiwang[@"totalTax"]];
        _exv_view.lab_billingDate.text = [NSString stringWithIdOnNO:_dic_baiwang[@"billingDate"]];
        _exv_view.lab_invoiceCode.text = [NSString stringWithIdOnNO:_dic_baiwang[@"invoiceCode"]];
        _exv_view.lab_invoiceNumber.text = [NSString stringWithIdOnNO:_dic_baiwang[@"invoiceNumber"]];
        if ([[NSString stringWithIdOnNO:_dic_baiwang[@"invoiceType"]] isEqualToString:@"01"]) {
            _exv_view.lab_invoice_type.text= Custing(@"增值税专用发票", nil);
        }else if ([[NSString stringWithIdOnNO:_dic_baiwang[@"invoiceType"]] isEqualToString:@"02"]) {
            _exv_view.lab_invoice_type.text = Custing(@"货运运输业增值税专用发票", nil);
        }else if ([[NSString stringWithIdOnNO:_dic_baiwang[@"invoiceType"]] isEqualToString:@"03"]) {
            _exv_view.lab_invoice_type.text = Custing(@"机动车增值税专用发票", nil);
        }else if ([[NSString stringWithIdOnNO:_dic_baiwang[@"invoiceType"]] isEqualToString:@"04"]) {
            _exv_view.lab_invoice_type.text = Custing(@"增值税普通发票", nil);
        }else if ([[NSString stringWithIdOnNO:_dic_baiwang[@"invoiceType"]] isEqualToString:@"10"]) {
            _exv_view.lab_invoice_type.text = Custing(@"增值税电子普通发票", nil);
        }else if ([[NSString stringWithIdOnNO:_dic_baiwang[@"invoiceType"]] isEqualToString:@"11"]) {
            _exv_view.lab_invoice_type.text = Custing(@"增值税普通发票(卷式)", nil);
        }
        UIImage *image;
        if ([_dic_baiwang[@"isExpense"] integerValue]==1) {
            image=[UIImage imageNamed:@"EXInvoice_Had"];
            _exv_view.lab_title_State.text = Custing(@"该发票已报销", nil);
            [_exv_view.img_State setImage:[UIImage imageNamed:@"EXInvoice_False"]];
        }else if ([[NSString stringWithFormat:@"%@",_dic_baiwang[@"hasSensitiveWord"]] isEqualToString:@"1"]){
            image=[UIImage imageNamed:@"EXInvoice_Sensitive"];
            _exv_view.lab_title_State.text = Custing(@"物品名称包含敏感字段", nil);
            _exv_view.lab_purchaserName.textColor = [UIColor redColor];
            _exv_view.lab_purchaserTaxNo.textColor = [UIColor redColor];
            [_exv_view.img_State setImage:[UIImage imageNamed:@"EXInvoice_False"]];
        }else if ([[NSString stringWithFormat:@"%@",_dic_baiwang[@"salesNameHasSensitiveWord"]] isEqualToString:@"1"]){
            image=[UIImage imageNamed:@"EXInvoice_SalesNamSensitive"];
            _exv_view.lab_title_State.text = Custing(@"开票方包含敏感字段", nil);
            _exv_view.lab_purchaserName.textColor = [UIColor redColor];
            _exv_view.lab_purchaserTaxNo.textColor = [UIColor redColor];
            [_exv_view.img_State setImage:[UIImage imageNamed:@"EXInvoice_False"]];
        }else{
            if ([[NSString stringWithIdOnNO:_dic_baiwang[@"taxNoValid"]] isEqualToString:@"0"]) {
                image=[UIImage imageNamed:@"EXInvoice_Diffent"];
                _exv_view.lab_title_State.text = Custing(@"收票方信息不一致", nil);
                _exv_view.lab_purchaserName.textColor = [UIColor redColor];
                _exv_view.lab_purchaserTaxNo.textColor = [UIColor redColor];
                [_exv_view.img_State setImage:[UIImage imageNamed:@"EXInvoice_False"]];
            }else{
                image=[UIImage imageNamed:@"EXInvoice_Success"];
                [_exv_view.img_State setImage:[UIImage imageNamed:@"EXInvoice_Sure"]];
                _exv_view.lab_title_State.text = Custing(@"发票查验成功", nil);
            }
        }
        _exv_view.img_state_img.image=image;
        _exv_view.img_State.image=nil;
        _exv_view.lab_title_State.text=nil;
    
}

//查看发票文件
-(void)updateformatFile{
    [_view_formatFile updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@60);
    }];
    [_view_formatFile addSubview:[self createDownLineView]];
    
    UIButton *btn=[GPUtils createButton:CGRectMake(0, 10, Main_Screen_Width, 50) action:@selector(lookPDF:) delegate:self title:Custing(@"查看发票详情", nil) font:Font_Important_15_20 titleColor:Color_Blue_Important_20];
    [_view_formatFile addSubview:btn];
}

//更新报销类型视图
-(void)updateGenreView{
    MyProcurementModel *model=[[MyProcurementModel alloc]init];
    model.Description=Custing(@"报销类型", nil);
    model.fieldValue=_str_typeName;
    model.tips=Custing(@"请选择", nil);
    _txf_genre=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_view_Genre WithContent:_txf_genre WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model){
        [weakSelf selectedTypeOrCateary:nil];
    }];
    [_view_Genre addSubview:view];
}

//更新费用类别选择
-(void)updateCateView{
    MyProcurementModel *model=[[MyProcurementModel alloc]init];
    model.Description=Custing(@"费用类别Add", nil);
    model.tips=Custing(@"请选择", nil);
    _txf_Cate=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_Cate WithContent:_txf_Cate WithFormType:formViewSelectCate WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    [view setCateClickedBlock:^(MyProcurementModel *model,UIImageView *image){
        weakSelf.img_category=image;
        [weakSelf CategoryClick:nil];
    }];
    [_View_Cate addSubview:view];
}

-(void)updateCateGoryView{
    _isOpenGener=NO;
    [_View_Category updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@0);
    }];
    [_clv_Category updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@0);
    }];
}

-(void)updateAgainCateGoryView{
    if ([_ste_CateLevel isEqualToString:@"1"]) {
        _isOpenGener=YES;
        if (_int_categoryRows==0) {
            [_View_Category updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@0);
            }];
            [_clv_Category updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@10);
            }];
        }else{
            [_View_Category updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@((65*self.int_categoryRows)+20));
            }];
            [_clv_Category updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@((65*self.int_categoryRows)+20));
            }];
        }
        [_clv_Category reloadData];
    }else{
        [_View_Category updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
        }];
        [_clv_Category updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
        }];
    }
}

-(void)updatCateDesView{
    _txv_CateDes=[[UITextView alloc]init];
    [_view_CateDes addSubview: [[SubmitFormView alloc]initBaseView:_view_CateDes WithContent:_txv_CateDes WithFormType:formViewEnterTextView WithSegmentType:lineViewNoneLine WithString:Custing(@"费用描述", nil) WithInfodict:nil WithTips:Custing(@"请输入费用描述", nil) WithNumLimit:0]];
}

-(void)updateImageView{
    
    _view_image.backgroundColor = Color_form_TextFieldBackgroundColor;
    EditAndLookImgView *view=[[EditAndLookImgView alloc]initWithBaseView:_view_image withEditStatus:1 withModel:nil];
    view.maxCount=5;
    [_view_image addSubview:view];
    [view updateWithTotalArray:_totalArray WithImgArray:_imagesArray];
    
}

-(void)updateBottonView{
    [_view_Sure updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view_linkForm.bottom);
    }];
    _view_botton = [[UIView alloc]init];
    _view_botton.backgroundColor=Color_WhiteWeak_Same_20;
    [self.view addSubview:_view_botton];
    
    [_view_botton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scr_rootView.bottom);
        make.width.equalTo(self.view_Sure.width);
        make.height.equalTo(@50);
    }];
    UIButton *addSave=[GPUtils createButton:CGRectMake(0, 0, Main_Screen_Width, 50)action:@selector(btn_submit:) delegate:self];
    addSave.tag = 0;
    addSave.backgroundColor = Color_Blue_Important_20;
    [addSave setTitle:Custing(@"确认导入", nil)  forState:UIControlStateNormal];
    addSave.titleLabel.font=Font_filterTitle_17 ;
    [addSave setTitleColor:Color_form_TextFieldBackgroundColor forState:UIControlStateNormal];
    [_view_botton addSubview:addSave];
    
    if ([[NSString stringWithIdOnNO:_dic_baiwang[@"isExpense"]] isEqualToString:@"1"]||[[NSString stringWithFormat:@"%@",_dic_baiwang[@"hasSensitiveWord"]] isEqualToString:@"1"]||[[NSString stringWithFormat:@"%@",_dic_baiwang[@"salesNameHasSensitiveWord"]] isEqualToString:@"1"]) {
        addSave.userInteractionEnabled = NO;
        addSave.backgroundColor = Color_GrayLight_Same_20;
        [addSave setTitleColor:Color_GrayDark_Same_20 forState:UIControlStateNormal];
    }
}


#pragma mark data
-(void)initializeView{
    _exv_view.lab_title_shoupiaofang.text = Custing(@"收票方", nil);
    _exv_view.lab_title_shoupiaofangshibiema.text = Custing(@"收票方识别码", nil);
    _exv_view.lab_title_kaipiaofang.text = Custing(@"开票方", nil);
    _exv_view.lab_title_kaipiaojiner.text = Custing(@"价税合计", nil);
    _exv_view.lab_title_fapiaoriqi.text = Custing(@"发票日期", nil);
    _exv_view.lab_title_fapiaodaima.text = Custing(@"发票代码", nil);
    _exv_view.lab_title_fapiaohaoma.text = Custing(@"发票号码", nil);
    _exv_view.lab_title_shuier.text = Custing(@"税额", nil);
}

-(void)initializeDate{
    _str_category = @"";
    _str_expenseIcon = @"";
    _str_expenseCode = @"";
    _str_expenseTag=@"";
    _str_expenseCat=@"";
    _str_expenseCatCode=@"";
    _str_type = @"1";
    _str_typeName = Custing(@"差旅Add", nil);
    if (self.arr_ClaimType.count > 0) {
        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"Id MATCHES %@", @"2"];
        NSArray *filterArray = [self.arr_ClaimType filteredArrayUsingPredicate:pred1];
        if (filterArray.count > 0) {
            STOnePickModel *model = filterArray[0];
            _str_type = @"2";
            _str_typeName = model.Type;
        }else{
            STOnePickModel *model = self.arr_ClaimType[0];
            _str_type = model.Id;
            _str_typeName = model.Type;
        }
    }
    _ste_CateLevel = @"";
    _dic_baiwang = [NSDictionary  dictionary];
    _arr_category = [NSMutableArray array];
    _int_categoryRows = 0;
    _isOpenGener = YES;
    _totalArray = [NSMutableArray array];
    _imagesArray = [NSMutableArray array];
    _str_imageDataString = @"";
    _imagesArray = [NSMutableArray array];
    _imageTypeArray = [NSMutableArray array];
    _str_expenseCat = @"";
    _str_expenseCatCode = @"";
    _isAgain = NO;
    _dic_requestBwInvoice = [NSDictionary dictionary];
}

//费用类型数据处理
-(void)dealWithType:(NSDictionary *)dic{
    _arr_category=[NSMutableArray array];
    NSDictionary *parDict= [CostCateNewModel getCostCateByDict:dic array:_arr_category withType:1];
    _ste_CateLevel=parDict[@"CateLevel"];
    _int_categoryRows=[parDict[@"categoryRows"]integerValue];
}

//改变报销类型后报销类别重置
-(void)dealAgainChooseType{
    _img_category.center = CGPointMake(Main_Screen_Width-56, 35);
    _img_category.image = nil;
    _str_category = @"";
    _str_expenseCode = @"";
    _str_expenseIcon = @"";
    _str_expenseCat=@"";
    _str_expenseCatCode=@"";
    _str_expenseTag=@"";
    
}

#pragma mark network

#pragma mark network
-(void)getReimTypes{
    NSString *url=[NSString stringWithFormat:@"%@",GETREIMTYPES];
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:nil Delegate:self SerialNum:5 IfUserCache:NO];
}

-(void)requestGetAddCostNewCategry{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    NSDictionary *parameters=@{@"Type":_str_type};
    NSString *url=[NSString stringWithFormat:@"%@",GetAddCostNewCategry];
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:1 IfUserCache:NO];
}

-(void)getInvoicePhotoInfo{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    NSMutableArray *loadImageArray=[NSMutableArray array];
    for (int i=0; i<self.arr_InvoicePhoto.count; i++) {
        id asset = self.arr_InvoicePhoto[i];
        if ([asset isKindOfClass:[ZLPhotoAssets class]]) {
            [loadImageArray addObject:[[asset originImage]dataSmallerThan:1024 * 20000]];
        }else if ([asset isKindOfClass:[ZLCamera class]]){
            [loadImageArray addObject:[[asset photoImage]dataSmallerThan:1024 * 20000]];
        }
    }
    if (loadImageArray.count!=0) {
        //图片上传处理
        NSDate *pickerDate = [NSDate date];
        NSDateFormatter * pickerFormatter = [[NSDateFormatter alloc]init];
        pickerFormatter.timeZone = [NSTimeZone localTimeZone];
        [pickerFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
        NSString *name= [pickerFormatter stringFromDate:pickerDate];
        name=[name stringByReplacingOccurrencesOfString:@" " withString:@""];
        name=[name stringByReplacingOccurrencesOfString:@"-" withString:@""];
        name=[name stringByReplacingOccurrencesOfString:@":" withString:@""];
        NSMutableArray *names=[[NSMutableArray alloc]init];
        [names addObject:name];
        [[GPClient shareGPClient]RequestByPostOnImageWithPath:[NSString stringWithFormat:@"%@",@"IntCloudOcr/Scan"] Parameters:nil NSArray:loadImageArray name:names type:@"image/jpg" Delegate:self SerialNum:0 IfUserCache:NO];
    }

}

-(void)requestaddRequestAddCostList{
    
    NSDictionary *parameters=@{@"ExpenseCode":_str_expenseCode};
    NSString *url=[NSString stringWithFormat:@"%@",@"expuser/GetTaxAndTaxRateFlds"];
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:6 IfUserCache:NO];
}

#pragma  mark - action
-(void)selectedTypeOrCateary:(UIButton *)btn{
    NSLog(@"费用类型类别选择");
    STOnePickView *picker = [[STOnePickView alloc]init];
    __weak typeof(self) weakSelf = self;
    [picker setBlock:^(STOnePickModel *Model, NSInteger type) {
        if (![weakSelf.str_type isEqualToString:Model.Id]) {
            weakSelf.str_type=Model.Id;
            weakSelf.txf_genre.text=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",Model.Type]]?[NSString stringWithFormat:@"%@",Model.Type]:@"";
            weakSelf.img_category.image =nil;
            weakSelf.str_category = @"";
            weakSelf.str_expenseCode = @"";
            weakSelf.str_expenseIcon = @"";
            weakSelf.str_expenseCat = @"";
            weakSelf.str_expenseCatCode = @"";
            weakSelf.str_expenseTag=@"";
            weakSelf.txf_Cate.text = @"";
            [weakSelf requestGetAddCostNewCategry];
        }
    }];
    picker.typeTitle=Custing(@"报销类型", nil);
    picker.DateSourceArray=self.arr_ClaimType;
    STOnePickModel *model=[[STOnePickModel alloc]init];
    model.Id=[NSString isEqualToNull:_str_type]?_str_type:@"";
    picker.Model=model;
    [picker UpdatePickUI];
    [picker setContentMode:STPickerContentModeBottom];
    [picker show];
}

-(void)CategoryClick:(UIButton *)btn{
    if ([_txf_genre.text isEqualToString:Custing(@"请选择", nil)]&&![NSString isEqualToNull:_str_type]) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"请选择报销类型", nil) duration:1.0];
        return;
    }
    if (_arr_category.count==0) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"没相关费用类别", nil) duration:1.0];
        return;
    }
    if ([_ste_CateLevel isEqualToString:@"1"]) {
        if (_isOpenGener ==YES) {
            [self updateCateGoryView];
        }else {
            [self updateAgainCateGoryView];
        }
        
    }else if ([_ste_CateLevel isEqualToString:@"2"]){
        STPickerCategory *pickerArea = [[STPickerCategory alloc]init];
        pickerArea.DateSourceArray=[NSMutableArray arrayWithArray:_arr_category];
        CostCateNewSubModel *model=[[CostCateNewSubModel alloc]init];
        model.expenseCode=_str_expenseCode;
        pickerArea.CateModel=model;
        [pickerArea UpdatePickUI];
        [pickerArea setContentMode:STPickerContentModeBottom];
        
        if ([_str_type isEqualToString:@"1"]) {
            pickerArea.str_flowCode=@"F0002";
        }else if ([_str_type isEqualToString:@"2"]){
            pickerArea.str_flowCode=@"F0003";
        }else if ([_str_type isEqualToString:@"3"]){
            pickerArea.str_flowCode=@"F0010";
        }
        __weak typeof(self) weakSelf = self;
        [pickerArea setChooseCateBlock:^(CostCateNewModel *firstModel, CostCateNewSubModel *secondModel) {
            [weakSelf keyClose];
            if (![secondModel.expenseType isEqualToString:weakSelf.str_category]) {
                weakSelf.img_category.image = [UIImage imageNamed:[NSString isEqualToNull:secondModel.expenseIcon]?secondModel.expenseIcon:@"15"];
                weakSelf.str_category = [NSString isEqualToNull:secondModel.expenseType]?secondModel.expenseType:@"";
                weakSelf.str_expenseCode = secondModel.expenseCode;
                weakSelf.str_expenseIcon = secondModel.expenseIcon;
                weakSelf.str_expenseCat = secondModel.expenseCat;
                weakSelf.str_expenseCatCode = secondModel.expenseCatCode;
                weakSelf.str_expenseTag=secondModel.tag;
                weakSelf.txf_Cate.text = [NSString stringWithFormat:@"%@",weakSelf.str_category];
                [weakSelf updateCateGoryView];
            }
        }];
        [pickerArea show];
    }else if([_ste_CateLevel isEqualToString:@"3"]){
        ExpenseCodeListViewController *ex = [[ExpenseCodeListViewController alloc]init];
        ex.arr_DataList = _arr_category;
        ex.str_CateLevel = _ste_CateLevel;
        __weak typeof(self) weakSelf = self;
        ex.CellClick = ^(CostCateNewSubModel *model) {
            if (![model.expenseType isEqualToString:weakSelf.str_category]) {
                weakSelf.img_category.image = [UIImage imageNamed:[NSString isEqualToNull:model.expenseIcon]?model.expenseIcon:@"15"];
                weakSelf.str_category = [NSString isEqualToNull:model.expenseType]?model.expenseType:@"";
                weakSelf.str_expenseCode = model.expenseCode;
                weakSelf.str_expenseIcon = model.expenseIcon;
                weakSelf.str_expenseCat = model.expenseCat;
                weakSelf.str_expenseCatCode = model.expenseCatCode;
                weakSelf.str_expenseTag=model.tag;
                weakSelf.txf_Cate.text = [NSString stringWithFormat:@"%@",weakSelf.str_category];
            }
        };
        [self.navigationController pushViewController:ex animated:YES];
    }
}

-(void)btn_submit:(UIButton *)btn{
    if (![NSString isEqualToNull:_str_expenseCode]) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"请选择费用类别", nil) duration:2.0];
        return;
    }
    if (_totalArray.count!=0) {
        NSMutableArray *loadImageArray=[NSMutableArray array];
        for (int i=0; i<_totalArray.count; i++) {
            ZLPhotoAssets *asset = _totalArray[i];
            if ([asset isKindOfClass:[ZLPhotoAssets class]]) {
                [loadImageArray addObject:UIImageJPEGRepresentation([asset originImage], 0.4)];
                [_imageTypeArray addObject:[NSString stringWithFormat:@"%d",i]];
            }else if ([asset isKindOfClass:[ZLCamera class]]){
                [loadImageArray addObject:UIImageJPEGRepresentation([asset thumbImage], 0.4)];
                [_imageTypeArray addObject:[NSString stringWithFormat:@"%d",i]];
            }
        }
        if (loadImageArray.count!=0) {
            //图片上传处理
            NSString *url=[NSString stringWithFormat:@"%@",addNewRequestImage];
            NSDate *pickerDate = [NSDate date];
            NSDateFormatter * pickerFormatter = [[NSDateFormatter alloc]init];
            pickerFormatter.timeZone = [NSTimeZone localTimeZone];
            [pickerFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
            NSString *name= [pickerFormatter stringFromDate:pickerDate];
            name=[name stringByReplacingOccurrencesOfString:@" " withString:@""];
            name=[name stringByReplacingOccurrencesOfString:@"-" withString:@""];
            name=[name stringByReplacingOccurrencesOfString:@":" withString:@""];
            NSMutableArray *names=[[NSMutableArray alloc]init];
            for (int i=0; i<loadImageArray.count; i++) {
                [names addObject:[NSString stringWithFormat:@"%@%d",name,i]];
            }
            [[GPClient shareGPClient]RequestByPostOnImageWithPath:url Parameters:nil NSArray:loadImageArray name:names type:@"image/png" Delegate:self SerialNum:2 IfUserCache:NO];
        }else{
            _str_imageDataString = [NSString transformToJsonWithOutEnter:_totalArray];
            [self requestaddRequestAddCostList];
        }
    }else{
        [self requestaddRequestAddCostList];
    }
}

-(void)btn_Click:(UIButton *)btn{
    _isAgain = YES;
    [self btn_submit:btn];
}

-(void)lookPDF:(UIButton *)btn{
    PdfReadViewController *vc=[[PdfReadViewController alloc]init];
    vc.PdfUrl = _dic_baiwang[@"formatFile"];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - delegate
- (void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum {
    [YXSpritesLoadingView dismiss];
    NSString * success = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"success"]];
    if ([success isEqualToString:@"0"]){
        if (serialNum == 0 && (([[NSString stringWithFormat:@"%@",responceDic[@"code"]]isEqualToString:@"1000"]||[[NSString stringWithFormat:@"%@",responceDic[@"code"]]isEqualToString:@"1003"]))) {
            ManInputInvoiceController *vc = [[ManInputInvoiceController alloc]init];
            vc.dict_Invoiceinfo=[responceDic[@"result"]isKindOfClass:[NSDictionary class]]?responceDic[@"result"]:[NSDictionary dictionary];
            vc.str_code = [NSString stringWithFormat:@"%@",responceDic[@"code"]];
            vc.backIndex=@"0";
            [self.navigationController pushViewController:vc animated:YES];
            return;
        }
        NSString * error = [responceDic objectForKey:@"msg"];
        if (![error isKindOfClass:[NSNull class]]) {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:1.0];
        }else{
            [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:1.0];
        }
        return;
    }
    switch (serialNum) {
        case 0:
        {
            if ([responceDic[@"result"] isKindOfClass:[NSDictionary class]]) {
                _dic_baiwang = responceDic[@"result"];
                [self createSureView];
                [self updateMainView];
                [self updateGenreView];
                [self updateCateView];
                [self updateBottonView];
                if ([NSString isEqualToNull:_dic_baiwang[@"formatFile"]]) {
                    [self updateformatFile];
                }
                [self updatCateDesView];
                [self updateImageView];
                [self requestGetAddCostNewCategry];
            }
        }
            break;
        case 1:
        {
            [self dealWithType:responceDic];
            [self dealAgainChooseType];
            [self updateCateGoryView];
            
            break;
        }
        case 2:{
            NSArray *array = (NSArray *)[NSString transformToObj:[NSString stringWithFormat:@"%@",[responceDic objectForKey:@"result"]]];
            for (int i=0; i<array.count; i++) {
                [_totalArray replaceObjectAtIndex:[_imageTypeArray[i] integerValue] withObject:array[i]];
            }
            _str_imageDataString = [NSString transformToJsonWithOutEnter:_totalArray];
            [self requestaddRequestAddCostList];
        }
            break;
        case 3:{
            
            [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"导入成功", nil) duration:2.0];
            [self performBlock:^{
                if (!self.isAgain) {
                    [self Navback];
                }else{
                    [self.navigationController popViewControllerAnimated:YES];
                }
                
            } afterDelay:1.5];
        }
            break;
        case 5:
        {
            _arr_ClaimType=[NSMutableArray array];
            if ([responceDic[@"result"] isKindOfClass:[NSArray class]]) {
                [STOnePickModel getClaimTypeWithDate:responceDic[@"result"] WithResult:_arr_ClaimType];
            }
            
            [self initializeDate];
            [self initializeView];
            [self createMainView];
            [self getInvoicePhotoInfo];
            [self.totalArray addObjectsFromArray:self.arr_InvoicePhoto];
        }
            break;
        case 6:
            [self saveBaiwangInfoWithDict:responceDic];
            break;
        default:
            break;
    }
}

-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum{
    [YXSpritesLoadingView dismiss];
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];
}
-(void)saveBaiwangInfoWithDict:(NSDictionary *)dict{
    NSString *url=[NSString stringWithFormat:@"%@",addRequestAddCostList];
    if (_model_NewAddCost == nil) {
        _model_NewAddCost = [[NewAddCostModel alloc]init];
    }
    _model_NewAddCost.ExpenseCat = _str_expenseCat;
    _model_NewAddCost.ExpenseCatCode = _str_expenseCatCode;
    _model_NewAddCost.ExpenseCode = _str_expenseCode;
    _model_NewAddCost.ExpenseType = [NSString isEqualToNull:_str_category]?_str_category:@"";
    _model_NewAddCost.ExpenseIcon = _str_expenseIcon;
    _model_NewAddCost.Tag=_str_expenseTag;
    _model_NewAddCost.Type = [NSString isEqualToNull:_str_type]?[_str_type integerValue]:1;
    _model_NewAddCost.FP_DM = _exv_view.lab_invoiceCode.text;
    _model_NewAddCost.FP_HM = _exv_view.lab_invoiceNumber.text;
    _model_NewAddCost.DataSource = @"15";
    _model_NewAddCost.Attachments = _str_imageDataString;
    
    _model_NewAddCost.Tax = @"0";
    _model_NewAddCost.TaxRate = @"0";
    
    if ([[NSString stringWithIdOnNO:_dic_baiwang[@"invoiceType"]] isEqualToString:@"01"]) {
        _model_NewAddCost.InvoiceType =@"1";
        _model_NewAddCost.InvoiceTypeName = @"增值税专用发票";
    }
    
    if ([dict[@"result"]isKindOfClass:[NSArray class]]) {
        for (NSDictionary *dicts in dict[@"result"]) {
            if ([dicts[@"fieldName"]isEqualToString:@"TaxRate"]&&[dicts[@"isShow"]floatValue]==1&&[[NSString stringWithIdOnNO:_dic_baiwang[@"invoiceType"]] isEqualToString:@"01"]) {
                _model_NewAddCost.TaxRate = _dic_baiwang[@"taxRate"];
            }else if ([dicts[@"fieldName"]isEqualToString:@"Tax"]&&[dicts[@"isShow"]floatValue]==1&&[[NSString stringWithIdOnNO:_dic_baiwang[@"invoiceType"]] isEqualToString:@"01"]){
                _model_NewAddCost.Tax = [NSString isEqualToNull:_exv_view.lab_shuier.text]?[_exv_view.lab_shuier.text stringByReplacingOccurrencesOfString:@"," withString:@""]:@"";
            }
        }
    }
    _model_NewAddCost.ExclTax = [NSString stringWithFormat:@"%.2f", [[NSString stringWithIdOnNO:_dic_baiwang[@"totalAmount"]] floatValue]];
    _model_NewAddCost.Amount = [NSString stringWithFormat:@"%.2f", [[NSString stringWithIdOnNO:_dic_baiwang[@"amountTax"]] floatValue]];
    _model_NewAddCost.LocalCyAmount = [NSString stringWithFormat:@"%.2f", [[NSString stringWithIdOnNO:_dic_baiwang[@"amountTax"]] floatValue]];
    _model_NewAddCost.InvoiceNo = _exv_view.lab_invoiceNumber.text;
    _model_NewAddCost.HasInvoice = [NSString isEqualToNull:_str_imageDataString]?@"1":@"0";
    _model_NewAddCost.ExpenseDate = [NSString stringWithIdOnNO:_exv_view.lab_billingDate.text];
    _model_NewAddCost.ExpenseDesc = _txv_CateDes.text;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:[NSObject getObjectData:_model_NewAddCost]];
    
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:3 IfUserCache:NO];
}

#pragma mark  UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView == _clv_Category) {
        return CGSizeMake(Main_Screen_Width/5, 65);
    }else{
        return CGSizeMake(70, 70);
    }
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    if (collectionView == _clv_Category) {
        return 0;
    }else{
        if (Main_Screen_Width==320) {
            return 3;
        }else{
            return 5;
        }
    }
}
//设置头部视图的大小

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (collectionView == _clv_Category) {
        return CGSizeMake(Main_Screen_Width, 20);
    }else{
        return CGSizeZero;
    }
}

#pragma mark   CollectionView Delegate & DataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _arr_category.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    _cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CategoryCollectCell" forIndexPath:indexPath];
    [_cell configWithArray:_arr_category withRow:indexPath.row];
    return _cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CostCateNewModel *model=_arr_category[indexPath.row];
    if (![model.expenseType isEqualToString:_str_category]) {
        _img_category.image = [UIImage imageNamed:[NSString isEqualToNull:model.expenseIcon]?model.expenseIcon:@"15"];
        _str_category = [NSString isEqualToNull:model.expenseType]?model.expenseType:@"";
        _str_expenseCode = model.expenseCode;
        _str_expenseIcon = model.expenseIcon;
        _str_expenseCat = model.expenseCat;
        _str_expenseCatCode = model.expenseCatCode;
        _str_expenseTag=model.tag;
        _txf_Cate.text = [NSString stringWithFormat:@"%@",_str_category];
        [self updateCateGoryView];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
