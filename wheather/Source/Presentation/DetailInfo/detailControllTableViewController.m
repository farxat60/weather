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
//@property (strong,nonatomic) NSMutableArray * tempsStrings;
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
    //cell.tempDetailLbl.text;
    return cell;
    
    
}



@end
//-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    static NSString *cellIden;
//    detailTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIden forIndexPath:indexPath];
//    cell = [[detailTableViewCell new] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIden];
//    
//    
//    
//    //       [[WANetworkManager sharedInstance] loadWeatherForTown:_detailCityLabel.text completion:^(NSDictionary *resposeData) {
//    //           NSNumber * temperatureNumber = [[resposeData valueForKeyPath: @"list.main.temp"]objectAtIndex:0];
//    //           NSLog(@"==============%@",temperatureNumber);
//    //           temperatureNumber = @([temperatureNumber integerValue]);
//    //
//    //           NSString * temperatureString = [temperatureNumber stringValue];
//    //        self.tempString = temperatureString;
//    //
//    //           NSString *numberIcon = [[[resposeData valueForKey:@"weather"]objectAtIndex:0]valueForKey:@"icon"];
//    //           NSLog(@"%@=====", numberIcon);
//    //           NSString *url = [NSString stringWithFormat:@"http://openweathermap.org/img/w/%@.png",numberIcon];
//    //           self.imgString = url;
//    //           NSURL *imageUrl = [NSURL URLWithString:url];
//    //           [cell.imageDetail sd_setImageWithURL:imageUrl];
//    //           NSString * data = [[resposeData valueForKey:@"list"]valueForKey:@"dt_txt"];
//    //
//    //           NSLog(@"%@",data);
//    //          self.dataStr = data;
//    //           //перенести в viewdidload  и сделать датусоурс и массив со значениями после вызываю массив
//    //           //infoplist url
//    //
//    //
//    //    }];
//    //cell.tempDetailLbl.text = _data;
//    //cell.imageDetail = _imageDet;
//    //cell.txtDateil.text = _dataStr;
//    //NSString *strings = [[_dataArrey valueForKeyPath:@"list.main.temp" ]objectAtIndex:0];
//    cell.tempDetailLbl.text = [[_dataArrey valueForKeyPath:@"list.main.temp" ]objectAtIndex:0];
//    
//    
//    
//    
//    
//    //NSLog(@"%@", _dataArrey);
//    //NSLog(@"%@", [[_dataArrey valueForKeyPath:@"list.main.temp" ]objectAtIndex:0]);
//    //NSLog(@"=============%@",_tempString);
//    
//    return cell;
//    


