//
//  ViewController.swift
//  ARkit object detection pre
//
//  Created by e145729 on 2018/12/12.
//  Copyright © 2018 e145729. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
//        let scene = SCNScene(named: "art.scnassets/ship.scn")!
        
        // Set the scene to the view
//        sceneView.scene = scene
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        //物体認識した時、その物体の座標をもとにARの世界座標を構築する
        configuration.detectionObjects = ARReferenceObject.referenceObjects(inGroupNamed: "AR Resources", bundle: Bundle.main)!
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    func objectDescription(){
        
    }
    
    func guideArrow(){
        
    }
    
    // MARK: - ARSCNViewDelegate
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
        
        //AR表示を決定する。"ARReferenceObject.referenceObjects"で認識した座標はanchorに保存されている。（日本語が変）
        if let objectAnchor = anchor as? ARObjectAnchor {
            let plane = SCNPlane(width: CGFloat(objectAnchor.referenceObject.extent.x * 3), height: CGFloat(objectAnchor.referenceObject.extent.y * 2.3)) //認識した座標の原点から表示する平面の大きさを決定する。
            plane.cornerRadius = plane.width * 0.125 //エッジを丸くする。
            
//            let test = "test"
            let objectName = objectAnchor.name!
            var objectNames : [String : String] = ["2Spiderman" : "スパイダーマン","siokosyou" : "test","autoenpitsukezuri" : "autoenpitsukezuri","autoenpitsukezuri2" : "autoenpitsukezuri","telphone" : "telphone","tennennsui" : "tennnennsui","telphone2" : "telphone"]
            var objectAllows : [String : String] = ["2Spiderman" : "スパイダーマン","siokosyou" : "testAllow","autoenpitsukezuri" : "autoenpitsukezuriAllow","autoenpitsukezuri2" : "autoenpitsukezuriAllow","telphone" : "telphoneAllow","telphone2" : "telphoneAllow","tennennsui" : "tennennsuiAllow"]
            print("オブジェクトの名前は「" + objectName + "」")
            print("配列から取得してきた値は「" + objectNames[objectName]! + "」")
            print("配列から取得してきた値は「" + objectAllows[objectName]! + "」")

            let displayScene = SKScene(fileNamed: objectNames[objectName]!) //平面に文字等を追加するために、SKSceneでデザインを作成する。
            
            plane.firstMaterial?.diffuse.contents = displayScene //planeの最初のマテリアルに"contents"を追加する。（追加できるコンテンツはcontentsをcommand+clickで参照）
            plane.firstMaterial?.isDoubleSided = true //firsrMaterialをplaneの両面で表示する。→displaySceneを両面で表示する。
            plane.firstMaterial?.diffuse.contentsTransform = SCNMatrix4Translate(SCNMatrix4MakeScale(1, -1, 1), 0, 1, 0) //コンテンツの表示位置の変更。
            
            let planeNode = SCNNode(geometry: plane)
            planeNode.position = SCNVector3Make(objectAnchor.referenceObject.center.x, objectAnchor.referenceObject.center.y + 0.1, objectAnchor.referenceObject.center.z) //planeNodeの位置を決定する。ちなみにplaneでは大きさのみを決定している。
            
            let billboardConstraints = SCNBillboardConstraint()
            planeNode.constraints = [billboardConstraints]
                
            node.addChildNode(planeNode)
            
            //--------------------test--------------------
            let plane2 = SCNPlane(width: CGFloat(objectAnchor.referenceObject.extent.x * 3), height: CGFloat(objectAnchor.referenceObject.extent.y * 3)) //認識した座標の原点から表示する平面の大きさを決定する。
            plane2.cornerRadius = plane2.width * 0.125 //エッジを丸くする。
            
            let displayScene2 = SKScene(fileNamed: objectAllows[objectName]!) //平面に文字等を追加するために、SKSceneでデザインを作成する。
            
            plane2.firstMaterial?.diffuse.contents = displayScene2 //planeの最初のマテリアルに"contents"を追加する。（追加できるコンテンツはcontentsをcommand+clickで参照）
            plane2.firstMaterial?.isDoubleSided = true //firsrMaterialをplaneの両面で表示する。→displaySceneを両面で表示する。
            plane2.firstMaterial?.diffuse.contentsTransform = SCNMatrix4Translate(SCNMatrix4MakeScale(1, -1, 1), 0, 1, 0) //コンテンツの表示位置の変更。
            
            let planeNode2 = SCNNode(geometry: plane2)
            planeNode2.position = SCNVector3Make(objectAnchor.referenceObject.center.x, objectAnchor.referenceObject.center.y - 0.1, objectAnchor.referenceObject.center.z) //planeNodeの位置を決定する。ちなみにplaneでは大きさのみを決定している。
            
//            let billboardConstraints = SCNBillboardConstraint()
//            planeNode2.constraints = [billboardConstraints]
            
            planeNode2.rotation = SCNVector4(1, 0, 0, 1.5 * Float.pi)
            
            node.addChildNode(planeNode2)
            
            // 認識した物の名前を表示する。物体を認識しているか確認できるように非同期処理にしている。
            DispatchQueue.main.async {
//                var descriptioin : [String : String] = ["2Spiderman" : "スパイダーマン（Spider-Man）は、マーベル・コミックが出版するアメリカンコミック『スパイダーマン』に登場する架空のスーパーヒーロー。スタン・リーとスティーヴ・ディッコにより創造された。", "spiderman" : "スパイダーマン（Spider-Man）は、マーベル・コミックが出版するアメリカンコミック『スパイダーマン』に登場する架空のスーパーヒーロー。スタン・リーとスティーヴ・ディッコにより創造された。", "solt" : "「食卓塩」は、料理に振りかけられるよう小瓶などに入れて食卓に供される塩。", "calender" : "カレンダーとは、日付・曜日などを表形式などで表示し、容易に確認できるものを指す。七曜表（しちようひょう）とも言う。", "koutyakaden" : "1992年2月に発売を開始した「紅茶花伝」は、しっかりとした紅茶本来の味わいが楽しめる、大人のための上質で本格的な紅茶です。「紅茶花伝」という名前は、有名な能の書物である”風姿花伝”をもじって作られたもので、上品で高貴なイメージを表しています。", "oiotya2" : "上質、かつカテキンが豊富な国産茶葉を選定し、また「渋み」「後味のキレ」「濃さ」を引き出す高温で抽出した、健康カテキン量2倍（※）の緑茶飲料です（国産茶葉100％、無香料・無調味）。", "oiotya" : "上質、かつカテキンが豊富な国産茶葉を選定し、また「渋み」「後味のキレ」「濃さ」を引き出す高温で抽出した、健康カテキン量2倍（※）の緑茶飲料です（国産茶葉100％、無香料・無調味）。", "refia" : "わかい　リーフィアほど　ツンと　くるあおくさい　におい。　としおいるとおちばの　ような　においに　なる。","siokosyou" : "調味料。野菜炒めに優しくふりかけるだけで味付けができてしまう。"]
//                var names : [String : String] = ["2Spiderman" : "スパイダーマン", "spiderman" : "スパイダーマン", "solt" : "食卓塩", "calender" : "カレンダー", "koutyakaden" : "紅茶花伝", "oiotya2" : "お〜いお茶", "oiotya" : "お〜いお茶", "refia" : "リーフィア", "siokosyou" : "塩こしょう" ]
//                let objectName = objectAnchor.name
//                print(objectName!)
//                self.textLabel.backgroundColor = UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 70/100)
//                self.textLabel.text = names[objectName!]
////                self.textLabel.frame = CGRect(x:(self.view.bounds.width-210),y:1,width:240,height:21)
//                self.textView.backgroundColor = UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 70/100)
//                self.textView.text = descriptioin[objectName!]
            }
        }
        
        return node
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
