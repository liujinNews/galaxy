//
//  BusiImportViewController.h
//  galaxy
//
//  Created by APPLE on 2019/12/16.
//  Copyright © 2019 赵碚. All rights reserved.
//

#import "VoiceBaseController.h"
#import "BottomView.h"
#import "CategoryCollectCell.h"
#import "STPickerCategory.h"
#import "ChooseCategoryModel.h"
#import "ExpenseCodeListViewController.h"
#import "RouteDidiModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BusiImportViewController : VoiceBaseController<UIScrollViewDelegate,GPClientDelegate,UICollectionViewDelegate,UICollectionViewDataSource>

/**
 *  请求结果字典
 */
@property (nonatomic,strong)NSDictionary *resultDict;

/**
 *  费用类型(1:差旅费/2:日常费3:专项费)
 */
//@property (nonatomic,strong)NSString * generStr;
/**
 *  记一笔费用类别是否分级(1/2)
 */
@property(nonatomic,strong)NSString *CateLevel;
/**
 *  费用类型是否打开的
 */
@property(nonatomic,assign)BOOL isOpenGener;
/**
 *  费用类别
 */
@property(nonatomic,strong)NSMutableArray * categoryArr;
@property(nonatomic,assign)NSInteger categoryRows;

/**
 *  类别字符串
 */
@property(nonatomic,strong)NSString *categoryString;
/**
 *  费用类别编码
 */
@property(nonatomic,strong)NSString *expenseCode;
/**
 *  费用类别图片编码
 */
@property(nonatomic,strong)NSString *expenseIcon;
/**
 费用类别大类
 */
@property(nonatomic,strong)NSString *expenseCat;;
@property(nonatomic,strong)NSString *expenseCatCode;
@property(nonatomic,strong)NSString *expenseTag;

/**
 *  滚动视图
 */
@property (nonatomic,strong)UIScrollView * scrollView;
/**
 *  滚动视图contentView
 */
@property (nonatomic,strong)BottomView *contentView;
/**
 *  费用类型视图
 */
@property(nonatomic,strong)UIView *GenreView;
@property (nonatomic,strong)UITextField *txf_genre;
/**
 *  费用类别视图
 */
@property(nonatomic,strong)UIView *CateView;
/**
 *  费用类别
 */
@property (nonatomic,strong)UITextField * txf_Cate;
/**
 *  费用类别图片
 */
@property(nonatomic,strong)UIImageView * categoryImage;
/**
 *  费用类别选择视图
 */
@property(nonatomic,strong)UIView *CategoryView;
/**
 *  费用类别collectView
 */
@property(nonatomic,strong)UICollectionView *CategoryCollectView;
@property(nonatomic,strong)UICollectionViewFlowLayout *CategoryLayOut;
@property(nonatomic,strong)CategoryCollectCell *cell;
/**
 *  费用类别描述视图
 */
@property(nonatomic,strong)UIView *View_CateDes;
/**
 *  费用类别描述输入框
 */
@property(nonatomic,strong)UITextView *txv_CateDes;
/**
 *   确认导入视图
 */
@property(nonatomic,strong)UIView *LoadView;



@property (nonatomic, strong) NSMutableArray *chooseArray;
@property (nonatomic, strong) RouteDidiModel *importModel;
@property (nonatomic, strong) NSDictionary *dic;
@property (nonatomic, assign) BOOL isMultiple;
@property (nonatomic, strong) NSMutableArray *resultArray;

@end

NS_ASSUME_NONNULL_END
