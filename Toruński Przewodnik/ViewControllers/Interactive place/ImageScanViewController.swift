//
//  ImageScanViewController.swift
//  Toruński Przewodnik
//
//  Created by Arkadiusz Stasczak on 22/09/2018.
//  Copyright © 2018 Arkadiusz Staśczak. All rights reserved.
//

import UIKit
import ARKit
import WebKit

class ImageScanViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet weak var sceneView: ARSCNView!
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self
        
        sceneView.scene = SCNScene()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let configuration = ARImageTrackingConfiguration()
        
        guard let trackingImages = ARReferenceImage.referenceImages(inGroupNamed: "TorunARAssets", bundle: Bundle.main)
            else{
                print("Brak obrazków")
                return
            }
        
        configuration.trackingImages = trackingImages
        configuration.maximumNumberOfTrackedImages = 1
        sceneView.session.run(configuration)
        
    }
    
    func makeSegue(with url: String) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1, execute: {
            let storyboard = UIStoryboard(name: storyboardName.imageScan.identifier(), bundle: Bundle.main)
            guard let destinationVC = storyboard.instantiateViewController(withIdentifier: segueDestination.webView.identifier()) as? WebViewViewController else {return}
            destinationVC.urlPath = url
            
            self.navigationController?.pushViewController(destinationVC, animated: true)
        })
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        if let nodeMaterial = node.childNodes.first?.geometry?.firstMaterial?.diffuse.contents as? AVPlayer {
            nodeMaterial.pause()
        }
    }
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        
        let node = SCNNode()

        if let imageAnchor = anchor as? ARImageAnchor {
            
            switch imageAnchor.referenceImage.name {
            case imageName.zaba.identifier():
                let url = "https://pl.wikipedia.org/wiki/Pomnik_flisaka_w_Toruniu"
                self.makeSegue(with: url)
            case imageName.zamek.identifier():
                let url = "https://pl.wikipedia.org/wiki/Zamek_krzy%C5%BCacki_w_Toruniu"
                self.makeSegue(with: url)
            case imageName.most.identifier():
                let url = "https://pl.wikipedia.org/wiki/Most_drogowy_im._J%C3%B3zefa_Pi%C5%82sudskiego_w_Toruniu"
                self.makeSegue(with: url)
            case imageName.starowka.identifier():
                let url = "https://pl.wikipedia.org/wiki/Stare_Miasto_(Toru%C5%84)"
                self.makeSegue(with: url)
            case .none:
                break
            case .some(_):
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1, execute: {
                    let videoHolder = SCNNode()
                    let videoHolderGeometry = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
                    
                    let filePath = Bundle.main.path(forResource: "TorunFilm", ofType: "mp4")
                    let videoURL = NSURL(fileURLWithPath: filePath!)
                    let videoPlayerNode = AVPlayer(url: videoURL as URL)
                    videoPlayerNode.play()
                    
                    videoHolderGeometry.firstMaterial?.diffuse.contents = videoPlayerNode
                    videoHolderGeometry.firstMaterial?.isDoubleSided = true
                    videoHolder.eulerAngles.x = -.pi/2
                    videoHolder.geometry = videoHolderGeometry
                    
                    node.addChildNode(videoHolder)
                })
            }
        }
        
        return node
    }

}

enum imageName: String {
    case zaba = "zaba"
    case zamek = "zamek"
    case starowka = "starowka"
    case most = "most"
    
    func identifier() -> String{
        return self.rawValue
    }
}
