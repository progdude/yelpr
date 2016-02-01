//
//  DetailBusinessViewController.swift
//  Yelp
//
//  Created by Archit Rathi on 1/31/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit

class DetailBusinessViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratingsImageView: UIImageView!
    
    @IBOutlet weak var reviewCountLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    var business: Business!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        nameLabel.text = business.name
        nameLabel.sizeToFit()
        addressLabel.text = business.address
        addressLabel.sizeToFit()
        descriptionLabel.text = business.categories
        descriptionLabel.sizeToFit()
        
        reviewCountLabel.text = "\(business.reviewCount!) Reviews"
        
        
        ratingsImageView.setImageWithURL(business.ratingImageURL!)
        
        let centerLocation = CLLocation(latitude: business.latitude!,longitude: business.longitude!);
        print(business.latitude!);
        print(business.longitude!);
        goToLocation(centerLocation);
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func goToLocation(location: CLLocation) {
        let span = MKCoordinateSpanMake(0.1, 0.1)
        let region = MKCoordinateRegionMake(location.coordinate, span)
        mapView.setRegion(region, animated: false)
        let annotation = MKPointAnnotation()
        annotation.coordinate = location.coordinate
        annotation.title = business.name
        mapView.addAnnotation(annotation)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
