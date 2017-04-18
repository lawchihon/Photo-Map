//
//  PhotoMapViewController.swift
//  Photo Map
//
//  Created by Nicholas Aiwazian on 10/15/15.
//  Copyright © 2015 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit

class PhotoMapViewController: UIViewController {

    @IBOutlet var mapView: MKMapView!
    @IBOutlet weak var cameraButton: UIButton!
    
    var pickedImage: UIImage!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // One degree of latitude is approximately 111 kilometers (69 miles) at all times.
        // San Francisco Lat, Long = latitude: 37.783333, longitude: -122.416667
        let mapCenter = CLLocationCoordinate2D(latitude: 37.783333, longitude: -122.416667)
        let mapSpan = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: mapCenter, span: mapSpan)
        // Set animated property to true to animate the transition to the region
        
        mapView.setRegion(region, animated: false)
        
        cameraButton.layer.cornerRadius = cameraButton.frame.width / 2
        cameraButton.clipsToBounds = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let locationsViewController = segue.destination as! LocationsViewController
        locationsViewController.delegate = self
    }
}

extension PhotoMapViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBAction func onCameraButton(_ sender: Any) {
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            print("Camera is available 📸")
            vc.sourceType = .camera
        } else {
            print("Camera 🚫 available so we will use photo library instead")
            vc.sourceType = .photoLibrary
        }
        self.present(vc, animated: true, completion: nil)        
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        // Get the image captured by the UIImagePickerController
        self.pickedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
        // Do something with the images (based on your use case)
        
        // Dismiss UIImagePickerController to go back to your original view controller
        self.dismiss(animated: true, completion: nil)
        self.performSegue(withIdentifier: "tagSegue", sender: "")
    }
}

extension PhotoMapViewController: LocationsViewControllerDelegate {
    func locationsPickedLocation(controller: LocationsViewController, latitude: NSNumber, longitude: NSNumber) {
        let annotation = MKPointAnnotation()
        let locationCoordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude))
        annotation.coordinate = locationCoordinate
        annotation.title = String(describing: latitude)
        mapView.addAnnotation(annotation)
    }
}
