//
//  ReimShareController.m
//  galaxy
//
//  Created by hfk on 2017/9/18.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "ReimShareController.h"
#import "ComPeopleViewController.h"
@interface ReimShareController ()

@end

@implementation ReimShareController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:Custing(@"费用分摊", nil) backButton:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(editGroup:) name:@"edit_group" object:nil];
    [self initData];
    [self createScrollView];
    [self createMainView];
    [self updateMainView];
    [self updateContentView];
}
-(void)initData{
    _isShowmsArray=[[NSMutableArray alloc]initWithArray:@[@"BranchId",@"RequestorDeptId",@"RequestorBusDeptId",@"CostCenterId",@"ProjId",@"ExpenseCode",@"Reserved1",@"Reserved2",@"Reserved3",@"Reserved4",@"Reserved5",@"Amount",@"Remark"]];
    _UnShowmsArray=[[NSMutableArray alloc]initWithArray:@[@"BranchId",@"RequestorDeptId",@"RequestorBusDeptId",@"CostCenterId",@"ProjId",@"ExpenseCode",@"Reserved1",@"Reserved2",@"Reserved3",@"Reserved4",@"Reserved5",@"Amount",@"Remark"]];
    
    _isOpenGener=NO;
    _reservedDic = [[NSMutableDictionary alloc]init];
    _isRequiredmsdic=[[NSMutableDictionary alloc]init];
    _isCtrlTypdic=[[NSMutableDictionary alloc]init];
    self.model_ReserverModel=[[ReserverdMainModel alloc]init];
    if (!_model) {
        _model=[[ReimShareModel alloc]init];
    }
}
//MARK:创建scrollView
-(void)createScrollView{
    UIScrollView *scrollView = UIScrollView.new;
    self.scrollView = scrollView;
    scrollView.backgroundColor =Color_White_Same_20;
    scrollView.showsVerticalScrollIndicator=NO;
    scrollView.delegate=self;
    [self.view addSubview:scrollView];
    
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(@-50);
    }];
    
    self.contentView =[[BottomView alloc]init];
    self.contentView.userInteractionEnabled=YES;
    self.contentView.backgroundColor=Color_White_Same_20;
    [self.scrollView addSubview:self.contentView];
    
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];
    
    self.dockView=[[DoneBtnView alloc]initWithFrame:CGRectMake(0, Main_Screen_Height-NavigationbarHeight-50, Main_Screen_Width, 50)];
    self.dockView.userInteractionEnabled=YES;
    [self.view addSubview:self.dockView];
    [self.dockView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.equalTo(@50);
    }];
    [self.dockView updateNewFormViewWithTitleArray:@[Custing(@"确定", nil)]];
    __weak typeof(self) weakSelf = self;
    self.dockView.btnClickBlock = ^(NSInteger index) {
        if (index==0) {
            [weakSelf saveData];
        }
    };
}

//MARK:创建主视图
-(void)createMainView{
    _View_BranchCompany=[[UIView alloc]init];
    _View_BranchCompany.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_BranchCompany];
    [_View_BranchCompany mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
    }];
    
    
    _DepartmentView=[[UIView alloc]init];
    _DepartmentView.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_DepartmentView];
    [_DepartmentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_BranchCompany.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    
    _View_BDivision=[[UIView alloc]init];
    _View_BDivision.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_BDivision];
    [_View_BDivision mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.DepartmentView.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    
    _CostCenterView=[[UIView alloc]init];
    _CostCenterView.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_CostCenterView];
    [_CostCenterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_BDivision.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _ProjectView=[[UIView alloc]init];
    _ProjectView.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_ProjectView];
    [_ProjectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.CostCenterView.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    
    _View_Cate=[[UIView alloc]init];
    _View_Cate.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Cate];
    [_View_Cate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.ProjectView.mas_bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    
    _CategoryView=[[UIView alloc]init];
    _CategoryView.backgroundColor=Color_White_Same_20;
    [self.contentView addSubview:_CategoryView];
    [_CategoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Cate.bottom);
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
    
    
    _View_Reserved=[[UIView alloc]init];
    _View_Reserved.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Reserved];
    [_View_Reserved mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.CategoryView.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _acountView=[[UIView alloc]init];
    _acountView.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_acountView];
    [_acountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Reserved.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _RemarkView=[[UIView alloc]init];
    _RemarkView.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_RemarkView];
    [_RemarkView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.acountView.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
}
-(void)updateMainView{
    for (MyProcurementModel *model in _ShareFormArray) {
        [_isCtrlTypdic setValue:model.ctrlTyp forKey:model.fieldName];
        if ([model.fieldName isEqualToString:@"BranchId"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateBranchCompanyViewWithModel:model];
                 [_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"RequestorDeptId"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateDepartmentViewWithModel:model];
                 [_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"RequestorBusDeptId"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateBDivisionViewWithModel:model];
                 [_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"CostCenterId"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateCostCenterViewWithModel:model];
                [_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"ProjId"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateProjectViewWithModel:model];
                 [_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"ExpenseCode"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateCateViewWithModel:model];
                 [_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"Reserved1"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self updateReservedViewWithModel:model];
            }
        }else if ([model.fieldName isEqualToString:@"Amount"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateAmountViewWithModel:model];
                 [_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"Remark"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateRemarkViewWithModel:model];
                 [_UnShowmsArray removeObject:model.fieldName];
            }
        }
    }
    _isShowmsArray=[GPUtils filtOutSamefromData:_isShowmsArray toFiltData:_UnShowmsArray];
    
}

//MARK:更新公司视图
-(void)updateBranchCompanyViewWithModel:(MyProcurementModel *)model{
    if ([[NSString stringWithFormat:@"%@",model.isNotSelect]isEqualToString:@"0"]) {
        _txf_BranchCompany=[[UITextField alloc]init];
        SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_BranchCompany WithContent:_txf_BranchCompany WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":_model.Branch}];
        __weak typeof(self) weakSelf = self;
        [view setFormClickedBlock:^(MyProcurementModel *model){
            [weakSelf ChangeBranchCompany];
        }];
        [_View_BranchCompany addSubview:view];
    }else{
        _txf_BranchCompany=[[UITextField alloc]init];
        SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_BranchCompany WithContent:_txf_BranchCompany WithFormType:formViewShowText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":_model.Branch}];
        [_View_BranchCompany addSubview:view];
    }
}
//MARK:更新部门视图
-(void)updateDepartmentViewWithModel:(MyProcurementModel *)model{
//    if ([[NSString stringWithFormat:@"%@",model.isNotSelect]isEqualToString:@"0"]) {
    _txf_Department=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_DepartmentView WithContent:_txf_Department WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":_model.RequestorDept}];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model){
        [weakSelf ChangeDepartment];
    }];
    [_DepartmentView addSubview:view];
//    }else{
//        _txf_Department=[[UITextField alloc]init];
//        SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_DepartmentView WithContent:_txf_Department WithFormType:formViewShowText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":_model.RequestorDept}];
//        [_DepartmentView addSubview:view];
//    }
    
}
//MARK:更新业务部门视图
-(void)updateBDivisionViewWithModel:(MyProcurementModel *)model{
    if ([[NSString stringWithFormat:@"%@",model.isNotSelect]isEqualToString:@"0"]) {
        _txf_BDivision=[[UITextField alloc]init];
        SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_BDivision WithContent:_txf_BDivision WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":_model.RequestorBusDept}];
        __weak typeof(self) weakSelf = self;
        [view setFormClickedBlock:^(MyProcurementModel *model){
            [weakSelf ChangeBDivision];
        }];
        [_View_BDivision addSubview:view];
    }else{
        _txf_BDivision=[[UITextField alloc]init];
        SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_BDivision WithContent:_txf_BDivision WithFormType:formViewShowText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":_model.RequestorBusDept}];
        [_View_BDivision addSubview:view];
    }
    
}
//MARK:更新成本中心视图
-(void)updateCostCenterViewWithModel:(MyProcurementModel *)model{
    _txf_CostCenter=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_CostCenterView WithContent:_txf_CostCenter WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":_model.CostCenter}];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model){
        [weakSelf ChangeCostCenter];
    }];
    [_CostCenterView addSubview:view];
}
//MARK:更新项目视图
-(void)updateProjectViewWithModel:(MyProcurementModel *)model{
    _txf_Project=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_ProjectView WithContent:_txf_Project WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":_model.ProjName}];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model){
        [weakSelf ProjectClick];
    }];
    [_ProjectView addSubview:view];
}
//MARK:更新费用类别
-(void)updateCateViewWithModel:(MyProcurementModel *)model{
    _txf_Cate=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_Cate WithContent:_txf_Cate WithFormType:formViewSelectCate WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":[GPUtils getSelectResultWithArray:@[_model.ExpenseCat,_model.ExpenseType]]}];
    __weak typeof(self) weakSelf = self;
    [view setCateClickedBlock:^(MyProcurementModel *model,UIImageView *image){
        weakSelf.categoryImage=image;
        [weakSelf CateBtnClick:nil];
    }];
    [_View_Cate addSubview:view];
    
    if ([NSString isEqualToNull:[NSString stringWithFormat:@"%@",_model.ExpenseCode]]&&![[NSString stringWithFormat:@"%@",_model.ExpenseCode] isEqualToString:@"0"]) {
        [view setCateImg:_model.ExpenseIcon];
    }
}
//MARK:更新自定义字段
-(void)updateReservedViewWithModel:(MyProcurementModel *)model{
    __weak typeof(self) weakSelf = self;
//    [_View_Reserved addSubview:[[ReserverdMainView alloc]initArr:self.ShareFormArray isRequiredmsdic:self.isRequiredmsdic reservedDic:self.reservedDic UnShowmsArray:self.UnShowmsArray view:_View_Reserved model:self.model_ReserverModel block:^(NSInteger height) {
//        [weakSelf.View_Reserved updateConstraints:^(MASConstraintMaker *make) {
//            make.height.equalTo(height);
//        }];
//    }]];
    
    [_View_Reserved addSubview:[[ReserverdMainView alloc]initReimShareArr:self.ShareFormArray isRequiredmsdic:self.isRequiredmsdic reservedDic:self.reservedDic UnShowmsArray:self.UnShowmsArray view:_View_Reserved model:self.model_ReserverModel DataModel:_model block:^(NSInteger height) {
        [weakSelf.View_Reserved updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
    
}
//MARK:更新借款金额
-(void)updateAmountViewWithModel:(MyProcurementModel *)model{
    _txf_Acount=[[GkTextField alloc]init];
    model.fieldValue=_model.Amount;
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_acountView WithContent:_txf_Acount WithFormType:formViewEnterAmout WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    [view setAmountChangedBlock:^(NSString *amount){
        NSLog(@"%@",amount);
        weakSelf.txf_Acount.text = amount;
    }];
    [_acountView addSubview:view];
}

//MARK:更新备注视图
-(void)updateRemarkViewWithModel:(MyProcurementModel *)model{
    _txv_Remark=[[UITextView alloc]init];
    model.fieldValue=_model.Remark;
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_RemarkView WithContent:_txv_Remark WithFormType:formViewVoiceTextView WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    view.iflyRecognizerView=_iflyRecognizerView;
    [_RemarkView addSubview:view];
}

//MARK:更新滚动视图
-(void)updateContentView{
    [self.contentView makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.RemarkView.bottom).offset(10);
    }];
    [self.contentView layoutIfNeeded];
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

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CostCateNewModel *model=_categoryArr[indexPath.row];
    if (![model.expenseType isEqualToString:@""]) {
        _categoryImage.image =[UIImage imageNamed:[NSString isEqualToNull:model.expenseIcon]?model.expenseIcon:@"15"];
        _model.ExpenseType=[NSString isEqualToNull:model.expenseType]?model.expenseType:@"";
        _model.ExpenseCode=model.expenseCode;
        _model.ExpenseIcon=model.expenseIcon;
        _model.ExpenseCat=model.expenseCat;
        _model.ExpenseCatCode=model.expenseCatCode;
        _txf_Cate.text=[GPUtils getSelectResultWithArray:@[model.expenseCat,model.expenseType]];
        [self updateAgainCateGoryView];
    }else{
        [self updateAgainCateGoryView];
    }
    
}

//MARK:点击
-(void)ChangeBranchCompany{
    __weak typeof(self) weakSelf = self;
    [weakSelf keyClose];
    ChooseCateFreshController *vc=[[ChooseCateFreshController alloc]initWithType:@"BranchCompany"];
    vc.ChooseCategoryId=_model.BranchId;
    vc.ChooseFreshCateBackBlock = ^(NSMutableArray *array, NSString *type) {
        ChooseCateFreModel *model = array[0];
        weakSelf.model.BranchId=model.groupId;
        weakSelf.model.Branch=model.groupName;
        weakSelf.txf_BranchCompany.text=model.groupName;
    };
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)ChangeDepartment{
    [self keyClose];
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",getcosummary] Parameters:nil Delegate:self SerialNum:4 IfUserCache:NO];

}

-(void)ChangeBDivision{
    __weak typeof(self) weakSelf = self;
    [weakSelf keyClose];
    ChooseCateFreshController *vc=[[ChooseCateFreshController alloc]initWithType:@"BDivision"];
    vc.ChooseCategoryId=_model.RequestorBusDeptId;
    vc.ChooseFreshCateBackBlock = ^(NSMutableArray *array, NSString *type) {
        ChooseCateFreModel *model = array[0];
        weakSelf.model.RequestorBusDeptId=model.Id;
        weakSelf.model.RequestorBusDept=model.name;
        weakSelf.txf_BDivision.text=model.name;
    };
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)ChangeCostCenter{
    __weak typeof(self) weakSelf = self;
    [weakSelf keyClose];
    ChooseCateFreshController *vc=[[ChooseCateFreshController alloc]initWithType:@"costCenter"];
    vc.ChooseCategoryId=_model.CostCenterId;
    vc.ChooseFreshCateBackBlock = ^(NSMutableArray *array, NSString *type) {
        ChooseCateFreModel *model = array[0];
        weakSelf.model.CostCenterId=model.Id;
        weakSelf.model.CostCenter=model.costCenter;
        weakSelf.txf_CostCenter.text=model.costCenter;
    };
    [self.navigationController pushViewController:vc animated:YES];
    
    
}
-(void)ProjectClick{
    __weak typeof(self) weakSelf = self;
    [weakSelf keyClose];
    ChooseCateFreshController *vc=[[ChooseCateFreshController alloc]initWithType:@"projectName"];
    vc.ChooseCategoryId=_model.ProjId;
    vc.ChooseFreshCateBackBlock = ^(NSMutableArray *array, NSString *type) {
        ChooseCateFreModel *model = array[0];
        weakSelf.model.ProjId=model.Id;
        weakSelf.model.ProjName=[GPUtils getSelectResultWithArray:@[model.no,model.projName]];
        weakSelf.model.ProjMgrUserId=model.projMgrUserId;
        weakSelf.model.ProjMgr=model.projMgr;
        weakSelf.txf_Project.text= weakSelf.model.ProjName;
    };
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)CateBtnClick:(id)obj{
    [self keyClose];
    if (!_categoryArr) {
        [self chooseCostCategry];
    }else if (_categoryArr.count==0){
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"没相关费用类别", nil) duration:1.0];
        return;
    }else{
        [self dealWithCateView];
    }
}


//MARK:自定义字段选择器
-(void)gotoSlectController:(MyProcurementModel *)model textField:(UITextField *)textfield{
    [self keyClose];
    MasterListViewController *vc=[[MasterListViewController alloc]initWithType:@"MasterList"];
    vc.model=model;
    vc.aimTextField=textfield;
    [self.navigationController pushViewController:vc animated:YES];
}


//MARK:再次获取类别选择中的类别
-(void)chooseCostCategry{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    NSDictionary *parameters=@{@"Type":[NSString stringWithFormat:@"%ld",_comeplace]};
    NSString *url=[NSString stringWithFormat:@"%@",GetAddCostNewCategry];
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:10 IfUserCache:NO];
}

//MARK:请求成功
- (void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum {
    NSLog(@"resDic:%@",responceDic);
    [YXSpritesLoadingView dismiss];
    //临时解析用的数据
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responceDic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *stri = [[NSString alloc] initWithData:jsonData  encoding:NSUTF8StringEncoding];
    NSLog(@"string%@",stri);
    _resultDict=responceDic;
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
        case 4:
        {
            NSDictionary * result = [responceDic objectForKey:@"result"];
            self.userdatas.groupid = [result objectForKey:@"groupId"];
            self.userdatas.PeoplePage = self.navigationController.viewControllers.count;
            [self.userdatas storeUserInfo];
            ComPeopleViewController *cp = [[ComPeopleViewController alloc]init];
            cp.nowGroupname = self.userdatas.company;
            cp.nowGroup = [NSString isEqualToNull:self.userdatas.groupid]?self.userdatas.groupid:self.userdatas.companyId;
            [self.navigationController pushViewController:cp animated:YES];
        }
            break;
        case 10:
            [self dealWithType];
            [self dealWithCateView];
            break;
        default:
            break;
    }
    
}

//MARK:-请求失败
-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum{
    [YXSpritesLoadingView dismiss];
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];
}
//MARK:费用类型数据处理
-(void)dealWithType{
    _categoryArr=[NSMutableArray array];
    NSDictionary *parDict= [CostCateNewModel getCostCateByDict:_resultDict array:_categoryArr withType:1];
    _CateLevel=parDict[@"CateLevel"];
    _categoryRows=[parDict[@"categoryRows"]integerValue];
    
    if (_categoryArr.count==0){
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"没相关费用类别", nil) duration:1.0];
        return;
    }
}

-(void)dealWithCateView{
    if ([_CateLevel isEqualToString:@"1"]) {
        [self updateAgainCateGoryView];
    }else if ([_CateLevel isEqualToString:@"2"]){
        STPickerCategory *pickerArea = [[STPickerCategory alloc]init];
        pickerArea.DateSourceArray=[NSMutableArray arrayWithArray:_categoryArr];
        CostCateNewSubModel *model=[[CostCateNewSubModel alloc]init];
        model.expenseCode=_model.ExpenseCode;
        pickerArea.CateModel=model;
        [pickerArea UpdatePickUI];
        [pickerArea setContentMode:STPickerContentModeBottom];
        if (self.comeplace==1) {
            pickerArea.str_flowCode=@"F0002";
        }else if (self.comeplace==2){
            pickerArea.str_flowCode=@"F0003";
        }else if (self.comeplace==3){
            pickerArea.str_flowCode=@"F0010";
        }else if (self.comeplace==4){
            pickerArea.str_flowCode=@"F0009";
        }        
        __weak typeof(self) weakSelf = self;
        [pickerArea setChooseCateBlock:^(CostCateNewModel *firstModel, CostCateNewSubModel *secondModel) {
            if (![secondModel.expenseCode isEqualToString:weakSelf.model.ExpenseCode]) {
                weakSelf.categoryImage.image =[UIImage imageNamed:[NSString isEqualToNull:secondModel.expenseIcon]?secondModel.expenseIcon:@"15"];
                weakSelf.model.ExpenseType=[NSString isEqualToNull:secondModel.expenseType]?secondModel.expenseType:@"";
                weakSelf.model.ExpenseCode=secondModel.expenseCode;
                weakSelf.model.ExpenseIcon=secondModel.expenseIcon;
                weakSelf.model.ExpenseCat=secondModel.expenseCat;
                weakSelf.model.ExpenseCatCode=secondModel.expenseCatCode;
                weakSelf.txf_Cate.text=[GPUtils getSelectResultWithArray:@[secondModel.expenseCat,secondModel.expenseType]];
            }
        }];
        [pickerArea show];
    }else if([_CateLevel isEqualToString:@"3"]){
        ExpenseCodeListViewController *ex = [[ExpenseCodeListViewController alloc]init];
        ex.arr_DataList = _categoryArr;
        ex.str_CateLevel = _CateLevel;
        __weak typeof(self) weakSelf = self;
        ex.CellClick = ^(CostCateNewSubModel *model) {
            if (![model.expenseCode isEqualToString:weakSelf.model.ExpenseCode]) {
                weakSelf.categoryImage.image =[UIImage imageNamed:[NSString isEqualToNull:model.expenseIcon]?model.expenseIcon:@"15"];
                weakSelf.model.ExpenseType=[NSString isEqualToNull:model.expenseType]?model.expenseType:@"";
                weakSelf.model.ExpenseCode=model.expenseCode;
                weakSelf.model.ExpenseIcon=model.expenseIcon;
                weakSelf.model.ExpenseCat=model.expenseCat;
                weakSelf.model.ExpenseCatCode=model.expenseCatCode;
                weakSelf.txf_Cate.text=[GPUtils getSelectResultWithArray:@[model.expenseCat,model.expenseType]];
            }
        };
        [self.navigationController pushViewController:ex animated:YES];
    }
    
}


//MARK:更改费用类型选择选择框弹出
-(void)updateAgainCateGoryView{
    NSLog(@"%@",_CateLevel);
    if (_isOpenGener) {
        _isOpenGener=NO;
        [_CategoryView updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
        }];
        [_CategoryCollectView updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
        }];
    }else{
        if ([_CateLevel isEqualToString:@"1"]) {
            _isOpenGener=YES;
            if (_categoryRows==0) {
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
            [_CategoryCollectView reloadData];
        }
    }
}

-(void)saveData{
    [self inModelContent];
    if([self testModel:_model]){
        if (self.delegate&&[self.delegate respondsToSelector:@selector(ReimShareData:WithType:)]) {
            [self.delegate ReimShareData:_model WithType:_type];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void)inModelContent{
    _model.Remark=_txv_Remark.text?_txv_Remark.text:@"";
    _model.Amount=_txf_Acount.text?_txf_Acount.text:@"";
    _model.Reserved1=self.model_ReserverModel.Reserverd1;
    _model.Reserved2=self.model_ReserverModel.Reserverd2;
    _model.Reserved3=self.model_ReserverModel.Reserverd3;
    _model.Reserved4=self.model_ReserverModel.Reserverd4;
    _model.Reserved5=self.model_ReserverModel.Reserverd5;
}
//MARK:必填项验证
//空验证
-(BOOL)testModel:(ReimShareModel *)model{
    //    NSLog(@"1111%@",_isRequiredmsdic);
    BOOL isreturn = YES;
    NSMutableDictionary *modeldic = [ReimShareModel initDicByModel:model];
    //    NSLog(@"1111%@",_isRequiredmsdic);
    for (NSString *str in _isShowmsArray) {
        NSString *key = str;
        NSString *i = [NSString stringWithFormat:@"%@",[_isRequiredmsdic objectForKey:key]];
        if ([i isEqualToString:@"1"]) {
            NSString *str =[NSString stringWithFormat:@"%@",[modeldic objectForKey:key]];
            if (![NSString isEqualToNull:str]) {
                [self showerror:key];
                isreturn = NO;
                break ;
            }
        }
    }
    return isreturn;
}
//显示
-(void)showerror:(NSString*)info{
    NSString *showinfo = nil;
    if ([info isEqualToString:@"BranchId"]) {
        showinfo =Custing(@"请选择公司", nil) ;
    }
    if ([info isEqualToString:@"RequestorDeptId"]) {
        showinfo = Custing(@"请选择部门", nil);
    }
    if ([info isEqualToString:@"RequestorBusDeptId"]) {
        showinfo =Custing( @"请选择业务部门", nil);
    }
    
    if ([info isEqualToString:@"CostCenterId"]) {
        showinfo = Custing(@"请选择成本中心", nil);
    }
    if ([info isEqualToString:@"ProjId"]) {
        showinfo = Custing(@"请选择项目名称", nil);
    }
    if ([info isEqualToString:@"Remark"]) {
        showinfo = Custing(@"请输入备注", nil);
    }
    if ([info isEqualToString:@"ExpenseCode"]) {
        showinfo = Custing(@"请选择费用类别", nil);
    }
    if ([info isEqualToString:@"Amount"]) {
        showinfo = Custing(@"请输入金额", nil);
    }
    if ([info isEqualToString:@"Reserved1"]||[info isEqualToString:@"Reserved2"]||[info isEqualToString:@"Reserved3"]||[info isEqualToString:@"Reserved4"]||[info isEqualToString:@"Reserved5"]) {
        
        showinfo =[[_isCtrlTypdic objectForKey:info] isEqualToString:@"text"]?[NSString stringWithFormat:@"%@%@",Custing(@"请输入", nil),[_reservedDic objectForKey:info]]:[NSString stringWithFormat:@"%@%@",Custing(@"请选择", nil),[_reservedDic objectForKey:info]];
    }
    [[GPAlertView sharedAlertView] showAlertText:self WithText:showinfo];
}
//MARK:部门返回
- (void)editGroup:(NSNotification *)note
{
    _model.RequestorDept=[NSString isEqualToNull:note.userInfo[@"name"]]?[NSString stringWithFormat:@"%@",note.userInfo[@"name"]]:@"";
    _model.RequestorDeptId=[NSString isEqualToNull:note.userInfo[@"id"]]?[NSString stringWithFormat:@"%@",note.userInfo[@"id"]]:@"0";
    self.txf_Department.text=_model.RequestorDept;
}
//MARK:通知释放
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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

