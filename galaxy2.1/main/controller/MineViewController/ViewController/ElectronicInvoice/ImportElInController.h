//
//  ImportElInController.h
//  galaxy
//
//  Created by hfk on 2017/1/12.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "VoiceBaseController.h"
#import "BottomView.h"
#import "CategoryCollectCell.h"
#import "STPickerCategory.h"
#import "ChooseCategoryModel.h"
@interface ImportElInController : VoiceBaseController<UIScrollViewDelegate,GPClientDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
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

/**
 *
 记一笔总类数组
 */
@property(nonatomic,strong)NSMutableArray *AddCostTotalCateArray;
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
/**
 *  费用类型Label
 */
@property (nonatomic,strong)UILabel * genreLab;
/**
 *  费用类别视图
 */
@property(nonatomic,strong)UIView *CateView;
/**
 *  费用类别image
 */
@property(nonatomic,strong)UIImageView * CateImage;
/**
 *  费用类别Label
 */
@property (nonatomic,strong)UILabel * CateLab;
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
 *   确认导入视图
 */
@property(nonatomic,strong)UIView *LoadView;

-(id)initWithType:(NSDictionary *)type;

@end
