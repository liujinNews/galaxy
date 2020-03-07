//
//  ProductEditController.m
//  galaxy
//
//  Created by hfk on 2018/6/28.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "ProductEditController.h"

@interface ProductEditController ()<UIScrollViewDelegate,GPClientDelegate>
/**
 *  滚动视图
 */
@property (nonatomic,strong)UIScrollView * scrollView;
/**
 *  滚动视图contentView
 */
@property (nonatomic,strong)BottomView *contentView;

@property (nonatomic,strong)DoneBtnView * dockView;

@property (nonatomic, copy) NSString *str_Id;

@property (nonatomic, strong) UITextField *txf_code;//编码
@property (nonatomic, strong) UITextField *txf_nameCh;//产品
@property (nonatomic, strong) UITextField *txf_nameEn;
@property (nonatomic, strong) UITextField *txf_cat;//分类
@property (nonatomic, copy) NSString *str_catId;
@property (nonatomic, strong) UITextField *txf_brandCh;//品牌
@property (nonatomic, strong) UITextField *txf_brandEn;
@property (nonatomic, strong) UITextField *txf_size;//规格
@property (nonatomic, strong) UITextField *txf_unit;//单位

@end

@implementation ProductEditController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=Color_White_Same_20;
    [self createMainView];
    self.str_Id = @"";
    if (self.dict_Edit) {
        [self setTitle:Custing(@"编辑产品", nil) backButton:YES];
        [self checkInDate];
    }else{
        [self setTitle:Custing(@"新增产品", nil) backButton:YES];
    }
}

-(void)createMainView{
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
    
    [self.dockView updateNewFormViewWithTitleArray:@[Custing(@"保存", nil)]];
    __weak typeof(self) weakSelf = self;
    self.dockView.btnClickBlock = ^(NSInteger index) {
        [weakSelf saveInfo];
    };
    
    UIView * ViewCode=[[UIView alloc]init];
    ViewCode.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:ViewCode];
    [ViewCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
    }];
    _txf_code=[[UITextField alloc]init];
    [ViewCode addSubview:[[SubmitFormView alloc]initBaseView:ViewCode WithContent:_txf_code WithFormType:formViewEnterText WithSegmentType:lineViewNoneLine WithString:Custing(@"编号", nil) WithInfodict:nil WithTips:Custing(@"请输入编号", nil) WithNumLimit:200]];

    
    UIView *ViewNameCh=[[UIView alloc]init];
    ViewNameCh.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:ViewNameCh];
    [ViewNameCh mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ViewCode.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    _txf_nameCh=[[UITextField alloc]init];
    [ViewNameCh addSubview:[[SubmitFormView alloc]initBaseView:ViewNameCh WithContent:_txf_nameCh WithFormType:formViewEnterText WithSegmentType:lineViewNoneLine WithString:Custing(@"产品", nil) WithInfodict:nil WithTips:Custing(@"请输入产品", nil) WithNumLimit:200]];
    
    
    UIView *ViewNameEn=[[UIView alloc]init];
    ViewNameEn.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:ViewNameEn];
    [ViewNameEn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ViewNameCh.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    _txf_nameEn=[[UITextField alloc]init];
    [ViewNameEn addSubview:[[SubmitFormView alloc]initBaseView:ViewNameEn WithContent:_txf_nameEn WithFormType:formViewEnterText WithSegmentType:lineViewNoneLine WithString:Custing(@"英文名称", nil) WithInfodict:nil WithTips:Custing(@"请输入英文名称", nil) WithNumLimit:200]];
    
    
    UIView *ViewCate=[[UIView alloc]init];
    ViewCate.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:ViewCate];
    [ViewCate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ViewNameEn.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    _txf_cat=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:ViewCate WithContent:_txf_cat WithFormType:formViewSelect WithSegmentType:lineViewNoneLine WithString:Custing(@"产品类型", nil) WithInfodict:nil WithTips:Custing(@"请选择产品类型", nil) WithNumLimit:200];
    [view setFormClickedBlock:^(MyProcurementModel *model) {
        [weakSelf CatClick];
    }];
    [ViewCate addSubview:view];
    
    
    UIView *ViewBrandCh=[[UIView alloc]init];
    ViewBrandCh.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:ViewBrandCh];
    [ViewBrandCh mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ViewCate.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    _txf_brandCh=[[UITextField alloc]init];
    [ViewBrandCh addSubview:[[SubmitFormView alloc]initBaseView:ViewBrandCh WithContent:_txf_brandCh WithFormType:formViewEnterText WithSegmentType:lineViewNoneLine WithString:Custing(@"品牌", nil) WithInfodict:nil WithTips:Custing(@"请输入品牌", nil) WithNumLimit:200]];

    
    UIView *ViewBrandEn=[[UIView alloc]init];
    ViewBrandEn.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:ViewBrandEn];
    [ViewBrandEn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ViewBrandCh.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    _txf_brandEn=[[UITextField alloc]init];
    [ViewBrandEn addSubview:[[SubmitFormView alloc]initBaseView:ViewBrandEn WithContent:_txf_brandEn WithFormType:formViewEnterText WithSegmentType:lineViewNoneLine WithString:Custing(@"品牌英文名称", nil) WithInfodict:nil WithTips:Custing(@"请输入品牌英文名称", nil) WithNumLimit:200]];

    
    UIView *ViewSize=[[UIView alloc]init];
    ViewSize.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:ViewSize];
    [ViewSize mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ViewBrandEn.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    _txf_size=[[UITextField alloc]init];
    [ViewSize addSubview:[[SubmitFormView alloc]initBaseView:ViewSize WithContent:_txf_size WithFormType:formViewEnterText WithSegmentType:lineViewNoneLine WithString:Custing(@"规格", nil) WithInfodict:nil WithTips:Custing(@"请输入规格", nil) WithNumLimit:200]];

    UIView *ViewUnit=[[UIView alloc]init];
    ViewUnit.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:ViewUnit];
    [ViewUnit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ViewSize.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    _txf_unit=[[UITextField alloc]init];
    [ViewUnit addSubview:[[SubmitFormView alloc]initBaseView:ViewUnit WithContent:_txf_unit WithFormType:formViewEnterText WithSegmentType:lineViewNoneLine WithString:Custing(@"单位", nil) WithInfodict:nil WithTips:Custing(@"请输入单位", nil) WithNumLimit:200]];

    [self.contentView updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(ViewUnit.bottom);
    }];
}

-(void)checkInDate{
    _txf_code.text = [NSString stringWithIdOnNO:self.dict_Edit[@"code"]];
    _txf_nameCh.text = [NSString stringWithIdOnNO:self.dict_Edit[@"nameCh"]];
    _txf_nameEn.text = [NSString stringWithIdOnNO:self.dict_Edit[@"nameEn"]];
    _txf_cat.text = [NSString stringWithIdOnNO:self.dict_Edit[@"cat"]];
    self.str_catId = [NSString stringWithIdOnNO:self.dict_Edit[@"catId"]];
    _txf_brandCh.text = [NSString stringWithIdOnNO:self.dict_Edit[@"brandCh"]];
    _txf_brandEn.text = [NSString stringWithIdOnNO:self.dict_Edit[@"brandEn"]];
    _txf_size.text = [NSString stringWithIdOnNO:self.dict_Edit[@"size"]];
    _txf_unit.text = [NSString stringWithIdOnNO:self.dict_Edit[@"unit"]];
    self.str_Id = [NSString stringWithIdOnNO:self.dict_Edit[@"id"]];
}

- (void)CatClick{
    ChooseCategoryController *vc=[[ChooseCategoryController alloc]initWithType:@"ProductCat"];
    vc.ChooseCategoryId=self.str_catId;
    __weak typeof(self) weakSelf = self;
    vc.ChooseNormalCateBackBlock = ^(NSMutableArray *array, NSString *type) {
        ChooseCategoryModel *model = array[0];
        weakSelf.txf_cat.text =model.name;
        weakSelf.str_catId =model.Id;
    };
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)saveInfo{
    [self keyClose];
    if (self.txf_code.text.length <= 0) {
        [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"请输入编号", nil)];
        return;
    }
    if (self.txf_nameCh .text.length <= 0) {
        [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"请输入产品", nil)];
        return;
    }
    if (![NSString isEqualToNullAndZero:self.str_catId]) {
        [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"请选择产品类型", nil)];
        return;
    }
    [self requestSave];
}
-(void)requestSave{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    NSDictionary * dic =@{@"Id":self.str_Id,@"Code":self.txf_code.text,@"NameCh":self.txf_nameCh.text,@"NameEn":[NSString stringWithIdOnNO:self.txf_nameEn.text],@"CatId":self.str_catId,@"BrandCh":[NSString stringWithIdOnNO:self.txf_brandCh.text],@"BrandEn":[NSString stringWithIdOnNO:self.txf_brandEn.text],@"Size":[NSString stringWithIdOnNO:self.txf_size.text],@"Unit":[NSString stringWithIdOnNO:self.txf_unit.text]};
    [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",SAVEPURCHASE] Parameters:dic Delegate:self SerialNum:0 IfUserCache:NO];
}

- (void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum {
    NSLog(@"resDic:%@",responceDic);
    [YXSpritesLoadingView dismiss];
    NSString * success = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"success"]];
    if ([success isEqualToString:@"0"]){
        NSString * error = [responceDic objectForKey:@"msg"];
        if (![error isKindOfClass:[NSNull class]]) {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:1.0];
        }
        return;
    }
    switch (serialNum) {
        case 0:
        {
            if ([NSString isEqualToNull:responceDic[@"result"]]) {
                if ([[NSString stringWithFormat:@"%@",responceDic[@"result"]]isEqualToString:@"-1"]) {
                    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"已存在", nil) duration:2.0];
                    return;
                }
                [[GPAlertView sharedAlertView]showAlertText:self WithText:self.dict_Edit ? Custing(@"编辑成功", nil):Custing(@"新增成功", nil) duration:2.0];
                [self performBlock:^{
                    [self.navigationController popViewControllerAnimated:YES];
                } afterDelay:1];
            }
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
