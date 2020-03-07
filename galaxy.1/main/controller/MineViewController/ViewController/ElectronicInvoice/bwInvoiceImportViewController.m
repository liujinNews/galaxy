//
//  bwInvoiceImportViewController.m
//  galaxy
//
//  Created by 贺一鸣 on 2017/11/20.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "bwInvoiceImportViewController.h"
#import "NewAddCostModel.h"

@interface bwInvoiceImportViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource,chooseTravelDateViewDelegate,GPClientDelegate>

//滚动视图
@property (nonatomic,strong)UIScrollView * scrollView;
//滚动视图contentView
@property (nonatomic,strong)BottomView *contentView;
//费用类型视图
@property(nonatomic,strong)UIView *GenreView;
//费用类型Label
@property (nonatomic,strong)UILabel * genreLab;
//费用类别视图
@property(nonatomic,strong)UIView *CateView;

@property(nonatomic,strong)NSMutableArray *AddCostTotalCateArray;

@property (nonatomic,strong)UIPickerView * pickerView;//弹出的时间图
@property (nonatomic,strong)chooseTravelDateView * typelView;//报销类型选择弹出框

@property (nonatomic,strong)NSString * typeStr;
@property (nonatomic,strong)NSString *CateLevel;

@property(nonatomic,strong)NSString *expenseCat;
@property(nonatomic,strong)NSString *expenseCatCode;
@property(nonatomic,assign)BOOL isOpenGener;
//费用类别image
@property(nonatomic,strong)UIImageView * CateImage;
//费用类别Label
@property (nonatomic,strong)UILabel * CateLab;
//费用类别图片
@property(nonatomic,strong)UIImageView * categoryImage;
//费用类别选择视图
@property(nonatomic,strong)UIView *CategoryView;
//费用类别collectView
@property(nonatomic,strong)UICollectionView *CategoryCollectView;
@property(nonatomic,strong)UICollectionViewFlowLayout *CategoryLayOut;
@property(nonatomic,strong)CategoryCollectCell *cell;

@property(nonatomic,strong)NSMutableArray * categoryArr;
@property(nonatomic,assign)NSInteger categoryRows;

@property(nonatomic,strong)NSString *categoryString;    //类别字符串
@property(nonatomic,strong)NSString *expenseCode;   //费用类别编码
@property(nonatomic,strong)NSString *expenseIcon;   //费用类别图片编码
@property (nonatomic ,strong) NSString *expense_tag;

@property (nonatomic, strong) UIButton *btn_left;

@end

@implementation bwInvoiceImportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setTitle:Custing(@"发票详情", nil)  backButton:YES];
    [self initializeData];
    [self AddCostTotalCateArray];
    [self createScrollView];
    [self createRightBtn];
    [self createMainViews];
    
    [self updateGenreView];
    [self updateCateView];
    [self updateContentView];
    [self requestDriveCarGetExpTypByDriveCar];
}

//MARK:创建滚动视图
-(void)createScrollView{
    UIScrollView *scrollView = UIScrollView.new;
    self.scrollView = scrollView;
    scrollView.backgroundColor =Color_White_Same_20;
    scrollView.showsVerticalScrollIndicator=NO;
    scrollView.delegate=self;
    [self.view addSubview:scrollView];
    
    [self.scrollView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(@-50);
    }];
    
    self.contentView =[[BottomView alloc]init];
    self.contentView.userInteractionEnabled=YES;
    self.contentView.backgroundColor=Color_White_Same_20;
    [self.scrollView addSubview:self.contentView];
    
    [self.contentView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView);
        make.left.equalTo(self.scrollView);
        make.right.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
        make.bottom.equalTo(self.scrollView).equalTo(@-50);
    }];
}

-(void)createRightBtn{
    //    _btn_left = [GPUtils createButton:CGRectMake(0, 0, 60, 40) action:@selector(btn_click:) delegate:self title:Custing(@"确定导入", nil) font:Font_Same_14_20 titleColor:Color_Blue_Important_20];
    //    _btn_left.contentEdgeInsets = UIEdgeInsetsMake(0,0, 0,-10);
    //    UIBarButtonItem *right_btn = [[UIBarButtonItem alloc]initWithCustomView:_btn_left];
    //    [self.navigationItem setRightBarButtonItem:right_btn];
    
    UIButton * importBtn = [GPUtils createButton:CGRectMake(0, Main_Screen_Height-49-NavigationbarHeight, Main_Screen_Width, 49) action:@selector(btn_click:) delegate:self title:Custing(@"确定导入", nil) font:Font_Important_15_20 titleColor:Color_form_TextFieldBackgroundColor];
    [importBtn setBackgroundColor:Color_Blue_Important_20];
    [self.view addSubview:importBtn];
    
}

//MARK:创建主视图
-(void)createMainViews{
    self.GenreView=[[UIView alloc]init];
    self.GenreView.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:self.GenreView];
    [self.GenreView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.left.right.equalTo(self.contentView);
        make.width.equalTo(self.contentView.width);
    }];
    
    self.CateView=[[UIView alloc]init];
    self.CateView.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:self.CateView];
    [self.CateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.GenreView.bottom);
        make.left.right.equalTo(self.contentView);
        make.width.equalTo(self.contentView.width);
    }];
    
    self.CategoryView=[[UIView alloc]init];
    self.CategoryView.backgroundColor=Color_White_Same_20;
    [self.contentView addSubview:self.CategoryView];
    [self.CategoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.CateView.bottom);
        make.left.right.equalTo(self.contentView);
        make.width.equalTo(self.contentView.width);
    }];
    
    _CategoryLayOut = [[UICollectionViewFlowLayout alloc] init];
    _CategoryLayOut.minimumInteritemSpacing =1;
    _CategoryLayOut.minimumLineSpacing =1;
    _CategoryCollectView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:_CategoryLayOut];
    _CategoryCollectView.delegate = self;
    _CategoryCollectView.dataSource = self;
    _CategoryCollectView.backgroundColor =Color_White_Same_20;
    _CategoryCollectView.scrollEnabled=NO;
    [_CategoryCollectView registerClass:[CategoryCollectCell class] forCellWithReuseIdentifier:@"CategoryCollectCell"];
    [self.CategoryView addSubview:_CategoryCollectView];
    
    [_CategoryCollectView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.CategoryView.top);
        make.left.right.equalTo(self.contentView);
        make.width.equalTo(self.contentView.width);
    }];
}

//MARK:更新类型视图
-(void)updateGenreView{
    [self.GenreView updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@60);
    }];
    
    [self.GenreView addSubview:[self createDownLineView]];
    UILabel * titleLbl = [GPUtils createLable:CGRectMake(0,0,70, 16) text:Custing(@"报销类型", nil) font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    titleLbl.center=CGPointMake(50, 35);
    [self.GenreView addSubview:titleLbl];
    
    ChooseCategoryModel *model = [[ChooseCategoryModel alloc]init];
    if (_AddCostTotalCateArray.count>0) {
        model = _AddCostTotalCateArray[0];
    }
    _typeStr = model.addCostCode;
    _genreLab=[GPUtils createLable:CGRectMake(0, 0,Main_Screen_Width-160, 18) text:model.addCostType font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentRight];
    _genreLab.center=CGPointMake(Main_Screen_Width/2+38, 35);
    [self.GenreView addSubview:_genreLab];
    
    UIImageView *genreImage=[GPUtils createImageViewFrame:CGRectMake(0, 0, 20, 20) imageName:@"skipImage"];
    genreImage.center=CGPointMake(Main_Screen_Width-25, 35);
    [self.GenreView addSubview:genreImage];
    
    UIButton *btn=[GPUtils createButton:CGRectMake(Main_Screen_Width/2, 10, Main_Screen_Width/2, 50) action:@selector(selectedTypeOrCateary:) delegate:self];
    [self.GenreView addSubview:btn];
    
}

//MARK:更新费用类别选择
-(void)updateCateView{
    [self.CateView updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@60);
    }];
    
    UIView *lineUp=[[UIView alloc]initWithFrame:CGRectMake(0,59.48, Main_Screen_Width,0.5)];
    lineUp.backgroundColor=Color_GrayLight_Same_20;
    [self.CateView addSubview:lineUp];
    
    [self.CateView addSubview:[self createLineView]];
    UILabel * titleLbl = [GPUtils createLable:CGRectMake(0,0,70, 16) text:Custing(@"费用类别Add", nil) font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    titleLbl.center=CGPointMake(50, 35);
    [self.CateView addSubview:titleLbl];
    _CateLab=[GPUtils createLable:CGRectMake(0, 0,Main_Screen_Width-160, 18) text:Custing(@"请选择", nil) font:Font_Important_15_20 textColor:Color_LabelPlaceHolder_Same_20 textAlignment:NSTextAlignmentRight];
    _CateLab.center=CGPointMake(Main_Screen_Width/2+38, 35);
    [self.CateView addSubview:_CateLab];
    
    _categoryImage=[GPUtils createImageViewFrame:CGRectMake(0, 0, 32, 32) imageName:nil];
    _categoryImage.center=CGPointMake(Main_Screen_Width-56, 35);
    [self.CateView addSubview:_categoryImage];
    
    _CateImage=[GPUtils createImageViewFrame:CGRectMake(0, 0, 20, 20) imageName:@"skipImage"];
    _CateImage.center=CGPointMake(Main_Screen_Width-25, 35);
    [self.CateView addSubview:_CateImage];
    
    UIButton *btn=[GPUtils createButton:CGRectMake(Main_Screen_Width/2, 10, Main_Screen_Width/2, 50) action:@selector(CategoryClick:) delegate:self];
    [self.CateView addSubview:btn];
    if ([NSString isEqualToNull:_categoryString]) {
        _CateLab.center=CGPointMake(Main_Screen_Width/2+3, 35);
        _CateLab.textColor=Color_form_TextField_20;
        _CateLab.text=[NSString stringWithFormat:@"%@",_categoryString];
        _categoryImage.image =[UIImage imageNamed:[NSString isEqualToNull:_expenseIcon]?_expenseIcon:@"15"];
    }
    
}

-(void)updateContentView{
    [self.contentView makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.CategoryView.bottom);
    }];
    [self.contentView layoutIfNeeded];
}

-(void)initializeData{
    _categoryRows = 0;
    _expense_tag = @"";
    _categoryArr = [NSMutableArray array];
    _typeStr = @"";
    _isOpenGener = YES;
}

-(NSMutableArray *)AddCostTotalCateArray{
    if (_AddCostTotalCateArray==nil) {
        _AddCostTotalCateArray=[NSMutableArray array];
        NSMutableArray *type = [NSMutableArray array];
        NSMutableArray *code = [NSMutableArray array];
        if ([self.userdatas.arr_XBFlowcode containsObject:@"F0002"]) {
            [type addObject:Custing(@"差旅费", nil)];
            [code addObject:@"1"];
        }
        if ([self.userdatas.arr_XBFlowcode containsObject:@"F0003"]){
            [type addObject:Custing(@"日常费", nil)];
            [code addObject:@"2"];
        }
        if ([self.userdatas.arr_XBFlowcode containsObject:@"F0010"]){
            [type addObject:Custing(@"专项费", nil)];
            [code addObject:@"3"];
        }
        for (int i=0; i<type.count; i++) {
            ChooseCategoryModel *model=[[ChooseCategoryModel alloc]init];
            model.addCostType=type[i];
            model.addCostCode=code[i];
            [_AddCostTotalCateArray addObject:model];
        }
    }
    return _AddCostTotalCateArray;
}

-(void)createFootView {
    _pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 139)];
    self.pickerView.dataSource = self;
    self.pickerView.delegate = self;
    
    if ([self.genreLab.text isEqualToString:Custing(@"请选择", nil)]) {
        [self.pickerView selectRow:1 inComponent:0 animated:NO];
    }else {
        [self.pickerView selectRow:[self.typeStr integerValue]-1 inComponent:0 animated:NO];
    }
    
    
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0,ScreenRect.size.width, 50)];
    
    UILabel * xuanzhe = [GPUtils createLable:CGRectMake(0, 0,WIDTH(view), 50) text:Custing(@"请选择报销类型", nil) font:Font_cellContent_16 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentCenter];
    xuanzhe.backgroundColor = [GPUtils colorHString:ColorBanground];
    [view addSubview:xuanzhe];
    
    UIButton *sureBtn=[[UIButton alloc]initWithFrame:CGRectMake(WIDTH(view)-50, 0, 50, 50)];
    sureBtn.backgroundColor = [UIColor clearColor];
    [sureBtn setImage:GPImage(@"Add_Save") forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(selectedType:) forControlEvents:UIControlEventTouchUpInside];
    
    [view addSubview:sureBtn];
    
    if (!_typelView) {
        _typelView=[[chooseTravelDateView alloc]initWithFrame:CGRectMake(0, ApplicationDelegate.window.bounds.size.height, 0, self.pickerView.frame.size.height+50) pickerView:self.pickerView titleView:view];
        _typelView.delegate = self;
    }
    [_typelView showUpView:self.pickerView];
}

-(void)updateMainCate:(NSDictionary *)dic{
    if (dic) {
        if ([dic[@"result"] isKindOfClass:[NSDictionary class]]) {
            _categoryImage.image = [UIImage imageNamed:[NSString isEqualToNull:dic[@"result"][@"expenseIcon"]]?dic[@"result"][@"expenseIcon"]:@"15"];
            _categoryString = [NSString isEqualToNull:dic[@"result"][@"expenseType"]]?dic[@"result"][@"expenseType"]:@"";
            _expenseCode = dic[@"result"][@"expenseCode"];
            _expenseIcon = dic[@"result"][@"expenseIcon"];
            _expenseCat = dic[@"result"][@"expenseCat"];
            _expenseCatCode = dic[@"result"][@"expenseCatCode"];
            _expense_tag = dic[@"result"][@"tag"];
            _CateLab.center=CGPointMake(Main_Screen_Width/2+3, 35);
            _CateLab.text=[GPUtils getSelectResultWithArray:@[dic[@"result"][@"expenseCat"],dic[@"result"][@"expenseType"]]];
            _CateLab.textColor=Color_form_TextField_20;
        }
    }else{
        
    }
}

-(void)updateAgainCateGoryView{
    NSLog(@"%@",_CateLevel);
    if ([_CateLevel isEqualToString:@"1"]) {
        _CateImage.image=[UIImage imageNamed:@"share_Open"];
        _isOpenGener=YES;
        if (_categoryRows==0) {
            [self.CategoryView updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@0);
            }];
            [_CategoryCollectView updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@10);
            }];
        }else{
            [self.CategoryView updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@((65*self.categoryRows)+20));
            }];
            [_CategoryCollectView updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@((65*self.categoryRows)+20));
            }];
        }
        [_CategoryCollectView reloadData];
    }else{
        _CateImage.image=[UIImage imageNamed:@"skipImage"];
        [self.CategoryView updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
        }];
        [_CategoryCollectView updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
        }];
    }
}

//MARK:更新费用类型选择
-(void)updateCateGoryView{
    
    _CateImage.image=[UIImage imageNamed:@"skipImage"];
    _isOpenGener=NO;
    [self.CategoryView updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@0);
    }];
    [_CategoryCollectView updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@0);
    }];
}

//MARK:费用类型数据处理
-(void)dealWithType:(NSDictionary *)dic{
    _categoryArr=[NSMutableArray array];
    NSDictionary *parDict= [CostCateNewModel getCostCateByDict:dic array:_categoryArr withType:1];
    _CateLevel=parDict[@"CateLevel"];
    _categoryRows=[parDict[@"categoryRows"]integerValue];
}
//MARK:改变报销类型后报销类别重置
-(void)dealAgainChooseType{
    
    _CateLab.center=CGPointMake(Main_Screen_Width/2+38, 35);
    _CateLab.textColor=Color_LabelPlaceHolder_Same_20;
    _CateLab.text=Custing(@"请选择", nil);
    
    _categoryImage.center=CGPointMake(Main_Screen_Width-56, 35);
    _categoryImage.image=nil;
    _categoryString=@"";
    _expenseCode=@"";
    _expenseIcon=@"";
    _expense_tag = @"";
}


-(void)requestDriveCarGetExpTypByDriveCar {
    NSString *url=[NSString stringWithFormat:@"%@",DriveCarGetExpTypByDriveCar];
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:@{} Delegate:self SerialNum:0 IfUserCache:NO];
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
}

-(void)requestExpuserImportBatchExp{
    NSString *url=[NSString stringWithFormat:@"%@",baiwangAddInv];
    NSMutableArray *arr_request = [NSMutableArray array];
    for (int i = 0; i<_arr_Data.count; i++) {
        NSDictionary *dic = _arr_Data[i];
        NSMutableDictionary *cateDic = [NSMutableDictionary dictionaryWithDictionary:@{@"fP_DM":dic[@"fP_DM"],@"fP_HM":dic[@"fP_HM"],@"fplx":dic[@"fplx"],@"gmF_MC":dic[@"gmF_MC"],@"jshj":dic[@"jshj"]}];
        [arr_request addObject:cateDic];
    }
    
    
    NSDictionary * dict = @{@"AccountType":_str_AccountType,@"AccountNo":_str_AccountNo,@"Type":_typeStr,@"Attachments":@"",@"ExpenseCode":_expenseCode,@"ExpenseType":_CateLab.text,@"ExpenseIcon":_expenseIcon,@"InvItems":arr_request,@"ExpenseCat":_expenseCat,@"ExpenseCatCode":_expenseCatCode};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:@{@"Invoices":[NSString transformToJson:dict]} Delegate:self SerialNum:1 IfUserCache:NO];
}

-(void)requestGetAddCostNewCategry{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    NSDictionary *parameters=@{@"Type":self.typeStr};
    NSString *url=[NSString stringWithFormat:@"%@",GetAddCostNewCategry];
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:2 IfUserCache:NO];
}


#pragma  mark - action
-(void)selectedTypeOrCateary:(UIButton *)btn{
    [self createFootView];
}

//报销类型点击
-(void)selectedType:(UIButton *)btn {
    [self keyClose];
    [self.typelView remove];
    [self dimsissPDActionView];
    [self requestGetAddCostNewCategry];
    
    if ([NSString isEqualToNull:self.typeStr]) {
        self.genreLab.text = [self.typeStr integerValue]==1?Custing(@"差旅Add", nil):[self.typeStr integerValue]==3?Custing(@"专项费", nil):Custing(@"日常Add", nil);
    }else {
        self.genreLab.text = Custing(@"日常费", nil);
    }
    self.genreLab.textColor = Color_Black_Important_20;
}

-(void)btn_click:(UIButton *)btn{
    if ([self.genreLab.text isEqualToString:Custing(@"请选择", nil)]) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"请选择报销类型", nil) duration:1.0];
        return;
    }
    if ([_CateLab.text isEqualToString:Custing(@"请选择", nil)]) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"请选择费用类别", nil) duration:1.0];
        return;
    }
    [self requestExpuserImportBatchExp];
}

-(void)CategoryClick:(UIButton *)btn{
    if ([self.genreLab.text isEqualToString:Custing(@"请选择", nil)]) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"请选择报销类型", nil) duration:1.0];
        return;
    }
    NSLog(@"费用类型类别选择");
    if (_categoryArr.count==0) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"没相关费用类别", nil) duration:1.0];
        return;
    }
    
    if ([_CateLevel isEqualToString:@"1"]) {
        if (_isOpenGener ==YES) {
            [self updateCateGoryView];
        }else {
            [self updateAgainCateGoryView];
        }
        
    }else if ([_CateLevel isEqualToString:@"2"]){
        STPickerCategory *pickerArea = [[STPickerCategory alloc]init];
        pickerArea.DateSourceArray=[NSMutableArray arrayWithArray:_categoryArr];
        CostCateNewSubModel *model=[[CostCateNewSubModel alloc]init];
        model.expenseCode=_expenseCode;
        pickerArea.CateModel=model;
        [pickerArea UpdatePickUI];
        [pickerArea setContentMode:STPickerContentModeBottom];
        if ([_typeStr isEqualToString:@"1"]) {
            pickerArea.str_flowCode=@"F0002";
        }else if ([_typeStr isEqualToString:@"2"]){
            pickerArea.str_flowCode=@"F0003";
        }else if ([_typeStr isEqualToString:@"3"]){
            pickerArea.str_flowCode=@"F0010";
        }
        __weak typeof(self) weakSelf = self;
        [pickerArea setChooseCateBlock:^(CostCateNewModel *firstModel, CostCateNewSubModel *secondModel) {
            [weakSelf keyClose];
            if (![secondModel.expenseType isEqualToString:weakSelf.categoryString]) {
                weakSelf.categoryImage.image = [UIImage imageNamed:[NSString isEqualToNull:secondModel.expenseIcon]?secondModel.expenseIcon:@"15"];
                weakSelf.CateLab.text = [GPUtils getSelectResultWithArray:@[secondModel.expenseCat,secondModel.expenseType]];
                weakSelf.CateLab.textColor=Color_form_TextField_20;
                weakSelf.CateLab.center=CGPointMake(Main_Screen_Width/2+3, 35);
                weakSelf.categoryString = [NSString isEqualToNull:secondModel.expenseType]?secondModel.expenseType:@"";
                weakSelf.expenseCode = secondModel.expenseCode;
                weakSelf.expenseIcon = [NSString isEqualToNull:secondModel.expenseIcon]?secondModel.expenseIcon:@"15";
                weakSelf.expense_tag = secondModel.tag;
                weakSelf.expenseCat = secondModel.expenseCat;
                weakSelf.expenseCatCode = secondModel.expenseCatCode;
                [weakSelf updateCateGoryView];
            }
        }];
        [pickerArea show];
    }else if([_CateLevel isEqualToString:@"3"]){
        ExpenseCodeListViewController *ex = [[ExpenseCodeListViewController alloc]init];
        ex.arr_DataList = _categoryArr;
        ex.str_CateLevel = _CateLevel;
        __weak typeof(self) weakSelf = self;
        ex.CellClick = ^(CostCateNewSubModel *model) {
            if (![model.expenseType isEqualToString:weakSelf.categoryString]) {
                weakSelf.categoryImage.image =[UIImage imageNamed:[NSString isEqualToNull:model.expenseIcon]?model.expenseIcon:@"15"];
                weakSelf.categoryString=[NSString isEqualToNull:model.expenseType]?model.expenseType:@"";
                weakSelf.expenseCode=model.expenseCode;
                weakSelf.expenseIcon=model.expenseIcon;
                weakSelf.expenseCat=model.expenseCat;
                weakSelf.expenseCatCode=model.expenseCatCode;
                weakSelf.CateLab.center=CGPointMake(Main_Screen_Width/2+3, 35);
                weakSelf.CateLab.text=[GPUtils getSelectResultWithArray:@[model.expenseCat,model.expenseType]];
                weakSelf.CateLab.textColor=Color_form_TextField_20;
                weakSelf.expense_tag = model.tag;
            }
        };
        [self.navigationController pushViewController:ex animated:YES];
    }
}


#pragma mark - delegate
- (void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum {
    [YXSpritesLoadingView dismiss];
    NSString * success = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"success"]];
    if ([success isEqualToString:@"0"]) {
        NSString * error = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"msg"]];
        [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:2.0];
        if (serialNum == 0) {
            [self requestGetAddCostNewCategry];
        }
        return;
    }
    
    switch (serialNum) {
        case 0:
            [self updateMainCate:responceDic];
            [self requestGetAddCostNewCategry];
            break;
        case 1:
        {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"导入成功", nil) duration:2.0];
            [self performBlock:^{
                [self returnBack];
            } afterDelay:1.5];
            break;
        }
        case 2:
        {
            [self dealWithType:responceDic];
            [self dealAgainChooseType];
            [self updateAgainCateGoryView];
        }
            break;
        default:
            break;
    }
    
}

-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum{
    [YXSpritesLoadingView dismiss];
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];
}

#pragma mark   UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView==_CategoryCollectView) {
        return CGSizeMake(Main_Screen_Width/5, 65);
    }else{
        return CGSizeMake(70, 70);
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    if (collectionView==_CategoryCollectView) {
        return 0;
    }else{
        if (Main_Screen_Width==320) {
            return 3;
        }else{
            return 5;
        }
    }
}
#pragma mark 设置头部视图的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (collectionView==_CategoryCollectView) {
        return CGSizeMake(Main_Screen_Width, 20);
    }else{
        return CGSizeZero;
    }
}

#pragma mark  CollectionView Delegate & DataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _categoryArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    _cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CategoryCollectCell" forIndexPath:indexPath];
    [_cell configWithArray:_categoryArr withRow:indexPath.row];
    return _cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CostCateNewModel *model=_categoryArr[indexPath.row];
    if (![model.expenseType isEqualToString:_categoryString]) {
        _categoryImage.image =[UIImage imageNamed:[NSString isEqualToNull:model.expenseIcon]?model.expenseIcon:@"15"];
        _categoryString=[NSString isEqualToNull:model.expenseType]?model.expenseType:@"";
        _expenseCode=model.expenseCode;
        _expenseIcon=model.expenseIcon;
        _expenseCat=model.expenseCat;
        _expenseCatCode=model.expenseCatCode;
        _CateLab.center=CGPointMake(Main_Screen_Width/2+3, 35);
        _CateLab.text=[GPUtils getSelectResultWithArray:@[model.expenseCat,model.expenseType]];
        _CateLab.textColor=Color_form_TextField_20;
        _expense_tag = model.tag;
        [self updateCateGoryView];
    }
    
}

//MARK:费用类型选择代理
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.AddCostTotalCateArray.count;
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    ChooseCategoryModel * data = [self.AddCostTotalCateArray objectAtIndex:row];
    return data.addCostType;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 49;
}

//弹窗代理
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    ChooseCategoryModel * data = [self.AddCostTotalCateArray objectAtIndex:row];
    self.typeStr = data.addCostCode;
    _genreLab.text = data.addCostType;
}

//清除时间控制器
-(void)dimsissPDActionView{
    _typelView = nil;
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
