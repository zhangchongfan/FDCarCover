//
//  MapRouteView.swift
//  FDCarCover
//
//  Created by 张冲 on 2018/1/19.
//  Copyright © 2018年 zhangchong. All rights reserved.
//

import UIKit
import MapKit

enum RouteMode {
    case walk
    case drive
}

let Latitude = "latitude"
let Longitude = "longitude"

class MapRouteView: UIView {

    //目的地
    var destination: [String:Double]? {
        didSet {
            showDestinationAnnotation()
        }
    }
    
    var mapView: MKMapView?
    var directions: MKDirections?
   
    let sliderView = UIView()
    
    var lineArr:[MKOverlay] = []
    
    var loadFinish = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setMapViewUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setMapViewUI() {
        mapView = MKMapView(frame: self.bounds)
        mapView?.delegate = self
        mapView?.showsUserLocation = true
        mapView?.userTrackingMode = .followWithHeading
        self.addSubview(mapView!)
    }
    
    func startPlanningRoute(mode: RouteMode, result: (() -> ())) {
        let destinationCoordinate = destinationLocation(locationDict: destination!).coordinate
        let userItem = MKMapItem(placemark: MKPlacemark(coordinate: (mapView?.userLocation.coordinate)!, addressDictionary: nil))
        let destinationItem = MKMapItem(placemark: MKPlacemark(coordinate: destinationCoordinate, addressDictionary: nil))
        let requst = MKDirectionsRequest()
        requst.source = userItem
        requst.destination = destinationItem
        requst.transportType = mode == .walk ? .walking : .automobile;
        // 发送请求
        
        directions = MKDirections.init(request: requst)
        directions?.calculate(completionHandler: { (directionsResponse, error) in
            if error != nil {
                MBProgressHUD.fd_show(withText: "路线规划失败,请查看网络是否正常", mode: .text, add: self)
                return
            }
            guard let response = directionsResponse else {
                MBProgressHUD.fd_show(withText: "路线规划失败", mode: .text, add: self)
                return
            }
            let routes = response.routes;
            if routes.count > 0 {
                self.mapView?.removeOverlays(self.lineArr)
                self.lineArr.removeAll()
                let route = routes.last;
                let routeSteps = route?.steps;
                for step in routeSteps! {
                    self.lineArr.append(step.polyline)
                    self.mapView?.add(step.polyline)
                }
            }else {
                MBProgressHUD.fd_show(withText: "没有可用路线，或已在目的地", mode: .text, add: self)
            }
        })
    }
    
    func destinationLocation(locationDict: Dictionary<String, Double>) -> CLLocation {
        let latitude = locationDict[Latitude]
        let longitude = locationDict[Longitude]
        let location = CLLocation(latitude: latitude!, longitude: longitude!)
        return location
    }
    
    func showDestinationAnnotation() {
        let desLocation = destinationLocation(locationDict: destination!)
        //  添加一个大头针
        //  创建一个大头针模型
        let anni = FDAnnotation(coordinate: desLocation.coordinate, title: "停車位置", subtitle: "")
        //  将大头针添加到地图
        mapView?.addAnnotation(anni)
        updateMapCenter(coordinate: destinationLocation(locationDict: destination!).coordinate)
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(desLocation) { (placemarks, error) in
            if error == nil {
                let placemark = placemarks![0]
                anni.subtitle = placemark.name
            }
        }
    }
    
    func updateMapCenter(coordinate: CLLocationCoordinate2D) {
        let centerRegion = MKCoordinateRegionMake(coordinate, MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        //让地图只显示一个固定要显示的区域
        mapView?.region = centerRegion;
    }
    
    func followUserLocation() {
        updateMapCenter(coordinate: (mapView?.userLocation.coordinate)!)
    }
    
}

extension MapRouteView: MKMapViewDelegate {
    
    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        if mapView.userLocation.coordinate.latitude != 0 && mapView.userLocation.coordinate.longitude != 0 && !loadFinish {
            loadFinish = true
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let render = MKPolylineRenderer(overlay: overlay)
        //配置渲染的宽度和渲染的颜色
        render.lineWidth = 5
        render.strokeColor = UIColor.red
        //返回配置好的渲染
        return render
    }
}

class FDAnnotation : NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
    }
}

