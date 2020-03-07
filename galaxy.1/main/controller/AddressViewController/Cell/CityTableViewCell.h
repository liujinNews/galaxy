//
//  CityTableViewCell.h
//  galaxy
//
//  Created by 贺一鸣 on 2016/12/27.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CityTableViewCell : UITableViewCell<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, copy) NSArray *citys;
@property (nonatomic, copy) void(^selectCity)(NSDictionary *cityName);
@property (nonatomic, strong) UICollectionView *collectionView;
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier;
//+ (CGFloat)heightForCitys:(NSArray *)citys;

@property (nonatomic, strong) NSMutableArray *arr_select;

@end
