//
//  CtripLoadInViewController.m
//  galaxy
//
//  Created by hfk on 2019/5/22.
//  Copyright © 2019 赵碚. All rights reserved.
//

#import "CtripLoadInViewController.h"

@interface CtripLoadInViewController ()

@property (nonatomic, strong) NSString *str_type;
@property (nonatomic, strong) NSString *str_typeName;
@property (nonatomic, strong) NSMutableArray *arr_ClaimType;//报销类型

@end

@implementation CtripLoadInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:Custing(@"导入订单", nil)  backButton:YES];
    [self createScrollView];
    [self createMainViews];
    [self getReimTypes];
}
//MARK:创建视图
-(void)createScrollView{
    UIScrollView *scrollView = UIScrollView.new;
    self.scrollView = scrollView;
    scrollView.backgroundColor = Color_White_Same_20;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
    [self.scrollView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    self.contentView =[[BottomView alloc]init];
    self.contentView.userInteractionEnabled=YES;
    self.contentView.backgroundColor=Color_White_Same_20;
    [self.scrollView addSubview:self.contentView];
    [self.contentView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];
}
-(void)createMainViews{
    _GenreView=[[UIView alloc]init];
    _GenreView.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_GenreView];
    [_GenreView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
    }];
    
    _CateView=[[UIView alloc]init];
    _CateView.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_CateView];
    [_CateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.GenreView.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _CategoryView=[[UIView alloc]init];
    _CategoryView.backgroundColor=Color_White_Same_20;
    [self.contentView addSubview:_CategoryView];
    [_CategoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.CateView.bottom);
        make.left.right.equalTo(self.contentView);
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
    [_CategoryView addSubview:_CategoryCollectView];
    
    [_CategoryCollectView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.CategoryView.top);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_CateDes=[[UIView alloc]init];
    _View_CateDes.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_CateDes];
    [_View_CateDes mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.CategoryView.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _LoadView=[[UIView alloc]init];
    _LoadView.backgroundColor=Color_White_Same_20;
    [self.contentView addSubview:_LoadView];
    [_LoadView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_CateDes.bottom);
        make.left.right.equalTo(self.contentView);
    }];
}
//MARK:network
-(void)getReimTypes{
    NSString *url=[NSString stringWithFormat:@"%@",GETREIMTYPES];
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:nil Delegate:self SerialNum:1 IfUserCache:NO];
}
//MARK:获取类别
-(void)chooseCostCategry{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    NSDictionary *parameters = @{@"Type":self.str_type};
    NSString *url = [NSString stringWithFormat:@"%@",GetAddCostNewCategry];
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:2 IfUserCache:NO];
}
//MARK:请求成功
- (void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum {
    NSLog(@"resDic:%@",responceDic);
    [YXSpritesLoadingView dismiss];
    _resultDict = responceDic;
    NSString * success = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"success"]];
    if ([success isEqualToString:@"0"]){
        NSString * error = [responceDic objectForKey:@"msg"];
        if (![error isKindOfClass:[NSNull class]]) {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:1.0];
        }else{
            [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:1.0];
        }
        [YXSpritesLoadingView dismiss];
        return;
    }
    switch (serialNum) {
        case 1:
        {
            self.arr_ClaimType = [NSMutableArray array];
            if ([responceDic[@"result"] isKindOfClass:[NSArray class]]) {
                [STOnePickModel getClaimTypeWithDate:responceDic[@"result"] WithResult:self.arr_ClaimType];
            }
            [self initData];
            [self updateGenreView];
            [self updateCateView];
            [self updateCateDesView];
            [self updateLoadView];
            [self updateContentView];
            [self chooseCostCategry];
        }
            break;
        case 2:
            [self dealWithType];
            [self dealAgainChooseType];
            [self updateCateGoryView];
            break;
        default:
            break;
    }
}
//MARK:请求失败
-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum{
    [YXSpritesLoadingView dismiss];
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];
}
//MARK:初始化数据
-(void)initData{
    if (self.arr_ClaimType.count > 0) {
        STOnePickModel *model = self.arr_ClaimType[0];
        _str_type = model.Id;
        _str_typeName = model.Type;
    }
    _isOpenGener = YES;
    _categoryArr = [NSMutableArray array];
    _categoryString = @"";
    _expenseCode = @"";
    _expenseIcon = @"";
    _expenseCat = @"";
    _expenseCatCode = @"";
    _expenseTag = @"";
}
//MARK:费用类型数据处理
-(void)dealWithType{
    _categoryArr = [NSMutableArray array];
    NSDictionary *parDict = [CostCateNewModel getCostCateByDict:_resultDict array:self.categoryArr withType:1];
    _CateLevel = parDict[@"CateLevel"];
    _categoryRows = [parDict[@"categoryRows"]integerValue];
}
//MARK:改变报销类型后报销类别重置
-(void)dealAgainChooseType{
    _txf_Cate.text=nil;
    _categoryImage.image=nil;
    _categoryString=@"";
    _expenseCode=@"";
    _expenseIcon=@"";
    _expenseCat=@"";
    _expenseCatCode=@"";
    _expenseTag=@"";
}
//MARK:更新类型视图
-(void)updateGenreView{
    MyProcurementModel *model = [[MyProcurementModel alloc]init];
    model.Description = Custing(@"报销类型", nil);
    model.fieldValue = _str_typeName;
    model.tips = Custing(@"请选择", nil);
    _txf_genre = [[UITextField alloc]init];
    SubmitFormView *view = [[SubmitFormView alloc]initBaseView:_GenreView WithContent:_txf_genre WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model){
        [weakSelf selectedTypeOrCateary];
    }];
    [_GenreView addSubview:view];
}

//MARK:更新费用类别选择
-(void)updateCateView{
    MyProcurementModel *model = [[MyProcurementModel alloc]init];
    model.Description = Custing(@"费用类别Add", nil);
    model.tips = Custing(@"请选择", nil);
    _txf_Cate = [[UITextField alloc]init];
    SubmitFormView *view = [[SubmitFormView alloc]initBaseView:_CateView WithContent:_txf_Cate WithFormType:formViewSelectCate WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    [view setCateClickedBlock:^(MyProcurementModel *model,UIImageView *image){
        weakSelf.categoryImage=image;
        [weakSelf CategoryClick];
    }];
    [_CateView addSubview:view];
}
//MARK:更新费用类型选择
-(void)updateCateGoryView{
    if ([_CateLevel isEqualToString:@"1"]) {
        self.isOpenGener = !self.isOpenGener;
        if (self.isOpenGener) {
            if (_categoryRows == 0) {
                [_CategoryView updateConstraints:^(MASConstraintMaker *make) {
                    make.height.equalTo(@0);
                }];
                [_CategoryCollectView updateConstraints:^(MASConstraintMaker *make) {
                    make.height.equalTo(@10);
                }];
            }else{
                [_CategoryView updateConstraints:^(MASConstraintMaker *make) {
                    make.height.equalTo(@((65*self.categoryRows)+20));
                }];
                [_CategoryCollectView updateConstraints:^(MASConstraintMaker *make) {
                    make.height.equalTo(@((65*self.categoryRows)+20));
                }];
            }
        }else{
            [_CategoryView updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@0);
            }];
            [_CategoryCollectView updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@0);
            }];
        }
        [_CategoryCollectView reloadData];
    }else{
        self.isOpenGener = NO;
        [_CategoryView updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
        }];
        [_CategoryCollectView updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
        }];
    }
}
//MARK:费用描述
-(void)updateCateDesView{
    MyProcurementModel *model = [[MyProcurementModel alloc]init];
    model.Description = Custing(@"费用描述", nil);
    model.tips = Custing(@"请输入费用描述", nil);
    _txv_CateDes = [[UITextView alloc]init];
    SubmitFormView *view = [[SubmitFormView alloc]initBaseView:_View_CateDes WithContent:_txv_CateDes WithFormType:formViewVoiceTextView WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_CateDes addSubview:view];
}
//MARK: 更新确认按钮
-(void)updateLoadView{
    [_LoadView updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@60);
    }];
    UIButton * importBtn = [GPUtils createButton:CGRectMake(15, 15, Main_Screen_Width-30, 45) action:@selector(InputInvoice) delegate:self title:Custing(@"确认导入", nil) font:Font_Important_15_20 titleColor:Color_form_TextFieldBackgroundColor];
    [importBtn setBackgroundColor:Color_Blue_Important_20];
    importBtn.layer.cornerRadius = 15.0f;
    [_LoadView addSubview:importBtn];
}
//MARK:更新根视图
-(void)updateContentView{
    [self.contentView makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.LoadView.bottom);
    }];
    [self.contentView layoutIfNeeded];
}
//MARK:费用类型选择
-(void)selectedTypeOrCateary{
    STOnePickView *picker = [[STOnePickView alloc]init];
    __weak typeof(self) weakSelf = self;
    [picker setBlock:^(STOnePickModel *Model, NSInteger type) {
        if (![weakSelf.str_type isEqualToString:Model.Id]) {
            weakSelf.str_type = Model.Id;
            weakSelf.str_typeName = Model.Type;
            weakSelf.txf_genre.text = Model.Type;
            self.isOpenGener = NO;
            [weakSelf chooseCostCategry];
        }
    }];
    picker.typeTitle=Custing(@"报销类型", nil);
    picker.DateSourceArray=self.arr_ClaimType;
    STOnePickModel *model=[[STOnePickModel alloc]init];
    model.Id=[NSString isEqualToNull:self.str_type]?self.str_type:@"";
    picker.Model=model;
    [picker UpdatePickUI];
    [picker setContentMode:STPickerContentModeBottom];
    [picker show];
}
//MARK:费用类别选择
-(void)CategoryClick{
    if (![NSString isEqualToNull:self.txf_genre.text]) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"请选择报销类型", nil) duration:1.0];
        return;
    }
    if (_categoryArr.count == 0) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"没相关费用类别", nil) duration:1.0];
        return;
    }
    if ([_CateLevel isEqualToString:@"1"]) {
        [self updateCateGoryView];
    }else if ([_CateLevel isEqualToString:@"2"]){
        STPickerCategory *pickerArea = [[STPickerCategory alloc]init];
        pickerArea.DateSourceArray = [NSMutableArray arrayWithArray:self.categoryArr];
        CostCateNewSubModel *model = [[CostCateNewSubModel alloc]init];
        model.expenseCode = _expenseCode;
        pickerArea.CateModel = model;
        [pickerArea UpdatePickUI];
        if ([self.str_type isEqualToString:@"1"]) {
            pickerArea.str_flowCode = @"F0002";
        }else if ([self.str_type isEqualToString:@"2"]){
            pickerArea.str_flowCode = @"F0003";
        }else if ([self.str_type isEqualToString:@"3"]){
            pickerArea.str_flowCode = @"F0010";
        }
        [pickerArea setContentMode:STPickerContentModeBottom];
        __weak typeof(self) weakSelf = self;
        [pickerArea setChooseCateBlock:^(CostCateNewModel *firstModel, CostCateNewSubModel *secondModel) {
            if (![secondModel.expenseType isEqualToString:weakSelf.categoryString]) {
                weakSelf.categoryImage.image = [UIImage imageNamed:[NSString isEqualToNull:secondModel.expenseIcon]?secondModel.expenseIcon:@"15"];
                weakSelf.categoryString = [NSString isEqualToNull:secondModel.expenseType]?secondModel.expenseType:@"";
                weakSelf.expenseCode = secondModel.expenseCode;
                weakSelf.expenseIcon = secondModel.expenseIcon;
                weakSelf.expenseCat = secondModel.expenseCat;
                weakSelf.expenseCatCode = secondModel.expenseCatCode;
                weakSelf.expenseTag = secondModel.tag;
                weakSelf.txf_Cate.text = [GPUtils getSelectResultWithArray:@[secondModel.expenseCat,secondModel.expenseType]];
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
                weakSelf.categoryImage.image = [UIImage imageNamed:[NSString isEqualToNull:model.expenseIcon]?model.expenseIcon:@"15"];
                weakSelf.categoryString = [NSString isEqualToNull:model.expenseType]?model.expenseType:@"";
                weakSelf.expenseCode = model.expenseCode;
                weakSelf.expenseIcon = model.expenseIcon;
                weakSelf.expenseCat = model.expenseCat;
                weakSelf.expenseCatCode = model.expenseCatCode;
                weakSelf.expenseTag = model.tag;
                weakSelf.txf_Cate.text = [GPUtils getSelectResultWithArray:@[model.expenseCat,model.expenseType]];
            }
        };
        [self.navigationController pushViewController:ex animated:YES];
    }
}
//MARK:确认导入
-(void)InputInvoice{
    
     
    
    
    
    
//    if (![NSString isEqualToNull:self.txf_genre.text]) {
//        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"请选择报销类型", nil) duration:1.0];
//        return;
//    }
//    if (![NSString isEqualToNull:self.txf_Cate.text]) {
//        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"请选择费用类别", nil) duration:1.0];
//        return;
//    }
//    NSDictionary *dict=@{@"Type":[NSString isEqualToNull:self.str_type]?self.str_type:@"1",
//                         @"ExpenseCode":_expenseCode,
//                         @"ExpenseType":_categoryString,
//                         @"ExpenseIcon":_expenseIcon,
//                         @"ExpenseCatCode":_expenseCatCode,
//                         @"ExpenseCat":_expenseCat,
//                         @"ExpenseDesc":[NSString isEqualToNull:_txv_CateDes.text]?_txv_CateDes.text:@"",
//                         @"Tag":_expenseTag,
//                         @"Invoices":_InvoiceList
//                         };
//
//    NSDictionary *parameter=@{@"invs":[self transformToJson:dict]};
//    NSString *url=[NSString stringWithFormat:@"%@",WECHATCARDSAVE];
//    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
//    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameter Delegate:self SerialNum:1 IfUserCache:NO];
}
#pragma mark - UICollectionViewDelegateFlowLayout
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
#pragma mark - CollectionView Delegate & DataSource
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

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    CostCateNewModel *model=_categoryArr[indexPath.row];
    if (![model.expenseType isEqualToString:_categoryString]) {
        _categoryImage.image =[UIImage imageNamed:[NSString isEqualToNull:model.expenseIcon]?model.expenseIcon:@"15"];       _categoryString=[NSString isEqualToNull:model.expenseType]?model.expenseType:@"";
        _expenseCode=model.expenseCode;
        _expenseIcon=model.expenseIcon;
        _expenseCat=model.expenseCat;
        _expenseCatCode=model.expenseCatCode;
        _expenseTag=model.tag;
        _txf_Cate.text=[GPUtils getSelectResultWithArray:@[model.expenseCat,model.expenseType]];;
        [self updateCateGoryView];
    }else{
        [self updateCateGoryView];
    }
    
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
