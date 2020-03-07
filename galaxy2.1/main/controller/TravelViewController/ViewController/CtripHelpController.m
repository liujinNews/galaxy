//
//  CtripHelpController.m
//  galaxy
//
//  Created by hfk on 2017/5/15.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "CtripHelpController.h"
#import "CtripSettingController.h"
#import "CtripHelpCell.h"
static NSString *const CellIdentifier = @"CtripHelpCell";
@interface CtripHelpController ()<UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate>

@property (nonatomic,strong)UIScrollView * scrollView;

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
@property(nonatomic,strong)CtripHelpCell *cell;

@end

@implementation CtripHelpController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:Custing(@"帮助", nil) backButton:YES];
    self.view.backgroundColor=Color_White_Same_20;
    [self createMainView];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
      
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
     
}
-(void)createMainView{
    
    UIScrollView *scrollView = UIScrollView.new;
    self.scrollView = scrollView;
    scrollView.backgroundColor =Color_White_Same_20;
    scrollView.showsVerticalScrollIndicator=NO;
    scrollView.delegate=self;
    [self.view addSubview:scrollView];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.view);
    }];
    
    BottomView *contentView =[[BottomView alloc]init];
    contentView.userInteractionEnabled=YES;
    contentView.backgroundColor=Color_White_Same_20;
    [scrollView addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];

    
    UIImageView *ImgView=[GPUtils createImageViewFrame:CGRectMake(0, 0.5, 4, 26) imageName:@"Work_HeadBlue"];
    ImgView.backgroundColor=Color_Blue_Important_20;
    [contentView addSubview:ImgView];
    UILabel *titleLabel=[GPUtils createLable:CGRectMake(0, 0,Main_Screen_Width-30, 26) text:Custing(@"全面差旅管理", nil) font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    titleLabel.center=CGPointMake(X(ImgView)+WIDTH(ImgView)+Main_Screen_Width/2-4, 13.5);
    [contentView addSubview:titleLabel];
    
    if (!_layOut) {
        _layOut = [[UICollectionViewFlowLayout alloc] init];
    }
    _layOut.minimumInteritemSpacing =0;
    _layOut.minimumLineSpacing =0;
    
    if (!_collView) {
        _collView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 26, Main_Screen_Width, Main_Screen_Width*0.681+30) collectionViewLayout:_layOut];
    }
    _collView.delegate = self;
    _collView.scrollEnabled=NO;
    _collView.dataSource = self;
    _collView.alwaysBounceVertical=YES;
    _collView.showsVerticalScrollIndicator = NO;
    _collView.backgroundColor =Color_White_Same_20;
    [_collView registerClass:[CtripHelpCell class] forCellWithReuseIdentifier:CellIdentifier];
    [contentView addSubview:_collView];
    
    
    
    UIView *LabbackView=[[UIView alloc]initWithFrame:CGRectMake(0, 26+HEIGHT(_collView), Main_Screen_Width,20)];
    LabbackView.backgroundColor=Color_form_TextFieldBackgroundColor;
    [contentView addSubview:LabbackView];
    
    
    NSString *txet1=Custing(@"打通出差申请与预订管控、报销管控所有环节,费用支出更加合规、透明。", nil);
    NSString *txet2=Custing(@"提供预存、月结服务。", nil);
    NSString *txet3=Custing(@"提供统一的发票、行程单,方便对账,降低人工审核发票的风险。", nil);
    
    
    UIImageView *image1=[[UIImageView alloc]initWithFrame:CGRectMake(15, 18, 20, 20)];
    image1.image=[UIImage imageNamed:@"Travel_Help_One"];
    [LabbackView addSubview:image1];
    CGSize size1=[self getSizeWithString:txet1];
    UILabel *lab1=[GPUtils createLable:CGRectMake(50, Y(image1)-3, Main_Screen_Width-65, size1.height) text:txet1 font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    lab1.numberOfLines=0;
    [LabbackView addSubview:lab1];
    
    
    UIImageView *image2=[[UIImageView alloc]initWithFrame:CGRectMake(15, Y(lab1)+HEIGHT(lab1)+15, 20, 20)];
    image2.image=[UIImage imageNamed:@"Travel_Help_Two"];
    [LabbackView addSubview:image2];
    CGSize size2=[self getSizeWithString:txet2];
    UILabel *lab2=[GPUtils createLable:CGRectMake(50, Y(image2)-3, Main_Screen_Width-65, size2.height) text:txet2 font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    lab2.numberOfLines=0;
    [LabbackView addSubview:lab2];
    
    
    UIImageView *image3=[[UIImageView alloc]initWithFrame:CGRectMake(15, Y(lab2)+HEIGHT(lab2)+15, 20, 20)];
    image3.image=[UIImage imageNamed:@"Travel_Help_Three"];
    [LabbackView addSubview:image3];
    
    CGSize size3=[self getSizeWithString:txet3];
    UILabel *lab3=[GPUtils createLable:CGRectMake(50, Y(image3)-3, Main_Screen_Width-65, size3.height) text:txet3 font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    lab3.numberOfLines=0;
    [LabbackView addSubview:lab3];
    
    CGRect frame=LabbackView.frame;
    frame.size.height=size1.height+size2.height+size3.height+55;
    LabbackView.frame=frame;
    
    
    UIButton *btn=[GPUtils createButton:CGRectMake(15, Y(LabbackView)+HEIGHT(LabbackView)+20, Main_Screen_Width-30, 48)  action:@selector(BtnClick:) delegate:self title:Custing(@"开启差旅设置", nil) font:Font_Important_15_20 titleColor:Color_form_TextFieldBackgroundColor];
    [btn.layer setMasksToBounds:YES];
    [btn.layer setCornerRadius:10.0];
    btn.backgroundColor=Color_Blue_Important_20;
    [contentView addSubview:btn];
    
    [contentView updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(btn.bottom).offset(@20);
    }];
    
    
}
-(CGSize )getSizeWithString:(NSString *)str{
    
    return [str sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(Main_Screen_Width-65, 10000) lineBreakMode:NSLineBreakByCharWrapping];
}
-(void)BtnClick:(UIButton *)btn{
    CtripSettingController *vc=[[CtripSettingController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(Main_Screen_Width, Main_Screen_Width*0.681+20);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

#pragma mark - CollectionView Delegate & DataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    _cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    [_cell configItemWithrRow:indexPath.row];
    return _cell;
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
