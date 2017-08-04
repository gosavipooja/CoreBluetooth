//
//  HomeViewController.h
//  CoreBluetoothImplementation
//
//  Created by Pooja Gosavi on 7/20/17.
//  Copyright © 2017 Pooja Gosavi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface HomeViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, CBCentralManagerDelegate, CBPeripheralDelegate>
@property (weak, nonatomic) IBOutlet UITableView *mTableView;
@property (strong, nonatomic) CBCentralManager *centralManager;
@property (strong, nonatomic) NSMutableArray *cbArray;
@end
