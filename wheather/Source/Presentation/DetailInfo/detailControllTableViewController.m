//
//  detailControllTableViewController.m
//  wheather
//
//  Created by Joe Franc on 10/26/17.
//  Copyright © 2017 Joe Franc. All rights reserved.
//

#import "detailControllTableViewController.h"
#import "SearchVieController.h"
#import "WANetworkManager.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "detailTableViewCell.h"

static NSString const * kcels = @"\u00B0";



@interface detailControllTableViewController () <UITableViewDelegate, UITableViewDataSource, SDWebImageManagerDelegate>
@property (strong, nonatomic) IBOutlet UILabel *detailCityLabel;
@property (strong, nonatomic) IBOutlet UITableView *tableViewDetails;
@property (strong, nonatomic) NSString *tempString;
@property (strong, nonatomic) IBOutlet UILabel *tempDetailLbl;
@property (strong, nonatomic) IBOutlet UIImageView *imageDetail;
@property (strong, nonatomic) IBOutlet UILabel *txtDateil;
@property (strong, nonatomic) NSString *imgString;
@property (strong, nonatomic) NSString *dataStr;
@property (strong, nonatomic) NSArray *dataArrey;
@property (strong, nonatomic) NSString *tempDetail;


@end

@implementation detailControllTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _detailCityLabel.text = _detailSearchBarCity;
    self.tableViewDetails.dataSource = self;
    self.tableViewDetails.delegate = self;

    [[WANetworkManager sharedInstance] loadWeatherForTown:_detailCityLabel.text completion:^(NSDictionary *resposeData){
        NSArray * arrayDay = [NSArray new];
        arrayDay = [resposeData allValues];
        self.dataArrey = arrayDay;
        NSLog(@" arrayDay ======%@", arrayDay);
        
    }];
    
    [self.tableViewDetails reloadData];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArrey.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
     static NSString *cellIden;
    detailTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIden forIndexPath:indexPath];
    cell = [[detailTableViewCell new] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIden];
    return cell;
    
    
}

@end



