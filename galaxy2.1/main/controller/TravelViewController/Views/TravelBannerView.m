//
//  TravelBannerView.m
//  galaxy
//
//  Created by hfk on 2017/5/12.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "TravelBannerView.h"
#import "SMPageControl.h"
#import "AutoSlideScrollView.h"
#import "YLImageView.h"

@interface TravelBannerView ()
@property (assign, nonatomic) CGFloat padding_top, padding_bottom, image_width, ratio;
@property (strong, nonatomic) SMPageControl *myPageControl;
@property (strong, nonatomic) AutoSlideScrollView *mySlideView;
@property (strong, nonatomic) NSMutableArray *imageViewList;

@end
@implementation TravelBannerView
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _padding_top = 0;
        _padding_bottom = 0;
        _image_width = Main_Screen_Width;
        _ratio = 0.4;
        CGFloat viewHeight = _padding_top + _padding_bottom + _image_width * _ratio;
        CGRect frame = self.frame;
        frame.size = CGSizeMake(Main_Screen_Width, viewHeight);
        self.frame = frame;
    }
    return self;
}
- (void)setCurBannerList:(NSArray *)curBannerList{
    if ([[_curBannerList valueForKey:@"name"] isEqualToArray:[curBannerList valueForKey:@"name"]]) {
        return;
    }
    _curBannerList = curBannerList;
    if (!_mySlideView) {
        _mySlideView = ({
            __weak typeof(self) weakSelf = self;
            AutoSlideScrollView *slideView = [[AutoSlideScrollView alloc] initWithFrame:CGRectMake(0, _padding_top, _image_width, _image_width * _ratio) animationDuration:3.0];
            slideView.layer.masksToBounds = YES;
            slideView.scrollView.scrollsToTop = NO;
            
            slideView.totalPagesCount = ^NSInteger(){
                return weakSelf.curBannerList.count;
            };
            slideView.fetchContentViewAtIndex = ^UIView *(NSInteger pageIndex){
                if (weakSelf.curBannerList.count > pageIndex) {
                    YLImageView *imageView = [weakSelf p_reuseViewForIndex:pageIndex];
                    NSDictionary *curBanner = weakSelf.curBannerList[pageIndex];
                    imageView.image=[UIImage imageNamed:curBanner[@"name"]];
                    return imageView;
                }else{
                    return [UIView new];
                }
            };
            slideView.currentPageIndexChangeBlock = ^(NSInteger currentPageIndex){
                if (weakSelf.curBannerList.count > currentPageIndex) {
                }else{
                }
                
                weakSelf.myPageControl.currentPage = currentPageIndex;
            };
            slideView.tapActionBlock = ^(NSInteger pageIndex){
                if (weakSelf.tapActionBlock && weakSelf.curBannerList.count > pageIndex) {
                    weakSelf.tapActionBlock(pageIndex, weakSelf.curBannerList[pageIndex]);
                }
            };
            slideView;
        });
        [self addSubview:_mySlideView];
    }
    if (!_myPageControl) {
        _myPageControl = ({
            SMPageControl *pageControl = [[SMPageControl alloc] initWithFrame:CGRectMake(Main_Screen_Width/2-30, _mySlideView.frame.origin.y + _mySlideView.frame.size.height-20, 60, 10)];
            pageControl.userInteractionEnabled = NO;
            pageControl.backgroundColor = [UIColor clearColor];
            pageControl.pageIndicatorImage = [UIImage imageNamed:@"banner__page_unselected"];
            pageControl.currentPageIndicatorImage = [UIImage imageNamed:@"banner__page_selected"];
            pageControl.numberOfPages = _curBannerList.count;
            pageControl.currentPage = 0;
            pageControl.alignment = SMPageControlAlignmentRight;
            pageControl;
        });
        [self addSubview:_myPageControl];
    }
    [self reloadData];
}

- (YLImageView *)p_reuseViewForIndex:(NSInteger)pageIndex{
    if (!_imageViewList) {
        _imageViewList = [[NSMutableArray alloc] initWithCapacity:3];
        for (int i = 0; i < 3; i++) {
            YLImageView *view = [[YLImageView alloc] initWithFrame:CGRectMake(0, _padding_top, _image_width, _image_width * _ratio)];
            view.clipsToBounds = YES;
            view.contentMode = UIViewContentModeScaleAspectFill;
            [_imageViewList addObject:view];
        }
    }
    YLImageView *imageView;
    NSInteger currentPageIndex = self.mySlideView.currentPageIndex;
    if (pageIndex == currentPageIndex) {
        imageView = _imageViewList[1];
    }else if (pageIndex == currentPageIndex + 1
              || (labs(pageIndex - currentPageIndex) > 1 && pageIndex < currentPageIndex)){
        imageView = _imageViewList[2];
    }else{
        imageView = _imageViewList[0];
    }
    return imageView;
}

- (void)reloadData{
    self.hidden = _curBannerList.count <= 0;
    if (_curBannerList.count <= 0) {
        return;
    }
    
    NSInteger currentPageIndex = MIN(self.mySlideView.currentPageIndex, _curBannerList.count - 1) ;
    
    _myPageControl.numberOfPages = _curBannerList.count;
    _myPageControl.currentPage = currentPageIndex;
    [_mySlideView reloadData];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
