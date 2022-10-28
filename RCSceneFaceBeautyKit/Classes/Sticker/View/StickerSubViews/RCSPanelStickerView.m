//
//  RCSPanelStickerView.m
//  RCSceneFaceBeautyKit
//
//  Created by 彭蕾 on 2022/10/17.
//

#import "RCSPanelStickerView.h"
#import "RCSStickerCell.h"

@interface RCSPanelStickerView ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation RCSPanelStickerView
- (instancetype)init {
    if (self = [super init]) {
        [self buildLayout];
    }
    return self;
}

- (void)buildLayout {
    [self addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
    
}

#pragma mark - public methods
- (void)setSelectedIndex:(NSInteger)selectedIndex {
    if (selectedIndex >= self.dataArray.count && selectedIndex >= 0) return;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:selectedIndex inSection:0];
    /// 滑动到之前设置的index
    dispatch_main_async_safe(^{
          [self.collectionView scrollToItemAtIndexPath:indexPath
                                      atScrollPosition:UICollectionViewScrollPositionNone
                                              animated:NO];
    });
    
    _selectedIndex = selectedIndex;
    
}

- (void)setDataArray:(NSArray<RCSStickerModel *> *)dataArray {
    _dataArray = dataArray;
    [self.collectionView reloadData];
}

- (void)reloadData {
    [self.collectionView reloadData];
}

- (void)reloadDataWithIndexPath:(NSIndexPath *)indexPath {
    RCSStickerCell *cell = (RCSStickerCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    [cell setModel:self.dataArray[indexPath.row]];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                           cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    RCSStickerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RCSStickerCell"
                                                                        forIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.row];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedIndex = indexPath.row;
    [self.collectionView reloadData];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(panelStickerView:didSelectedIndex:)]) {
        [self.delegate panelStickerView:self didSelectedIndex:indexPath];
    }
}

#pragma mark - lazy load
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 22;
        flowLayout.minimumInteritemSpacing = 22;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        flowLayout.sectionInset = UIEdgeInsetsMake(16, 16, 5, 16);
        flowLayout.itemSize = CGSizeMake(51, 51);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:RCSStickerCell.class forCellWithReuseIdentifier:@"RCSStickerCell"];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.allowsMultipleSelection = NO;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
    }
    return _collectionView;
}

@end
