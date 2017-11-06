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
#import <MagicalRecord/MagicalRecord.h>
#import "City+CoreDataClass.h"
#import "City+CoreDataProperties.h"

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
@property (strong, nonatomic) NSMutableArray *cityArray;
@property (strong, nonatomic) NSMutableArray *imageCity;



@end

@implementation detailControllTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _detailCityLabel.text = _detailSearchBarCity;
    self.tableViewDetails.dataSource = self;
    self.tableViewDetails.delegate = self;

    [[WANetworkManager sharedInstance] loadWeatherForTown:_detailCityLabel.text completion:^(NSDictionary *resposeData){

        self.cityArray = [resposeData valueForKeyPath:@"list.main.temp"];
        NSLog(@"%@",_cityArray);
        

        self.imageCity = [[resposeData valueForKeyPath:@"list.weather"] valueForKey: @"icon"];
        
        //objectAtIndex:0
        NSLog(@"%@=====", _imageCity);
        //NSString *url = [NSString stringWithFormat:@"http://openweathermap.org/img/w/%@.png",i];
        [self.tableViewDetails reloadData];
        
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
    return _cityArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIden;
    detailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIden"];
    if(cell == nil) {
        cell = [[detailTableViewCell new] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIden];
    }
    
    NSNumber * temperatureNumber = [_cityArray objectAtIndex:indexPath.row];
    temperatureNumber = @([temperatureNumber integerValue]);
    NSString * temperatureString = [temperatureNumber stringValue];

    cell.tempDetailLbl.text =  temperatureString;
    cell.imageC.image = [UIImage imageNamed:@"celsius.png"];
    
    NSString *numberIcon = [_imageCity objectAtIndex:indexPath.row];
    NSLog(@"%@", numberIcon);
    NSString *url = [NSString stringWithFormat:@"http://openweathermap.org/img/w/%@.png",numberIcon];
    NSLog(@"%@",url);
    [cell.imageDetail sd_setImageWithURL:[NSURL URLWithString:url]];
    return cell;
    
    
}

@end





