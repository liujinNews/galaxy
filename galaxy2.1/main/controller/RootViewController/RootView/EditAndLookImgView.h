//
//  EditAndLookImgView.h
//  galaxy
//
//  Created by hfk on 2017/7/14.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProcureCollectCell.h"
#import "PDFLookViewController.h"
#import "HClActionSheet.h"
#import "MyProcurementModel.h"
@interface EditAndLookImgView : UIView<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,ZLPhotoPickerBrowserViewControllerDataSource,ZLPhotoPickerBrowserViewControllerDelegate,UIAlertViewDelegate>
//1填写 2查看 3审批修改查看
@property (nonatomic, assign) NSInteger EditStatus;
@property (nonatomic, strong) NSMutableArray * totalArray;
@property (nonatomic, strong) NSMutableArray * imageArray;
@property (nonatomic, assign) NSInteger  maxCount;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *view_Head;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UICollectionView *imgCollectView;
@property(nonatomic,strong)UICollectionViewFlowLayout *layOut;
@property(nonatomic,strong)ProcureCollectCell *Imagecell;
@property(nonatomic,strong)NSMutableArray *showImageArray;
@property(nonatomic,strong)UIView *gapView;
//1编辑2查看3审批修改
- (instancetype)initWithFrame:(CGRect)frame withEditStatus:(NSInteger)EditStatus;
- (instancetype)initWithBaseView:(UIView *)bgView withEditStatus:(NSInteger)EditStatus withModel:(MyProcurementModel *)model;

//更新视图
- (void)updateWithTotalArray:(NSMutableArray *)arr  WithImgArray:(NSMutableArray *)imgArr;



//@property (nonatomic, copy) void (^deleteBlock)(NSInteger tag);
//@property (nonatomic, copy) void (^AddBlock)();
//@property (nonatomic, copy) void (^showBlock)(NSInteger tag);

@end
