//
//  MeetingDuringView.m
//  galaxy
//
//  Created by hfk on 2017/12/21.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "MeetingDuringView.h"
#import "MeetingDuringCCell.h"
#import "MeetingDuringHeadView.h"
#import "MeetingRoomModel.h"
static NSString *const MeetingCCell = @"MeetingDuringCCell";
static NSString *const HeadViewIdentifier = @"MeetingDuringHeadView";

@interface MeetingDuringView ()<UICollectionViewDelegate,UICollectionViewDataSource>
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
@property(nonatomic,strong)MeetingDuringCCell *cell;
@end

@implementation MeetingDuringView
-(NSMutableArray *)dataArray{
    if (_dataArray==nil) {
        _dataArray=[NSMutableArray array];
    }
    return _dataArray;
}
- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        [self createCollectionView];
    }
    return self;
}

-(void)createCollectionView{
    
    self.layOut = [[UICollectionViewFlowLayout alloc] init];
    self.layOut.minimumInteritemSpacing =0;
    self.layOut.minimumLineSpacing =0;
    self.collectionViewLayout=self.layOut;

    self.dataSource = self;
    self.delegate = self;
    self.alwaysBounceVertical=YES;
    self.showsVerticalScrollIndicator = NO;
    [self registerClass:[MeetingDuringCCell class] forCellWithReuseIdentifier:MeetingCCell];
    [self registerClass:[MeetingDuringHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HeadViewIdentifier];
    
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGSize size=CGSizeZero;
    if (self.dataArray.count>0) {
        size=CGSizeMake(Main_Screen_Width/3, 26);
    }
    return size;
}
#pragma mark 设置头部视图的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    CGSize size=CGSizeZero;
    if (self.dataArray.count>0) {
        size=CGSizeMake(Main_Screen_Width, 30);
    }
    return size;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if([kind isEqual:UICollectionElementKindSectionHeader])
    {
        MeetingDuringHeadView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HeadViewIdentifier forIndexPath:indexPath];
        if (self.dataArray>0) {
            [headView configHeadViewWithType:self.type];
        }
        return  headView;
    }else{
        return [[UICollectionReusableView alloc]init];
    }
}


#pragma mark - CollectionView Delegate & DataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    if (self.dataArray.count>0) {
        return 1;
    }else{
        return 0;
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.dataArray.count>0) {
        return self.dataArray.count;
    }else{
        return 0;
    }
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    _cell = [collectionView dequeueReusableCellWithReuseIdentifier: MeetingCCell forIndexPath:indexPath];
    if (self.dataArray.count>0) {
        MeetingRoomSubModel *mode=self.dataArray[indexPath.row];
        [_cell configCcellWithModel:mode];
    }
    return _cell;
}

-(void)configMeetingDuringViewData:(NSMutableArray *)dataArray WithType:(NSInteger)type{
    self.type=type;
    self.dataArray=dataArray;
    if (self.type==1) {
        self.backgroundColor=Color_WhiteWeak_Same_20;
    }else{
        self.backgroundColor=Color_eaeaea_20;
    }
    [self reloadData];
}

- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    //当事件是传递给此View内部的子View时，让子View自己捕获事件，如果是传递给此View自己时，放弃事件捕获
    UIView* __tmpView = [super hitTest:point withEvent:event];
    if (__tmpView == self) {
        return nil;
    }
    return [super hitTest:point withEvent:event];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
