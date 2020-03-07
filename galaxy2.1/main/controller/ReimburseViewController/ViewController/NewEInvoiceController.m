//
//  NewEInvoiceController.m
//  galaxy
//
//  Created by hfk on 2019/3/8.
//  Copyright © 2019 赵碚. All rights reserved.
//

#import "NewEInvoiceController.h"

static NSString *cellID = @"cell";

@interface NewEInvoiceController ()<UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,GPClientDelegate,UIScrollViewDelegate>
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
 *  网格视图
 */
@property(nonatomic,strong)UICollectionView *collView;
/**
 *  网格规则
 */
@property(nonatomic,strong)UICollectionViewFlowLayout *layOut;


@end

@implementation NewEInvoiceController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:Custing(@"发票详情", nil) backButton:YES];

    [self createViews];
}
//MARK:创建表格视图
-(void)createViews{
    
    UIScrollView *scrollView = UIScrollView.new;
    self.scrollView = scrollView;
    scrollView.backgroundColor = Color_White_Same_20;
    scrollView.showsVerticalScrollIndicator = YES;
    scrollView.showsHorizontalScrollIndicator = YES;
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(@-50);
    }];
    
    self.contentView = [[BottomView alloc]init];
    self.contentView.userInteractionEnabled = YES;
    self.contentView.backgroundColor = Color_White_Same_20;
    [self.scrollView addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];
    self.dockView = [[DoneBtnView alloc]initWithFrame:CGRectMake(0, Main_Screen_Height - NavigationbarHeight - 50, Main_Screen_Width, 50)];
    self.dockView.userInteractionEnabled = YES;
    [self.view addSubview:self.dockView];
    [self.dockView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.equalTo(@50);
    }];
   
    
    _layOut = [[UICollectionViewFlowLayout alloc]init];
    _layOut.minimumInteritemSpacing = 0;
    _layOut.minimumLineSpacing = 0;
    _layOut.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    _collView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:_layOut];
    _collView.delegate = self;
    _collView.dataSource = self;
    _collView.pagingEnabled = YES;
    [self.collView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cellID];
    [self.contentView addSubview:_collView];

    [_collView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
        make.height.equalTo(1500);
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.collView);
    }];

    [self.dockView updateNewFormViewWithTitleArray:@[Custing(@"保存", nil)]];
    __weak typeof(self) weakSelf = self;
    self.dockView.btnClickBlock = ^(NSInteger index) {
        
    };
}
//MARK: UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(Main_Screen_Width, Main_Screen_Height*2);
}

//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
//    return 10;
//}
//MARK: CollectionView Delegate & DataSource
//- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
//    return 1;
//}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 5;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell =  [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    if (!cell ) {
        NSLog(@"cell为空,创建cell");
        cell = [[UICollectionViewCell alloc] init];
    }
    cell.backgroundColor = [GPUtils randomColor];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
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
