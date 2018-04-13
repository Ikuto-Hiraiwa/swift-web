//
//  GuitarCustomCell.swift
//  
//
//  Created by 平岩郁人 on 2017/11/12.
//

import UIKit

class GuitarCustomCell: UITableViewCell {

    @IBOutlet weak var view: UIView!
    @IBOutlet var Use1: UILabel!
    @IBOutlet var Use2: UILabel!
    @IBOutlet var Guitar_Image: UIImageView!
    @IBOutlet var Guitar_Date: UILabel!
    @IBOutlet var Guitar_Title: UILabel!
    @IBOutlet var Guitar_Inner: UILabel!
    @IBOutlet var Guitar_Shop_Name: UILabel!
    @IBOutlet var Guitar_Price: UILabel!
    @IBOutlet var Guitar_Ship: UILabel!
    @IBOutlet var Guitar_State: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let ScreenSize : CGSize = UIScreen.main.bounds.size
        let CellSize_Height = ScreenSize.height/3
        view.frame = CGRect(x:8,y:8,width:ScreenSize.width - 16,height:ScreenSize.height/3 - 16)
        let View_Size = view.layer.bounds
        Guitar_Image.frame = CGRect(x:5,y:CellSize_Height/7,width:View_Size.height/1.45,height:View_Size.height/1.45)
        Use1.frame = CGRect(x:5,y:3,width:Guitar_Image.layer.bounds.width/2,height:Guitar_Image.layer.bounds.width/4.7)
        Use1.font = UIFont(name:"Cochin",size:Use1.layer.bounds.width/6)
        Use1.textAlignment = NSTextAlignment.center
        //Use1.backgroundColor = UIColor.red
        Use2.frame = CGRect(x:10 + Use1.layer.bounds.width,y:3,width:Use1.layer.bounds.width,height:Use1.layer.bounds.height)
        Use2.font = UIFont(name:"Cochin",size:Use1.layer.bounds.width/6)
        Use2.textAlignment = NSTextAlignment.left
        //Use2.backgroundColor = UIColor.blue
        
        Guitar_Date.frame = CGRect(x:25 + Use1.layer.bounds.width*2,y:3,width:ScreenSize.width - (50 + Use1.layer.bounds.width*2),height:Use1.layer.bounds.height)
        Guitar_Date.font = UIFont(name:"Cochin",size:Use1.layer.bounds.width/5)
        Guitar_Date.textAlignment = NSTextAlignment.center
        //Guitar_Date.backgroundColor = UIColor.yellow
        
        Guitar_Title.frame = CGRect(x:8 + Guitar_Image.layer.bounds.width,y:5 + Guitar_Date.layer.bounds.height,width:ScreenSize.width - (30 + Use1.layer.bounds.width*2),height:Use1.layer.bounds.height - 5)
        Guitar_Title.font = UIFont(name:"Cochin",size:Use1.layer.bounds.width/5)
        Guitar_Title.textAlignment = NSTextAlignment.left
        //Guitar_Title.backgroundColor = UIColor.red
        
        Guitar_Shop_Name.frame = CGRect(x:8 + Guitar_Image.layer.bounds.width,y:Guitar_Image.layer.bounds.height + 5,width:Guitar_Title.layer.bounds.width,height:Use1.layer.bounds.height - 3)
        Guitar_Shop_Name.font = UIFont(name:"Cochin",size:Use1.layer.bounds.width/5.5)
        Guitar_Shop_Name.textAlignment = NSTextAlignment.left
        //Guitar_Shop_Name.backgroundColor = UIColor.blue
        
        Guitar_Inner.frame = CGRect(x:10 + Use1.layer.bounds.width*2,y:CellSize_Height/7 + Guitar_Title.layer.bounds.height + 5,width:ScreenSize.width - (30 + Use1.layer.bounds.width*2),height:Guitar_Image.layer.bounds.height - Guitar_Title.layer.bounds.height - Guitar_Shop_Name.layer.bounds.height - 5)
        Guitar_Inner.font = UIFont(name:"Cochin",size:Use1.layer.bounds.width/5.5)
        Guitar_Inner.textAlignment = NSTextAlignment.left
        Guitar_Inner.numberOfLines = 0
        //Guitar_Inner.backgroundColor = UIColor.red
        
        Guitar_Price.frame = CGRect(x:5,y:Guitar_Image.layer.bounds.height + Use1.layer.bounds.height + 3,width:Guitar_Image.layer.bounds.width + 10,height:Use1.layer.bounds.height)
        Guitar_Price.font = UIFont(name:"Cochin",size:Use1.layer.bounds.width/4)
        Guitar_Price.textAlignment = NSTextAlignment.center
       // Guitar_Price.backgroundColor = UIColor.blue
        
        Guitar_Ship.frame = CGRect(x:7 + Guitar_Price.layer.bounds.width,y:Guitar_Image.layer.bounds.height + Use1.layer.bounds.height + 3,width:Use1.layer.bounds.width/1.4,height:Use1.layer.bounds.height)
        Guitar_Ship.font = UIFont(name:"Cochin",size:Use1.layer.bounds.width/6)
        Guitar_Ship.textAlignment = NSTextAlignment.left
        //Guitar_Ship.backgroundColor = UIColor.red
        
        Guitar_State.frame = CGRect(x:9 + Guitar_Price.layer.bounds.width + Guitar_Ship.layer.bounds.width,y:Guitar_Image.layer.bounds.height + Use1.layer.bounds.height + 3,width:ScreenSize.width - (Guitar_Ship.layer.bounds.width + Guitar_Price.layer.bounds.width + 30),height:Use1.layer.bounds.height)
        Guitar_State.font = UIFont(name:"Cochin",size:Use1.layer.bounds.width/6.5)
        Guitar_State.textAlignment = NSTextAlignment.center
       // Guitar_State.backgroundColor = UIColor.yellow
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func SetCell(Model:GuitarCellModel){
        for i in 0 ..< Model.cell_guitar_use.count{
            if i == 0{
                self.Use1.text = Model.cell_guitar_use[0]
                if Model.cell_guitar_use[0] == "NEW!"{
                    Use1.textColor = UIColor.red
                }
            }else{
                self.Use2.text = Model.cell_guitar_use[1]
            }
        }
        let image_url = URL(string:Model.cell_guitar_pic_url)
        self.Guitar_Image.sd_setImage(with: image_url)
        self.Guitar_Date.text = Model.cell_guitar_date
        self.Guitar_Title.text = Model.cell_guitar_title
        self.Guitar_Inner.text = Model.cell_guitar_inner
        self.Guitar_Shop_Name.text = Model.cell_guitar_shop_name
        self.Guitar_Price.text = Model.cell_guitar_price
        self.Guitar_Ship.text = Model.cell_guitar_ship_price
        self.Guitar_State.text = Model.cell_guitar_state

    }
    
}
