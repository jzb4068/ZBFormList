//
//  ZBCollectionView.m
//  ZBFormList
//
//  Created by 清科 on 2017/5/26.
//  Copyright © 2017年 清科. All rights reserved.
//

#import "ZBCollectionView.h"
@interface ZBCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UILabel * titleLabel;

@end

@implementation ZBCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    self.titleLabel = [[UILabel alloc]initWithFrame:self.bounds];
    _titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _titleLabel.textColor = [UIColor blackColor];
    _titleLabel.font = kTitleFont;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_titleLabel];
}

@end

@interface ZBCollectionView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionViewFlowLayout * layout;

@end

static NSString * ChartMenuItemCellIdfy = @"ChartMenuItemCellIdfy";
@implementation ZBCollectionView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [self initWithFrame:frame collectionViewLayout:self.layout];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    self = [super initWithFrame:frame collectionViewLayout:self.layout];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        self.allowsSelection = NO;
        self.backgroundColor = kLineColor;
        self.bounces = false;
        self.showsVerticalScrollIndicator = false;
        self.showsHorizontalScrollIndicator = false;
        [self registerClass:ZBCollectionViewCell.class forCellWithReuseIdentifier:ChartMenuItemCellIdfy];
    }
    return self;
}

- (UICollectionViewFlowLayout *)layout {
    if (!_layout) {
        self.layout = [[UICollectionViewFlowLayout alloc]init];
        _layout.minimumLineSpacing = kLineWidth;
        _layout.minimumInteritemSpacing = kLineWidth;
        _layout.sectionInset = UIEdgeInsetsMake(kLineWidth, kLineWidth, kLineWidth, kLineWidth);
    }
    return _layout;
}

#pragma mark -

- (void)setMenus:(NSArray<NSString *> *)menus {
    if (nil != menus) {
        _menus = menus;
        [self reloadData];
    }
}

#pragma mark - UICollectionView M

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _menus.count;;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZBCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:ChartMenuItemCellIdfy forIndexPath:indexPath];
    cell.titleLabel.text = _menus[indexPath.item];
    return cell;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
