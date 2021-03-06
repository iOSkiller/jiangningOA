//
//  CalenderView.m
//  日历表
//
//  Created by apple on 16/6/14.
//  Copyright © 2016年 雷晏. All rights reserved.
//

#import "CalenderView.h"

@interface CalenderCell : UICollectionViewCell

@property (nonatomic,strong) UIButton *dateBtn;

@end

@implementation CalenderCell

- (UIButton *)dateBtn
{
    if (!_dateBtn) {
        //_dateBtn = [[UIButton alloc] init];
        _dateBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        [_dateBtn setTintColor:[UIColor blackColor]];
        _dateBtn.frame = self.bounds;
        //_dateBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _dateBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        _dateBtn.layer.cornerRadius = _dateBtn.height * 0.5;
        _dateBtn.layer.masksToBounds = YES;
        [self addSubview:_dateBtn];
    }
    return _dateBtn;
}
@end

@interface CalenderView()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic,strong) NSCalendar *currentCalendar;
@property (nonatomic , strong) NSArray *weekDayArray;
@property (nonatomic,strong) NSDate *currentDate;
@property (weak, nonatomic) UICollectionView *collectionview;
@property (weak, nonatomic) UILabel *titleLabel;
@property (nonatomic,strong) NSMutableArray *selectStauts;
@end

@implementation CalenderView

-(instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame]){
        
        _currentDate = [self getLocalDate];
        _selectStauts = @[].mutableCopy;
        
        self.backgroundColor = [UIColor whiteColor];
        //头部视图
        UIView *titleView = [UIView new];
        titleView.frame = CGRectMake(0, 0, frame.size.width, 50);
        titleView.backgroundColor = [UIColor whiteColor];
        [self addSubview:titleView];
        //头部label
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:titleView.bounds];
        titleLabel.text = [self stirngFromDate:_currentDate];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont systemFontOfSize:20.f];
        [titleView addSubview:titleLabel];
        _titleLabel = titleLabel;
        //上一页按钮
        UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        leftBtn.center = CGPointMake(55, titleLabel.center.y);
        leftBtn.bounds = CGRectMake(0, 0, 30, 30);
        [leftBtn setBackgroundImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
        [titleView addSubview:leftBtn];
        [leftBtn addTarget:self action:@selector(previous) forControlEvents:UIControlEventTouchUpInside];
        //下一页按钮
        UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        rightBtn.center = CGPointMake(titleLabel.bounds.size.width - 55, titleLabel.center.y);
        rightBtn.bounds = CGRectMake(0, 0, 30, 30);
        [rightBtn setBackgroundImage:[UIImage imageNamed:@"right"] forState:UIControlStateNormal];
        [titleView addSubview:rightBtn];
        [rightBtn addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
        //分割线
        UIView *img = [[UIView alloc] initWithFrame:CGRectMake(15, 48, titleView.width - 30, 1)];
        img.backgroundColor = XHColor(194, 195, 196);
        [titleView addSubview:img];
        
        CGFloat itemWidth = (frame.size.width-2) / 7;
        CGFloat itemHeight = (frame.size.height - 50-2) / 7;
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = CGSizeMake(itemWidth, itemHeight);
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        
        UICollectionView *collectionview = [[UICollectionView alloc]initWithFrame:CGRectMake(1, titleView.bounds.size.height+1, frame.size.width-2, frame.size.height - titleView.bounds.size.height-2) collectionViewLayout:layout];
        collectionview.backgroundColor = [UIColor whiteColor];
        [self addSubview:collectionview];
        [collectionview registerClass:[CalenderCell class] forCellWithReuseIdentifier:@"cell"];
        collectionview.dataSource = self;
        collectionview.delegate = self;
        collectionview.scrollEnabled = NO;
        collectionview.showsVerticalScrollIndicator = NO;
        _collectionview = collectionview;
    }
    return self;
}


#pragma mark - UICollectionView DataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if(section == 0){
        return self.weekDayArray.count;
    }else{
        return 47;
    }
}

-(CalenderCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CalenderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    if(indexPath.section == 0){
        //cell.dateBtn.titleLabel.text = _weekDayArray[indexPath.row];
        [cell.dateBtn setTitle:self.weekDayArray[indexPath.row] forState:UIControlStateNormal];
        [cell.dateBtn setTintColor:[UIColor blackColor]];
       // cell.dateBtn.titleLabel.tintColor = [UIColor blackColor];
    }else{
        //一个月里所有的天数
        NSInteger daysInThisMonth = [self getDaysOfMonth];
        //一个月里的第一天是星期几
        NSInteger firstWeekday = [self getWeekOfDayOfMonth];
        NSInteger day = 0;
        
        //行数不大于第一天的星期数
        if (indexPath.row < firstWeekday) {
          //  [cell.dateBtn.titleLabel setText:@""];
          //  cell.dateBtn.titleLabel.text = @"";
            [cell.dateBtn setTitle:@"" forState:UIControlStateNormal];
        //行数大于第一天所在的星期数＋这个月的天数－1
        }else if (indexPath.row > firstWeekday + daysInThisMonth - 1){
           // [cell.dateBtn.titleLabel setText:@""];
           // cell.dateBtn.titleLabel.text = @"";
             [cell.dateBtn setTitle:@"" forState:UIControlStateNormal];
        }else{
            day = indexPath.row - firstWeekday + 1;
           // [cell.dateBtn.titleLabel setText:[NSString stringWithFormat:@"%li",(long)day]];
            //cell.dateBtn.titleLabel.text = [NSString stringWithFormat:@"%li",(long)day];
             [cell.dateBtn setTitle:[NSString stringWithFormat:@"%li",(long)day] forState:UIControlStateNormal];
           // [cell.dateBtn.titleLabel setTextColor:[UIColor colorWithHexString:@"#6f6f6f"]];
            [cell.dateBtn setTintColor:[UIColor blackColor]];
           // cell.dateBtn.titleLabel.tintColor = [UIColor colorWithHexString:@"#6f6f6f"];
        }
    }
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 1){
        CalenderCell *cell = (CalenderCell *)[collectionView cellForItemAtIndexPath:indexPath];
        if(cell.dateBtn.titleLabel.text.length != 0){
            [cell.contentView.layer setCornerRadius:10.0f];
            [cell.contentView setBackgroundColor:XHColor(58, 182, 212)];
        }
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CalenderCell *deselectedCell = (CalenderCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if(deselectedCell.dateBtn.titleLabel.text.length != 0){
        [deselectedCell.contentView.layer setCornerRadius:10.f];
        [deselectedCell.contentView setBackgroundColor:[UIColor clearColor]];
    }
}

#pragma -mark btn事件
-(void)previous{
    [UIView transitionWithView:self duration:0.5 options:UIViewAnimationOptionTransitionCurlDown animations:^(void) {
        _currentDate = [self getPerviousMonth:_currentDate];
        _titleLabel.text = [self stirngFromDate:_currentDate];
        [_collectionview reloadData];
    } completion:nil];
}

-(void)next{
    [UIView transitionWithView:self duration:0.5 options:UIViewAnimationOptionTransitionCurlUp animations:^(void) {
        _currentDate = [self getNextMonth:_currentDate];
        _titleLabel.text = [self stirngFromDate:_currentDate];
        [_collectionview reloadData];
    }completion:nil];
}

#pragma mark - Get 初始化
-(NSCalendar *)currentCalendar{
    if(!_currentCalendar){
        _currentCalendar = [NSCalendar currentCalendar];
    }
    return _currentCalendar;
}

-(NSArray *)weekDayArray{
    _weekDayArray = @[@"日",@"一",@"二",@"三",@"四",@"五",@"六"];
    return _weekDayArray;
}

/**
 *  取到北京时间
 *
 *  @return <#return value description#>
 */
-(NSDate *)getLocalDate{
    NSDate *date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:date];
    NSDate *localDate = [date dateByAddingTimeInterval:interval];
    return localDate;
}

/**
 *  得到这个月的第一天
 *
 *  @return <#return value description#>
 */
-(NSDate *)getFirstDayOfCurrentMonth
{
    double interval = 0;
    NSDate *beginDate = nil;
    //    NSDate *endDate = nil;
    
    [self.currentCalendar setFirstWeekday:1];//设定周一为周首日
    BOOL ok = [self.currentCalendar rangeOfUnit:NSCalendarUnitMonth startDate:&beginDate interval:&interval forDate:_currentDate];
    //分别修改为 NSDayCalendarUnit NSWeekCalendarUnit NSYearCalendarUnit
    if (ok) {
        //        endDate = [beginDate dateByAddingTimeInterval:interval-1];
    }else {
    }
    return beginDate;
}
/**
 *  得到这个月的第一天是星期几
 *
 *  @return <#return value description#>
 */
-(NSUInteger)getWeekOfDayOfMonth{
    NSUInteger weekCount = [self.currentCalendar ordinalityOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitWeekOfMonth forDate:[self getFirstDayOfCurrentMonth]] - 1;
    return weekCount;
}

/**
 *  得到这个月的天数
 *
 *  @return <#return value description#>
 */
-(NSUInteger)getDaysOfMonth{
    NSUInteger daysCount = [self.currentCalendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:_currentDate].length;
    return daysCount;
}

/**
 *  得到这个月的周数
 *
 *  @return <#return value description#>
 */
-(NSUInteger)getWeeksOfMonth{
    NSUInteger weekDay = [self getWeekOfDayOfMonth];
    NSUInteger days = [self getDaysOfMonth];
    NSUInteger weeks = 0;
    
    if(weekDay > 1){
        weeks+=1;
        days-=(7-weekDay+1);
    }
    
    weeks+=days/7;
    weeks+=(days%7>0)?1:0;
    return weeks;
}

/**
 *  NSDate 转成字符串
 *
 *  @param wtime <#wtime description#>
 *
 *  @return <#return value description#>
 */
-(NSString *)stirngFromDate:(NSDate *)wtime{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy年MM"];
    return [dateFormatter stringFromDate:wtime];
}

/**
 *  下一个月
 *
 *  @param date <#date description#>
 *
 *  @return <#return value description#>
 */
- (NSDate*)getNextMonth:(NSDate *)date{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = +1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    return newDate;
}

/**
 *  上一个月
 *
 *  @param date <#date description#>
 *
 *  @return <#return value description#>
 */
- (NSDate*)getPerviousMonth:(NSDate *)date{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = -1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    return newDate;
}
@end
