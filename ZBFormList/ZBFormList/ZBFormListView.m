//
//  ZBFormListView.m
//  ZBFormList
//
//  Created by 清科 on 2017/5/26.
//  Copyright © 2017年 清科. All rights reserved.
//

#import "ZBFormListView.h"
#import "UIView+Frame.h"
#import "ZBCollectionView.h"
#import "ZBCollectionViewLayout.h"

@interface ZBFormViewCell : UICollectionViewCell

@end

@implementation ZBFormViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

@end




@interface ZBFormListView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UIView * containerView;
@property (nonatomic, strong) UICollectionView * contentView;
@property (nonatomic, strong) ZBCollectionViewLayout * layout;
@property (nonatomic, strong) ZBCollectionView * topMenuBar;
@property (nonatomic, strong) ZBCollectionView * sideMenuBar;
@property (nonatomic, assign) CGFloat topMenuWidth;
@property (nonatomic, assign) CGFloat sideMenuWidth;
@property (nonatomic, assign) BOOL shouldChangeMenuOffset;
@property (nonatomic, assign) BOOL shouldChangeChartViewOffset;

@end

static void *FormViewConstentOffsetContext  = &FormViewConstentOffsetContext;
static void *TopMenuConstentOffsetContext    = &TopMenuConstentOffsetContext;
static void *SideMenuConstentOffsetContext   = &SideMenuConstentOffsetContext;
static NSString * ChartViewCellIdfy = @"ChartViewCellIdfy";

@implementation ZBFormListView

- (void)dealloc {
    [_topMenuBar removeObserver:self forKeyPath:@"contentOffset"];
    [_sideMenuBar removeObserver:self forKeyPath:@"contentOffset"];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    self.shouldChangeMenuOffset = YES;
    self.shouldChangeChartViewOffset = YES;
    [self setupViews];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame topMenus:(NSArray <NSString *>*)topMenus sideMenus:(NSArray <NSString *>*)sideMenus {
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    self.topMenus = topMenus;
    self.sideMenus = sideMenus;
    self.shouldChangeMenuOffset = YES;
    self.shouldChangeChartViewOffset = YES;
    [self setupViews];
    return self;
}

- (void)setupViews {
    _topMenuWidth = [self getMaxWidthFrom:_topMenus];
    _sideMenuWidth = [self getMaxWidthFrom:_sideMenus];
    CGFloat itemWidth = _topMenuWidth;
    // container
    self.containerView = ({
        UIView * view = [UIView new];
        view.backgroundColor = [UIColor redColor];
        view.clipsToBounds = YES;
        view;
    });
    // list
    self.contentView = ({
        self.layout.itemSize = CGSizeMake(itemWidth, kItemHeight);
        UICollectionView * collectionView = [[UICollectionView alloc]initWithFrame:_containerView.bounds collectionViewLayout:self.layout];
        collectionView.backgroundColor = kLineColor;
        collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        collectionView.contentInset = UIEdgeInsetsMake(kItemHeight + 2 *kLineWidth, _sideMenuWidth + 2 *kLineWidth, 0, 0);
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView.bounces = NO;
        collectionView.showsVerticalScrollIndicator = false;
        collectionView.showsHorizontalScrollIndicator = false;
        [collectionView registerClass:ZBFormViewCell.class forCellWithReuseIdentifier:ChartViewCellIdfy];
        [collectionView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:FormViewConstentOffsetContext];
        collectionView;
    });
    
    // left corner view
    UIView * leftCornerBgView = [UIView new];
    leftCornerBgView.tag = 500;
    leftCornerBgView.backgroundColor = kLineColor;
    leftCornerBgView.clipsToBounds = YES;
    UIView * leftCornerView = [UIView new];
    leftCornerView.backgroundColor = [UIColor whiteColor];
    leftCornerView.top = kLineWidth;
    leftCornerView.left = kLineWidth;
    [leftCornerBgView addSubview:leftCornerView];
    
    // top menu
    self.topMenuBar = ({
        ZBCollectionView* topMenu = [ZBCollectionView new];
        topMenu.size = CGSizeMake(self.width - leftCornerBgView.right , kItemHeight + 2 *kLineWidth);
        topMenu.top = 0;
        topMenu.left = leftCornerView.right + kLineWidth;
        topMenu.contentInset = UIEdgeInsetsZero;
        UICollectionViewFlowLayout * layout = (UICollectionViewFlowLayout *)topMenu.collectionViewLayout;
        layout.itemSize = CGSizeMake(_topMenuWidth, kItemHeight);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.sectionInset = UIEdgeInsetsMake(kLineWidth, 0, kLineWidth, kLineWidth);
        [topMenu addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:TopMenuConstentOffsetContext];
        [topMenu setMenus:_topMenus];
        topMenu;
    });
    
    // side menu
    self.sideMenuBar = ({
        ZBCollectionView * sideMenu = [ZBCollectionView new];
        sideMenu.size = CGSizeMake(_sideMenuWidth + 2 *kLineWidth, self.height - leftCornerBgView.bottom);
        sideMenu.top = leftCornerView.bottom + kLineWidth;
        sideMenu.left = 0;
        sideMenu.contentInset = UIEdgeInsetsZero;
        UICollectionViewFlowLayout * layout = (UICollectionViewFlowLayout *)sideMenu.collectionViewLayout;
        layout.itemSize = CGSizeMake(_sideMenuWidth, kItemHeight);
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.sectionInset = UIEdgeInsetsMake(0, kLineWidth, kLineWidth, kLineWidth);
        [sideMenu addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:SideMenuConstentOffsetContext];
        [sideMenu setMenus:_sideMenus];
        sideMenu;
    });
    
    [self addSubview:_containerView];
    [_containerView addSubview:_contentView];
    [_containerView addSubview:leftCornerBgView];
    [_containerView addSubview:_topMenuBar];
    [_containerView addSubview:_sideMenuBar];
}

- (ZBCollectionViewLayout *)layout {
    if (!_layout) {
        self.layout = [[ZBCollectionViewLayout alloc]init];
        _layout.minimumLineSpacing = kLineWidth;
        _layout.minimumInteritemSpacing = kLineWidth;
        _layout.sectionInset = UIEdgeInsetsMake(0, 0, kLineWidth, kLineWidth);
    }
    return _layout;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    // list
    _contentView.contentInset = UIEdgeInsetsMake(kItemHeight + 2 *kLineWidth, _sideMenuWidth + 2 *kLineWidth, 0, 0);
    // left corner view
    UIView * leftCornerBgView = [self viewWithTag:500];
    UIView * leftCornerView = [[leftCornerBgView subviews]lastObject];
    if (_sideMenuWidth > 0) {
        leftCornerBgView.size = CGSizeMake(_sideMenuWidth + 2 *kLineWidth, kItemHeight + 2 *kLineWidth);
        leftCornerView.size = CGSizeMake(_sideMenuWidth, kItemHeight);
    }else {
        leftCornerBgView.size = CGSizeZero;
    }
    // top menu
    CGFloat height = (kItemHeight + kLineWidth) * _sideMenus.count;
    CGFloat width  = (_topMenuWidth + kLineWidth) * _topMenus.count;
    _topMenuBar.size = CGSizeMake(self.width - (leftCornerView.right + kLineWidth) , kItemHeight + 2 *kLineWidth);
    _topMenuBar.left = leftCornerBgView.right;
    UICollectionViewFlowLayout * t_layout = (UICollectionViewFlowLayout *)_topMenuBar.collectionViewLayout;
    t_layout.itemSize = CGSizeMake(_topMenuWidth, kItemHeight);
    // side menu
    _sideMenuBar.size = CGSizeMake(_sideMenuWidth + 2 *kLineWidth, self.height - (leftCornerView.bottom + kLineWidth));
    _sideMenuBar.top = leftCornerBgView.bottom;
    UICollectionViewFlowLayout * s_layout = (UICollectionViewFlowLayout *)_sideMenuBar.collectionViewLayout;
    s_layout.itemSize = CGSizeMake(_sideMenuWidth, kItemHeight);
    
    // container
    height += _sideMenuWidth > 0?kItemHeight + 2 *kLineWidth:0;
    width  += _topMenuWidth > 0?leftCornerBgView.width:0;
    height  = MIN(height, self.height);
    width   = MIN(width, self.width);
    _containerView.size = CGSizeMake(width, height);
}

#pragma mark -

- (void)setTopMenus:(NSArray<NSString *> *)topMenus {
    if (nil != topMenus) {
        _topMenus = topMenus;
        _topMenuWidth = [self getMaxWidthFrom:_topMenus];
        _layout.itemSize = CGSizeMake(_topMenuWidth, kItemHeight);
        [_topMenuBar setMenus:_topMenus];
        [self setNeedsLayout];
        [self layoutIfNeeded];
        [_contentView reloadData];
        [self adjustContentOffset];
    }
}

- (void)setSideMenus:(NSArray<NSString *> *)sideMenus {
    if (nil != sideMenus) {
        _sideMenus = sideMenus;
        _sideMenuWidth = [self getMaxWidthFrom:_sideMenus];
        [_sideMenuBar setMenus:_sideMenus];
        [self setNeedsLayout];
        [self layoutIfNeeded];
        [_contentView reloadData];
        [self adjustContentOffset];
    }
}

- (void)setDataSource:(NSArray *)dataSource {
    if (nil != dataSource) {
        _dataSource = dataSource;
        [_contentView reloadData];
    }
}

- (CGFloat)getMaxWidthFrom:(NSArray <NSString *>*)menus {
    if (menus.count <= 0) {
        return 0;
    }
    [menus sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"length" ascending:YES]]];
    CGFloat paddingInsert = 8;
    CGFloat width = [[menus lastObject] boundingRectWithSize:CGSizeMake(MAXFLOAT, kItemHeight) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kTitleFont} context:nil].size.width;
    width += 2 *paddingInsert;
    width  = roundf(width);
    return width;
}

- (void)adjustContentOffset {
    
    CGPoint contentOffset = _contentView.contentOffset;
    contentOffset.x = - (_sideMenuWidth + 2 *kLineWidth);
    contentOffset.y = - (kItemHeight + 2 *kLineWidth);
    _shouldChangeChartViewOffset = false;
    _contentView.contentOffset   = contentOffset;
    _shouldChangeChartViewOffset = true;
    
    _shouldChangeMenuOffset    = false;
    _topMenuBar.contentOffset  = CGPointZero;
    _sideMenuBar.contentOffset = CGPointZero;
    _shouldChangeMenuOffset    = true;
}

#pragma mark - UICollectionView M

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _topMenus.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return _sideMenus.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZBFormViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:ChartViewCellIdfy forIndexPath:indexPath];
    @try {
        UIColor * color = _dataSource[indexPath.section][indexPath.item];
        if (color) {
            cell.backgroundColor = color;
        }else {
            cell.backgroundColor = [UIColor whiteColor];
        }
    } @catch (NSException *exception) {}
    
    return cell;
}

#pragma mark - Observe

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
    if (_shouldChangeChartViewOffset) {
        if (context == FormViewConstentOffsetContext) {
            
            CGPoint contentOffsetN  = [change[NSKeyValueChangeNewKey] CGPointValue];
            CGPoint contentOffsetO  = [change[NSKeyValueChangeOldKey] CGPointValue];
            CGFloat delt_x = contentOffsetN.x - contentOffsetO.x;
            CGFloat delt_y = contentOffsetN.y - contentOffsetO.y;
            
            CGPoint topbar_contentOffset  = _topMenuBar.contentOffset;
            CGPoint sidebar_contentOffset = _sideMenuBar.contentOffset;
            topbar_contentOffset.x  += delt_x;
            sidebar_contentOffset.y += delt_y;
            
            _shouldChangeMenuOffset = false;
            _topMenuBar.contentOffset  = topbar_contentOffset;
            _sideMenuBar.contentOffset = sidebar_contentOffset;
            _shouldChangeMenuOffset = true;
        }
    }
    
    if (_shouldChangeMenuOffset) {
        if (context == TopMenuConstentOffsetContext) {
            
            CGPoint topbar_contentOffsetN  = [change[NSKeyValueChangeNewKey] CGPointValue];
            CGPoint topbar_contentOffsetO  = [change[NSKeyValueChangeOldKey] CGPointValue];
            CGFloat delt_x = topbar_contentOffsetN.x - topbar_contentOffsetO.x;
            
            CGPoint content_contentOffset = _contentView.contentOffset;
            content_contentOffset.x += delt_x;
            _shouldChangeChartViewOffset = false;
            _contentView.contentOffset = content_contentOffset;
            _shouldChangeChartViewOffset = true;
            
        }
        if (context == SideMenuConstentOffsetContext) {
            
            CGPoint sidebar_contentOffsetN  = [change[NSKeyValueChangeNewKey] CGPointValue];
            CGPoint sidebar_contentOffsetO  = [change[NSKeyValueChangeOldKey] CGPointValue];
            CGFloat delt_y = sidebar_contentOffsetN.y - sidebar_contentOffsetO.y;
            
            CGPoint content_contentOffset = _contentView.contentOffset;
            content_contentOffset.y += delt_y;
            _shouldChangeChartViewOffset = false;
            _contentView.contentOffset = content_contentOffset;
            _shouldChangeChartViewOffset = true;
            
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
