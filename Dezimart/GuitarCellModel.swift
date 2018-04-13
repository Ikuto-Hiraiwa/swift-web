//
//  GuitarCellModel.swift
//  Dezimart
//
//  Created by 平岩郁人 on 2017/11/12.
//  Copyright © 2017年 ikuto. All rights reserved.
//

import Foundation

class GuitarCellModel : NSObject {
    var cell_guitar_title : String
    var cell_guitar_url : String
    var cell_guitar_inner : String
    var cell_guitar_date : String
    var cell_guitar_shop_name : String
    var cell_guitar_shop_url : String
    var cell_guitar_use : [String]
    var cell_guitar_pic_url : String
    var cell_guitar_price : String
    var cell_guitar_ship_price : String
    var cell_guitar_state : String
    var cell_guitar_soldout : String

    
    init(M_guitar_title:String,M_guitar_url:String,M_guitar_inner:String,M_guitar_date:String,M_guitar_shop_name:String,M_guitar_shop_url:String,M_guitar_use:[String],M_guitar_pic_url:String,M_guitar_price:String,M_guitar_ship_price:String,M_guitar_state:String,M_guitar_soldout:String){
        self.cell_guitar_title = M_guitar_title
        self.cell_guitar_url = M_guitar_url
        self.cell_guitar_inner = M_guitar_inner
        self.cell_guitar_date = M_guitar_date
        self.cell_guitar_shop_name = M_guitar_shop_name
        self.cell_guitar_shop_url = M_guitar_shop_url
        self.cell_guitar_use = M_guitar_use
        self.cell_guitar_pic_url = M_guitar_pic_url
        self.cell_guitar_price = M_guitar_price
        for i in 0 ..< M_guitar_use.count{
            self.cell_guitar_use.append(M_guitar_use[i])
        }
        self.cell_guitar_ship_price = M_guitar_ship_price
        self.cell_guitar_state = M_guitar_state
        self.cell_guitar_soldout = M_guitar_soldout
    }
    
}
