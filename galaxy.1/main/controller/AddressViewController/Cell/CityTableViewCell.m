//
//  CityTableViewCell.m
//  galaxy
//
//  Created by 贺一鸣 on 2016/12/27.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "CityTableViewCell.h"
#import "CityCollectionViewCell.h"

@implementation CityTableViewCell

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = Color_form_TextFieldBackgroundColor;
        [self initialize];
    }
    return self;
}

- (void)initialize {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = 10;
    layout.sectionInset = UIEdgeInsetsMake(0, 16, 10, 16);
    int secr = [[UIScreen mainScreen] bounds].size.width>700?30:15;
    CGFloat itemW = ([[UIScreen mainScreen] bounds].size.width - secr - (16 * 3) - (10 * 2)) / 3;
    layout.itemSize = CGSizeMake((int)itemW, 30);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.scrollEnabled = NO;
    [_collectionView registerClass:[CityCollectionViewCell class] forCellWithReuseIdentifier:@"CityCollectionViewCell"];
                                       
    self.contentView.backgroundColor = Color_form_TextFieldBackgroundColor;
    [self.contentView addSubview:_collectionView];
    
    _arr_select = [NSMutableArray array];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _collectionView.frame = CGRectMake(X(self.contentView), 5, WIDTH(self.contentView), HEIGHT(self.contentView));
}

- (void)setCitys:(NSArray *)citys {
    if (_citys == citys) return;
    _citys = citys;
    [_collectionView reloadData];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.citys.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CityCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CityCollectionViewCell" forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithIdOnNO:self.citys[indexPath.row][@"cityName"]];
    cell.textLabel.numberOfLines = 0;
    if ([self.citys[indexPath.row][@"isClick"] isEqualToString:@"1"]) {
        cell.textLabel.layer.cornerRadius = 5.f;
        cell.textLabel.layer.borderWidth = .5;
        cell.textLabel.layer.borderColor = Color_Blue_Important_20.CGColor;
        cell.textLabel.layer.masksToBounds = YES;
        cell.textLabel.backgroundColor = Color_form_TextFieldBackgroundColor;
    }else{
        cell.textLabel.layer.cornerRadius = 5.f;
        cell.textLabel.layer.borderWidth = 1;
        cell.textLabel.layer.borderColor = Color_White_Same_20.CGColor;
        cell.textLabel.layer.masksToBounds = YES;
        cell.textLabel.backgroundColor = Color_White_Same_20;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:self.citys[indexPath.row]];
    if ([dic[@"isClick"] isEqualToString:@"1"]) {
        [dic setObject:@"0" forKey:@"isClick"];
    }else{
        [dic setObject:@"1" forKey:@"isClick"];
    }
    
    NSMutableArray *arr = [NSMutableArray arrayWithArray:self.citys];
    arr[indexPath.row] = dic;
    self.citys = arr;
    if (self.selectCity) {
        _selectCity(dic);
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
